Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B450CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjJRVhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA9CD69
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD64DC433CB;
        Wed, 18 Oct 2023 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664953;
        bh=MYCwMiPBxfay2LJMezY6rGB6XlqO/RaYGbaAote9HEM=;
        h=Date:To:From:Subject:From;
        b=GpGyBL7flz/0KIq6OiEqfzEdFy365BZrcLOEGCL3s7dTZi5azzPniqJqKfVRamOcW
         WVDDsmduI/bVZ4n6kCV9/xhJSrTu+GREmv9diWr1GdFbsRVVwTaSVFUBqzu75SG6jm
         jbyBkcKtDAofayfoKvQEG6SSUNrVHrcKnEqe52as=
Date:   Wed, 18 Oct 2023 14:35:53 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        riel@surriel.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        fvdl@google.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-only-transfer-the-memcg-data-for-migration.patch removed from -mm tree
Message-Id: <20231018213553.BD64DC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcontrol: only transfer the memcg data for migration
has been removed from the -mm tree.  Its filename was
     memcontrol-only-transfer-the-memcg-data-for-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: memcontrol: only transfer the memcg data for migration
Date: Fri, 6 Oct 2023 11:46:27 -0700

For most migration use cases, only transfer the memcg data from the old
folio to the new folio, and clear the old folio's memcg data.  No charging
and uncharging will be done.

This shaves off some work on the migration path, and avoids the temporary
double charging of a folio during its migration.

The only exception is replace_page_cache_folio(), which will use the old
mem_cgroup_migrate() (now renamed to mem_cgroup_replace_folio).  In that
context, the isolation of the old page isn't quite as thorough as with
migration, so we cannot use our new implementation directly.

This patch is the result of the following discussion on the new hugetlb
memcg accounting behavior:

https://lore.kernel.org/lkml/20231003171329.GB314430@monkey/

Link: https://lkml.kernel.org/r/20231006184629.155543-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++++
 mm/filemap.c               |    2 -
 mm/memcontrol.c            |   40 ++++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-only-transfer-the-memcg-data-for-migration
+++ a/include/linux/memcontrol.h
@@ -707,6 +707,8 @@ static inline void mem_cgroup_uncharge_l
 
 void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
+void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
+
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
 /**
@@ -1279,6 +1281,11 @@ static inline void mem_cgroup_cancel_cha
 {
 }
 
+static inline void mem_cgroup_replace_folio(struct folio *old,
+		struct folio *new)
+{
+}
+
 static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
--- a/mm/filemap.c~memcontrol-only-transfer-the-memcg-data-for-migration
+++ a/mm/filemap.c
@@ -816,7 +816,7 @@ void replace_page_cache_folio(struct fol
 	new->mapping = mapping;
 	new->index = offset;
 
-	mem_cgroup_migrate(old, new);
+	mem_cgroup_replace_folio(old, new);
 
 	xas_lock_irq(&xas);
 	xas_store(&xas, new);
--- a/mm/memcontrol.c~memcontrol-only-transfer-the-memcg-data-for-migration
+++ a/mm/memcontrol.c
@@ -7292,16 +7292,17 @@ void __mem_cgroup_uncharge_list(struct l
 }
 
 /**
- * mem_cgroup_migrate - Charge a folio's replacement.
+ * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
  * @new: Replacement folio.
  *
  * Charge @new as a replacement folio for @old. @old will
- * be uncharged upon free.
+ * be uncharged upon free. This is only used by the page cache
+ * (in replace_page_cache_folio()).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
-void mem_cgroup_migrate(struct folio *old, struct folio *new)
+void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 {
 	struct mem_cgroup *memcg;
 	long nr_pages = folio_nr_pages(new);
@@ -7340,6 +7341,39 @@ void mem_cgroup_migrate(struct folio *ol
 	local_irq_restore(flags);
 }
 
+/**
+ * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
+ * @old: Currently circulating folio.
+ * @new: Replacement folio.
+ *
+ * Transfer the memcg data from the old folio to the new folio for migration.
+ * The old folio's data info will be cleared. Note that the memory counters
+ * will remain unchanged throughout the process.
+ *
+ * Both folios must be locked, @new->mapping must be set up.
+ */
+void mem_cgroup_migrate(struct folio *old, struct folio *new)
+{
+	struct mem_cgroup *memcg;
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
+	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
+	VM_BUG_ON_FOLIO(folio_test_anon(old) != folio_test_anon(new), new);
+	VM_BUG_ON_FOLIO(folio_nr_pages(old) != folio_nr_pages(new), new);
+
+	if (mem_cgroup_disabled())
+		return;
+
+	memcg = folio_memcg(old);
+	VM_WARN_ON_ONCE_FOLIO(!memcg, old);
+	if (!memcg)
+		return;
+
+	/* Transfer the charge and the css ref */
+	commit_charge(new, memcg);
+	old->memcg_data = 0;
+}
+
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

