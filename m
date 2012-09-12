From: akpm@linux-foundation.org
Subject: + idr-rename-max_level-to-max_idr_level-fix-fix-2.patch added to -mm tree
Date: Wed, 12 Sep 2012 15:23:01 -0700
Message-ID: <20120912231110.11ED31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47845 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2ILXLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 19:11:12 -0400
Received: by vbis24 with SMTP id s24so258114vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 16:11:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bernd@petrovitsch.priv.at, fengguang.wu@intel.com, glommer@parallels.com, wharms@bfs.de


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2
has been added to the -mm tree.  Its filename is
     idr-rename-max_level-to-max_idr_level-fix-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2

ho hum

Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: walter harms <wharms@bfs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/idr.c~idr-rename-max_level-to-max_idr_level-fix-fix-2 lib/idr.c
--- a/lib/idr.c~idr-rename-max_level-to-max_idr_level-fix-fix-2
+++ a/lib/idr.c
@@ -223,7 +223,7 @@ build_up:
 	 * Add a new layer to the top of the tree if the requested
 	 * id is larger than the currently allocated space.
 	 */
-	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
+	while ((layers < (MAX_IDR_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
 		layers++;
 		if (!p->count) {
 			/* special case: if the tree is currently empty,
@@ -265,7 +265,7 @@ build_up:
 
 static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
 {
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int id;
 
 	id = idr_get_empty_slot(idp, starting_id, pa);
@@ -357,7 +357,7 @@ static void idr_remove_warning(int id)
 static void sub_remove(struct idr *idp, int shift, int id)
 {
 	struct idr_layer *p = idp->top;
-	struct idr_layer **pa[MAX_LEVEL];
+	struct idr_layer **pa[MAX_IDR_LEVEL];
 	struct idr_layer ***paa = &pa[0];
 	struct idr_layer *to_free;
 	int n;
@@ -451,7 +451,7 @@ void idr_remove_all(struct idr *idp)
 	int n, id, max;
 	int bt_mask;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
@@ -555,7 +555,7 @@ int idr_for_each(struct idr *idp,
 {
 	int n, id, max, error = 0;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
@@ -601,7 +601,7 @@ EXPORT_SYMBOL(idr_for_each);
  */
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
-	struct idr_layer *p, *pa[MAX_LEVEL];
+	struct idr_layer *p, *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 	int id = *nextidp;
 	int n, max;
@@ -780,7 +780,7 @@ EXPORT_SYMBOL(ida_pre_get);
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 	int idr_id = starting_id / IDA_BITMAP_BITS;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

