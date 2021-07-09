Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC2DC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A006613D3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhGIVfe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhGIVfe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4EE613D0;
        Fri,  9 Jul 2021 21:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866369;
        bh=zohgdIF1v+x1PnoBb2TXmP4fWmxXKrFvXsViNcgF3sU=;
        h=Date:From:To:Subject:From;
        b=jWtRZR0QwAdcM3UAd6KFrMO1NY6K4nP7Mm2uietPSA4NmVuuUGjS+N9Tc0DK2MMwg
         Oc74HvFcexWK9brxVwJUUP6Y6LkhEBg1Zfp7vHzd72vAznCgZWwdloMBgpY0YVPTHX
         wVGeTcmO5oSDnAtYoyGyk1NnjJdZmK/7JakumhMo=
Date:   Fri, 09 Jul 2021 14:32:49 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, dennis@kernel.org, jglisse@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, tj@kernel.org
Subject:  [merged] mm-fix-spelling-mistakes-in-header-files.patch
 removed from -mm tree
Message-ID: <20210709213249.eMDNmS4-t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix spelling mistakes in header files
has been removed from the -mm tree.  Its filename was
     mm-fix-spelling-mistakes-in-header-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm: fix spelling mistakes in header files

Fix some spelling mistakes in comments:
successfull ==> successful
potentialy ==> potentially
alloced ==> allocated
indicies ==> indices
wont ==> won't
resposible ==> responsible
dirtyness ==> dirtiness
droppped ==> dropped
alread ==> already
occured ==> occurred
interupts ==> interrupts
extention ==> extension
slighly ==> slightly
Dont't ==> Don't

Link: https://lkml.kernel.org/r/20210531034849.9549-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h   |    4 ++--
 include/linux/hmm.h          |    2 +-
 include/linux/hugetlb.h      |    6 +++---
 include/linux/list_lru.h     |    4 ++--
 include/linux/mmu_notifier.h |    8 ++++----
 include/linux/percpu-defs.h  |    2 +-
 include/linux/shrinker.h     |    2 +-
 include/linux/vmalloc.h      |    4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/compaction.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/compaction.h
