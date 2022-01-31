Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A36C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiAaWSw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:18:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37760 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWSw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:18:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BF4615AB
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E474CC340E8;
        Mon, 31 Jan 2022 22:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667531;
        bh=u35T9e9SD086NlTRKnGgQgI58gGCdPtFAnQjELyoPAw=;
        h=Date:To:From:Subject:From;
        b=TgwLrSd2h9YT/L4S5PvY4mSDc3+Kcx3ySM7JG5d3V4ipaWGbFRMZmlGB6YsmKtrFs
         PUe2yb+oJsflBd2kSTuUimqw2xsgVj5Q9y9Nt63EZSaQ1egIk98cTth3Gdkm23lRnB
         ANGhMbh3zUo+wPIJSWfpMEWdYkSB+RwU8z4A8JUI=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:18:49 -0800
Date:   Mon, 31 Jan 2022 14:18:49 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-drop-arch_free_nodedata.patch added to -mm tree
Message-Id: <20220131221849.E474CC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: drop arch_free_nodedata
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-arch_free_nodedata.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-arch_free_nodedata.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-arch_free_nodedata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
mm-handle-uninitialized-numa-nodes-gracefully.patch
mm-memory_hotplug-drop-arch_free_nodedata.patch
mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

