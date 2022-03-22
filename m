Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BC5C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiCVVs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbiCVVsi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F205FF32
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8FEB81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9C2C340F2;
        Tue, 22 Mar 2022 21:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985627;
        bh=fDWYER1e+boei8jJvhe+8X1MXU40/XACDM3uTEQN10E=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=u9VBJllCl8ZZR0MU5ydVooFBMMawP6BKJ1SwOjOavnzhoZpNvuSDz2rX5+jT2AYJg
         A6djqbGX4xRIMC6kxKeX+h6nCbKLljgwfrlm2R5KRhlJD+mb9VdIEu+IA1DYoNywnh
         9sxYAbpu8RMdvNrENfGyyZIy4YHt1iOZ4fbLCGtA=
Date:   Tue, 22 Mar 2022 14:47:06 -0700
To:     tj@kernel.org, rppt@linux.ibm.com, raquini@redhat.com,
        osalvador@suse.de, npache@redhat.com, mhocko@suse.com,
        eric.dumazet@gmail.com, dennis@kernel.org, david@redhat.com,
        cl@linux.com, amakhalov@vmware.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 169/227] memcg: do not tweak node in alloc_mem_cgroup_per_node_info
Message-Id: <20220322214707.5F9C2C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: memcg: do not tweak node in alloc_mem_cgroup_per_node_info

alloc_mem_cgroup_per_node_info is allocated for each possible node and
this used to be a problem because !node_online nodes didn't have
appropriate data structure allocated.  This has changed by "mm: handle
uninitialized numa nodes gracefully" so we can drop the special casing
here.

Link: https://lkml.kernel.org/r/20220127085305.20890-7-mhocko@kernel.org
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael Aquini <raquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info
+++ a/mm/memcontrol.c
@@ -5020,18 +5020,8 @@ struct mem_cgroup *mem_cgroup_from_id(un
 static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
-	int tmp = node;
-	/*
-	 * This routine is called against possible nodes.
-	 * But it's BUG to call kmalloc() against offline node.
-	 *
-	 * TODO: this routine can waste much memory for nodes which will
-	 *       never be onlined. It's better to use memory hotplug callback
-	 *       function.
-	 */
-	if (!node_state(node, N_NORMAL_MEMORY))
-		tmp = -1;
-	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
+
+	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, node);
 	if (!pn)
 		return 1;
 
_