@@ -35,12 +35,12 @@ enum compact_result {
 	COMPACT_CONTINUE,
 
 	/*
-	 * The full zone was compacted scanned but wasn't successfull to compact
+	 * The full zone was compacted scanned but wasn't successful to compact
 	 * suitable pages.
 	 */
 	COMPACT_COMPLETE,
 	/*
-	 * direct compaction has scanned part of the zone but wasn't successfull
+	 * direct compaction has scanned part of the zone but wasn't successful
 	 * to compact suitable pages.
 	 */
 	COMPACT_PARTIAL_SKIPPED,
--- a/include/linux/hmm.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/hmm.h
@@ -113,7 +113,7 @@ int hmm_range_fault(struct hmm_range *ra
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
  *
  * When waiting for mmu notifiers we need some kind of time out otherwise we
- * could potentialy wait for ever, 1000ms ie 1s sounds like a long time to
+ * could potentially wait for ever, 1000ms ie 1s sounds like a long time to
  * wait already.
  */
 #define HMM_RANGE_DEFAULT_TIMEOUT 1000
--- a/include/linux/hugetlb.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/hugetlb.h
@@ -51,7 +51,7 @@ struct hugepage_subpool {
 	long count;
 	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
 	long used_hpages;	/* Used count against maximum, includes */
-				/* both alloced and reserved pages. */
+				/* both allocated and reserved pages. */
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
@@ -85,7 +85,7 @@ struct resv_map {
  * by a resv_map's lock.  The set of regions within the resv_map represent
  * reservations for huge pages, or huge pages that have already been
  * instantiated within the map.  The from and to elements are huge page
- * indicies into the associated mapping.  from indicates the starting index
+ * indices into the associated mapping.  from indicates the starting index
  * of the region.  to represents the first index past the end of  the region.
  *
  * For example, a file region structure with from == 0 and to == 4 represents
@@ -797,7 +797,7 @@ static inline bool hugepage_migration_su
  * It determines whether or not a huge page should be placed on
  * movable zone or not. Movability of any huge page should be
  * required only if huge page size is supported for migration.
- * There wont be any reason for the huge page to be movable if
+ * There won't be any reason for the huge page to be movable if
  * it is not migratable to start with. Also the size of the huge
  * page should be large enough to be placed under a movable zone
  * and still feasible enough to be migratable. Just the presence
--- a/include/linux/list_lru.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/list_lru.h
@@ -146,7 +146,7 @@ typedef enum lru_status (*list_lru_walk_
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
- * @isolate: callback function that is resposible for deciding what to do with
+ * @isolate: callback function that is responsible for deciding what to do with
  *  the item currently being scanned
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
@@ -172,7 +172,7 @@ unsigned long list_lru_walk_one(struct l
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
- * @isolate: callback function that is resposible for deciding what to do with
+ * @isolate: callback function that is responsible for deciding what to do with
  *  the item currently being scanned
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
--- a/include/linux/mmu_notifier.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/mmu_notifier.h
@@ -33,7 +33,7 @@ struct mmu_interval_notifier;
  *
  * @MMU_NOTIFY_SOFT_DIRTY: soft dirty accounting (still same page and same
  * access flags). User should soft dirty the page in the end callback to make
- * sure that anyone relying on soft dirtyness catch pages that might be written
+ * sure that anyone relying on soft dirtiness catch pages that might be written
  * through non CPU mappings.
  *
  * @MMU_NOTIFY_RELEASE: used during mmu_interval_notifier invalidate to signal
@@ -167,7 +167,7 @@ struct mmu_notifier_ops {
 	 * decrease the refcount. If the refcount is decreased on
 	 * invalidate_range_start() then the VM can free pages as page
 	 * table entries are removed.  If the refcount is only
-	 * droppped on invalidate_range_end() then the driver itself
+	 * dropped on invalidate_range_end() then the driver itself
 	 * will drop the last refcount but it must take care to flush
 	 * any secondary tlb before doing the final free on the
 	 * page. Pages will no longer be referenced by the linux
@@ -196,7 +196,7 @@ struct mmu_notifier_ops {
 	 * If invalidate_range() is used to manage a non-CPU TLB with
 	 * shared page-tables, it not necessary to implement the
 	 * invalidate_range_start()/end() notifiers, as
-	 * invalidate_range() alread catches the points in time when an
+	 * invalidate_range() already catches the points in time when an
 	 * external TLB range needs to be flushed. For more in depth
 	 * discussion on this see Documentation/vm/mmu_notifier.rst
 	 *
@@ -369,7 +369,7 @@ mmu_interval_read_retry(struct mmu_inter
  * mmu_interval_read_retry() will return true.
  *
  * False is not reliable and only suggests a collision may not have
- * occured. It can be called many times and does not have to hold the user
+ * occurred. It can be called many times and does not have to hold the user
  * provided lock.
  *
  * This call can be used as part of loops and other expensive operations to
--- a/include/linux/percpu-defs.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/percpu-defs.h
@@ -412,7 +412,7 @@ do {									\
  * instead.
  *
  * If there is no other protection through preempt disable and/or disabling
- * interupts then one of these RMW operations can show unexpected behavior
+ * interrupts then one of these RMW operations can show unexpected behavior
  * because the execution thread was rescheduled on another processor or an
  * interrupt occurred and the same percpu variable was modified from the
  * interrupt context.
--- a/include/linux/shrinker.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/shrinker.h
@@ -4,7 +4,7 @@
 
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
- * We consolidate the values for easier extention later.
+ * We consolidate the values for easier extension later.
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
--- a/include/linux/vmalloc.h~mm-fix-spelling-mistakes-in-header-files
+++ a/include/linux/vmalloc.h
@@ -29,7 +29,7 @@ struct notifier_block;		/* in notifier.h
 #define VM_NO_HUGE_VMAP		0x00000400	/* force PAGE_SIZE pte mapping */
 
 /*
- * VM_KASAN is used slighly differently depending on CONFIG_KASAN_VMALLOC.
+ * VM_KASAN is used slightly differently depending on CONFIG_KASAN_VMALLOC.
  *
  * If IS_ENABLED(CONFIG_KASAN_VMALLOC), VM_KASAN is set on a vm_struct after
  * shadow memory has been mapped. It's used to handle allocation errors so that
@@ -247,7 +247,7 @@ static inline void set_vm_flush_reset_pe
 extern long vread(char *buf, char *addr, unsigned long count);
 
 /*
- *	Internals.  Dont't use..
+ *	Internals.  Don't use..
  */
 extern struct list_head vmap_area_list;
 extern __init void vm_area_add_early(struct vm_struct *vm);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


