Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC23C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353803AbiCYBfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357446AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3358BF977
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D4BB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F75C340EC;
        Fri, 25 Mar 2022 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171956;
        bh=VmgtAS7E2a0V0lAlh/M+df2CS2dFMxEhYhbFyl46wf4=;
        h=Date:To:From:Subject:From;
        b=d+HEqHfpvCIq92qDBmaV9PT6GrqtkjKVk528e6LQNG+mty01hwcjm6ZDUpLkIDQ8x
         QsqntlbdgGuGDBDdKesObCZHkxJhbtCt5Twngx1jG5v8lhq/G0PhOckUpCaQ/99RWK
         xoQEjZs3wvgzVBxb69E4yJcTE5ZmvKYrO8bM/MOI=
Date:   Thu, 24 Mar 2022 18:32:35 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory_hotplug-drop-arch_free_nodedata.patch removed from -mm tree
Message-Id: <20220325013236.47F75C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: drop arch_free_nodedata
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drop-arch_free_nodedata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: drop arch_free_nodedata

Prior to "mm: handle uninitialized numa nodes gracefully" memory hotplug
used to allocate pgdat when memory has been added to a node
(hotadd_init_pgdat) arch_free_nodedata has been only used in the failure
path because once the pgdat is exported (to be visible by NODA_DATA(nid))
it cannot really be freed because there is no synchronization available
for that.

pgdat is allocated for each possible nodes now so the memory hotplug
doesn't need to do the ever use arch_free_nodedata so drop it.

This patch doesn't introduce any functional change.

Link: https://lkml.kernel.org/r/20220127085305.20890-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c       |    5 -----
 include/linux/memory_hotplug.h |    3 ---
 mm/memory_hotplug.c            |   10 ----------
 3 files changed, 18 deletions(-)

--- a/arch/ia64/mm/discontig.c~mm-memory_hotplug-drop-arch_free_nodedata
+++ a/arch/ia64/mm/discontig.c
@@ -615,11 +615,6 @@ pg_data_t * __init arch_alloc_nodedata(i
 	return memblock_alloc(size, SMP_CACHE_BYTES);
 }
 
-void arch_free_nodedata(pg_data_t *pgdat)
-{
-	kfree(pgdat);
-}
-
 void arch_refresh_nodedata(int update_node, pg_data_t *update_pgdat)
 {
 	pgdat_list[update_node] = update_pgdat;
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-drop-arch_free_nodedata
+++ a/include/linux/memory_hotplug.h
@@ -24,17 +24,14 @@ struct vmem_altmap;
  * node_data[nid] = kzalloc() works well. But it depends on the architecture.
  *
  * In general, generic_alloc_nodedata() is used.
- * Now, arch_free_nodedata() is just defined for error path of node_hot_add.
  *
  */
 extern pg_data_t *arch_alloc_nodedata(int nid);
-extern void arch_free_nodedata(pg_data_t *pgdat);
 extern void arch_refresh_nodedata(int nid, pg_data_t *pgdat);
 
 #else /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
 #define arch_alloc_nodedata(nid)	generic_alloc_nodedata(nid)
-#define arch_free_nodedata(pgdat)	generic_free_nodedata(pgdat)
 
 #ifdef CONFIG_NUMA
 /*
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-arch_free_nodedata
+++ a/mm/memory_hotplug.c
@@ -1217,16 +1217,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	return pgdat;
 }
 
-static void rollback_node_hotadd(int nid)
-{
-	pg_data_t *pgdat = NODE_DATA(nid);
-
-	arch_refresh_nodedata(nid, NULL);
-	free_percpu(pgdat->per_cpu_nodestats);
-	arch_free_nodedata(pgdat);
-}
-
-
 /*
  * __try_online_node - online a node if offlined
  * @nid: the node ID
_

Patches currently in -mm which might be from mhocko@suse.com are


