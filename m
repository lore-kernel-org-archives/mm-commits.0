Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA454C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiAaWTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:19:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B544C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 14:19:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A8C8615AE
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21E4C340E8;
        Mon, 31 Jan 2022 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667543;
        bh=4NuLG8bXR0rm4kmfHRX0EHvujDoiqz0NcMI4qDfCMcA=;
        h=Date:To:From:Subject:From;
        b=nHaicMps6NvN5tg/rO+OSNAg9znxsWN6zb8zPYljFTCE7ffeYoYV7QgciAXo/38rO
         LG0tiTT1wW0N4Ilf4hSQK5CmaDsyQbrY4qF2kjF7drh9G3ke7x9pNzsigKW75I9bsb
         Lp3GVXcsqc+mU5eFXJG/b7H10XBXObZylf+0NPuI=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:19:01 -0800
Date:   Mon, 31 Jan 2022 14:19:01 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        raquini@redhat.com, osalvador@suse.de, npache@redhat.com,
        mhocko@suse.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch added to -mm tree
Message-Id: <20220131221901.F21E4C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not tweak node in alloc_mem_cgroup_per_node_info
has been added to the -mm tree.  Its filename is
     memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: memcg: do not tweak node in alloc_mem_cgroup_per_node_info

alloc_mem_cgroup_per_node_info is allocated for each possible node and
this used to be a problem because not !node_online nodes didn't have
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
@@ -5067,18 +5067,8 @@ struct mem_cgroup *mem_cgroup_from_id(un
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

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

