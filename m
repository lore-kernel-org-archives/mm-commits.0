Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59140E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjJFTUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbjJFTUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6378C2
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336FDC433C8;
        Fri,  6 Oct 2023 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620017;
        bh=iKmZ/D6nNaUGshNERiejMwgjJ60GGRwvFBnVjJelXjA=;
        h=Date:To:From:Subject:From;
        b=NmkXdtTHyChJWLpeTP13PtvRe681h/2cy40UqiRxQlS1LMxBRqZ3P+nIaw7NUvLRz
         SCf3j2tffOzMELDxsgfMjpI6FRLabGNKOTlhsutrx8F3irjGYjjAEv0Hq8nALBszth
         t7u4HDYR3vsbrkxXDcej00bfNwqaYw1MWhSTW+l0=
Date:   Fri, 06 Oct 2023 12:20:15 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        riel@surriel.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        fvdl@google.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-only-transfer-the-memcg-data-for-migration.patch added to mm-unstable branch
Message-Id: <20231006192017.336FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: only transfer the memcg data for migration
has been added to the -mm mm-unstable branch.  Its filename is
     memcontrol-only-transfer-the-memcg-data-for-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-only-transfer-the-memcg-data-for-migration.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -724,6 +724,8 @@ static inline void mem_cgroup_uncharge_l
 
 void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
+void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
+
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
 /**
@@ -1301,6 +1303,11 @@ static inline void mem_cgroup_cancel_cha
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
@@ -7436,16 +7436,17 @@ void __mem_cgroup_uncharge_list(struct l
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
@@ -7484,6 +7485,39 @@ void mem_cgroup_migrate(struct folio *ol
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

zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
memcontrol-only-transfer-the-memcg-data-for-migration.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

