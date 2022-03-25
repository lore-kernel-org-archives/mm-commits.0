Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F705C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357454AbiCYBfr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357457AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC94C12C4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A147CE279F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0C6C340EC;
        Fri, 25 Mar 2022 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171959;
        bh=OjpuqOMTtLA22yjHbHyaM2egBbloycuO+nWgcy8FRVA=;
        h=Date:To:From:Subject:From;
        b=VRxMVFZ2weH3RhZsbk3xqIWTEDAUj5JQ4SxSUFti/w204X3IxAsF8EWnEydRGY18m
         qJtckZS0ezSRq81omfWEEGHCV5QgCV0OZPIoQ6x0aK8P9fAvHbWNzIZqp6V/wwiTs8
         CpmWG6G4kcvMT9NfEXR+KrJUXrnAMHHasIivFH+0=
Date:   Thu, 24 Mar 2022 18:32:39 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        raquini@redhat.com, osalvador@suse.de, npache@redhat.com,
        mhocko@suse.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch removed from -mm tree
Message-Id: <20220325013239.AC0C6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not tweak node in alloc_mem_cgroup_per_node_info
has been removed from the -mm tree.  Its filename was
     memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch

