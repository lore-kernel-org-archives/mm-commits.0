From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 27 May 2016 13:00:39 -0700
Message-ID: <5748a767.+/Lzyy9jeUM6g9oH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbcE0UAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes

WARNING: Missing a blank line after declarations
#34: FILE: include/linux/page_idle.h:50:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

WARNING: Missing a blank line after declarations
#45: FILE: include/linux/page_idle.h:60:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

WARNING: Missing a blank line after declarations
#57: FILE: include/linux/page_idle.h:70:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

WARNING: Missing a blank line after declarations
#68: FILE: include/linux/page_idle.h:80:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

WARNING: Missing a blank line after declarations
#79: FILE: include/linux/page_idle.h:90:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

WARNING: Missing a blank line after declarations
#90: FILE: include/linux/page_idle.h:100:
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);

total: 1 errors, 6 warnings, 196 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes include/linux/page_idle.h
--- a/include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes
+++ a/include/linux/page_idle.h
@@ -46,8 +46,8 @@ extern struct page_ext_operations page_i
 
 static inline bool page_is_young(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return false;
 
@@ -56,8 +56,8 @@ static inline bool page_is_young(struct
 
 static inline void set_page_young(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return;
 
@@ -66,8 +66,8 @@ static inline void set_page_young(struct
 
 static inline bool test_and_clear_page_young(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return false;
 
@@ -76,8 +76,8 @@ static inline bool test_and_clear_page_y
 
 static inline bool page_is_idle(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return false;
 
@@ -86,8 +86,8 @@ static inline bool page_is_idle(struct p
 
 static inline void set_page_idle(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return;
 
@@ -96,8 +96,8 @@ static inline void set_page_idle(struct
 
 static inline void clear_page_idle(struct page *page)
 {
-	struct page_ext *page_ext;
-	page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
 		return;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-fix.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

