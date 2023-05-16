Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEECC7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjEPWW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjEPWW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CF6A4E
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CF863FEB
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1ECC433EF;
        Tue, 16 May 2023 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275773;
        bh=pICs5aZAwPUp51jtWwvBJhM/mAIf4bP8zvr8TCjZl8o=;
        h=Date:To:From:Subject:From;
        b=I26wbJ6wwQnE+r1C8Nm5WzT5ZSV75osje0uWGAwC5a++AxO7KCSwGYQIrO7jhsYDw
         Uxd7NwXmsqsj+0+jthk7e8/9PrlpJV80jOi99iPffjr8KmN+5L/TtnWMdPnPC49a0O
         SK7dPhxisb6ku+uCghi3Z0Xk6yAMue0mXLtDBvKg=
Date:   Tue, 16 May 2023 15:22:52 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-pm_-function-into-power.patch added to mm-unstable branch
Message-Id: <20230516222253.0B1ECC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move pm_* function into power
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-pm_-function-into-power.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-pm_-function-into-power.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move pm_* function into power
Date: Tue, 16 May 2023 14:38:18 +0800

pm_restrict_gfp_mask()/pm_restore_gfp_mask() only used in power, let's
move them out of page_alloc.c.

Adding a general gfp_has_io_fs() function which return true if gfp with
both __GFP_IO and __GFP_FS flags, then use it inside of
pm_suspended_storage(), also the pm_suspended_storage() is moved into
suspend.h.

Link: https://lkml.kernel.org/r/20230516063821.121844-11-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |   15 ++++-----------
 include/linux/suspend.h |    6 ++++++
 kernel/power/main.c     |   27 +++++++++++++++++++++++++++
 kernel/power/power.h    |    5 +++++
 mm/page_alloc.c         |   38 --------------------------------------
 mm/swapfile.c           |    1 +
 6 files changed, 43 insertions(+), 49 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-move-pm_-function-into-power
+++ a/include/linux/gfp.h
@@ -338,19 +338,12 @@ extern gfp_t gfp_allowed_mask;
 /* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
 
-extern void pm_restrict_gfp_mask(void);
-extern void pm_restore_gfp_mask(void);
-
-extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
-
-#ifdef CONFIG_PM_SLEEP
-extern bool pm_suspended_storage(void);
-#else
-static inline bool pm_suspended_storage(void)
+static inline bool gfp_has_io_fs(gfp_t gfp)
 {
-	return false;
+	return (gfp & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS);
 }
-#endif /* CONFIG_PM_SLEEP */
+
+extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
 
 #ifdef CONFIG_CONTIG_ALLOC
 /* The below functions must be run on a range from a single zone. */
--- a/include/linux/suspend.h~mm-page_alloc-move-pm_-function-into-power
+++ a/include/linux/suspend.h
@@ -502,6 +502,11 @@ extern void pm_report_max_hw_sleep(u64 t
 extern bool events_check_enabled;
 extern suspend_state_t pm_suspend_target_state;
 
+static inline bool pm_suspended_storage(void)
+{
+	return !gfp_has_io_fs(gfp_allowed_mask);
+}
+
 extern bool pm_wakeup_pending(void);
 extern void pm_system_wakeup(void);
 extern void pm_system_cancel_wakeup(void);
@@ -535,6 +540,7 @@ static inline void ksys_sync_helper(void
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
+static inline bool pm_suspended_storage(void) { return false; }
 static inline bool pm_wakeup_pending(void) { return false; }
 static inline void pm_system_wakeup(void) {}
 static inline void pm_wakeup_clear(bool reset) {}
--- a/kernel/power/main.c~mm-page_alloc-move-pm_-function-into-power
+++ a/kernel/power/main.c
@@ -21,6 +21,33 @@
 #include "power.h"
 
 #ifdef CONFIG_PM_SLEEP
+/*
+ * The following functions are used by the suspend/hibernate code to temporarily
+ * change gfp_allowed_mask in order to avoid using I/O during memory allocations
+ * while devices are suspended.  To avoid races with the suspend/hibernate code,
+ * they should always be called with system_transition_mutex held
+ * (gfp_allowed_mask also should only be modified with system_transition_mutex
+ * held, unless the suspend/hibernate code is guaranteed not to run in parallel
+ * with that modification).
+ */
+static gfp_t saved_gfp_mask;
+
+void pm_restore_gfp_mask(void)
+{
+	WARN_ON(!mutex_is_locked(&system_transition_mutex));
+	if (saved_gfp_mask) {
+		gfp_allowed_mask = saved_gfp_mask;
+		saved_gfp_mask = 0;
+	}
+}
+
+void pm_restrict_gfp_mask(void)
+{
+	WARN_ON(!mutex_is_locked(&system_transition_mutex));
+	WARN_ON(saved_gfp_mask);
+	saved_gfp_mask = gfp_allowed_mask;
+	gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
+}
 
 unsigned int lock_system_sleep(void)
 {
--- a/kernel/power/power.h~mm-page_alloc-move-pm_-function-into-power
+++ a/kernel/power/power.h
@@ -216,6 +216,11 @@ static inline void suspend_test_finish(c
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain_robust(unsigned long val_up, unsigned long val_down);
 extern int pm_notifier_call_chain(unsigned long val);
+void pm_restrict_gfp_mask(void);
+void pm_restore_gfp_mask(void);
+#else
+static inline void pm_restrict_gfp_mask(void) {}
+static inline void pm_restore_gfp_mask(void) {}
 #endif
 
 #ifdef CONFIG_HIGHMEM
--- a/mm/page_alloc.c~mm-page_alloc-move-pm_-function-into-power
+++ a/mm/page_alloc.c
@@ -227,44 +227,6 @@ static inline void set_pcppage_migratety
 	page->index = migratetype;
 }
 
-#ifdef CONFIG_PM_SLEEP
-/*
- * The following functions are used by the suspend/hibernate code to temporarily
- * change gfp_allowed_mask in order to avoid using I/O during memory allocations
- * while devices are suspended.  To avoid races with the suspend/hibernate code,
- * they should always be called with system_transition_mutex held
- * (gfp_allowed_mask also should only be modified with system_transition_mutex
- * held, unless the suspend/hibernate code is guaranteed not to run in parallel
- * with that modification).
- */
-
-static gfp_t saved_gfp_mask;
-
-void pm_restore_gfp_mask(void)
-{
-	WARN_ON(!mutex_is_locked(&system_transition_mutex));
-	if (saved_gfp_mask) {
-		gfp_allowed_mask = saved_gfp_mask;
-		saved_gfp_mask = 0;
-	}
-}
-
-void pm_restrict_gfp_mask(void)
-{
-	WARN_ON(!mutex_is_locked(&system_transition_mutex));
-	WARN_ON(saved_gfp_mask);
-	saved_gfp_mask = gfp_allowed_mask;
-	gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
-}
-
-bool pm_suspended_storage(void)
-{
-	if ((gfp_allowed_mask & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS))
-		return false;
-	return true;
-}
-#endif /* CONFIG_PM_SLEEP */
-
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 unsigned int pageblock_order __read_mostly;
 #endif
--- a/mm/swapfile.c~mm-page_alloc-move-pm_-function-into-power
+++ a/mm/swapfile.c
@@ -41,6 +41,7 @@
 #include <linux/swap_slots.h>
 #include <linux/sort.h>
 #include <linux/completion.h>
+#include <linux/suspend.h>
 
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

