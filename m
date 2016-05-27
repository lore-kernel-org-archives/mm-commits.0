From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
 removed from -mm tree
Date: Fri, 27 May 2016 13:00:33 -0700
Message-ID: <5748a761.cERT8XhpPL35HdQr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcE0UAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix
has been removed from the -mm tree.  Its filename was
     mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch

This patch was dropped because it was folded into mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix

fix build-breaking typos

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix include/linux/page_idle.h
--- a/include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix
+++ a/include/linux/page_idle.h
@@ -48,7 +48,7 @@ static inline bool page_is_young(struct
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return false;
 
 	return test_bit(PAGE_EXT_YOUNG, &page_ext->flags);
@@ -58,7 +58,7 @@ static inline void set_page_young(struct
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return;
 
 	set_bit(PAGE_EXT_YOUNG, &page_ext->flags);
@@ -68,7 +68,7 @@ static inline bool test_and_clear_page_y
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return false;
 
 	return test_and_clear_bit(PAGE_EXT_YOUNG, &page_ext->flags);
@@ -78,7 +78,7 @@ static inline bool page_is_idle(struct p
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return false;
 
 	return test_bit(PAGE_EXT_IDLE, &page_ext->flags);
@@ -88,7 +88,7 @@ static inline void set_page_idle(struct
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return;
 
 	set_bit(PAGE_EXT_IDLE, &page_ext->flags);
@@ -98,7 +98,7 @@ static inline void clear_page_idle(struc
 {
 	struct page_ext *page_ext;
 	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)
+	if (unlikely(!page_ext))
 		return;
 
 	clear_bit(PAGE_EXT_IDLE, &page_ext->flags);
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
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

