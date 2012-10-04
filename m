From: akpm@linux-foundation.org
Subject: [folded-dropped] idr-rename-max_level-to-max_idr_level-fix-fix-2.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:57:02 -0700
Message-ID: <20121004235703.730005C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:55800 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2JDX5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:57:06 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so74814fae.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:57:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bernd@petrovitsch.priv.at, fengguang.wu@intel.com, glommer@parallels.com, wharms@bfs.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2
has been removed from the -mm tree.  Its filename was
     idr-rename-max_level-to-max_idr_level-fix-fix-2.patch

This patch was dropped because it was folded into idr-rename-max_level-to-max_idr_level.patch

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

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

