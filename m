From: akpm@linux-foundation.org
Subject: +
 mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
 added to -mm tree
Date: Tue, 24 May 2016 10:40:11 -0700
Message-ID: <574491fb.969Mygc4NHeED1JK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbcEXRkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2016 13:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix
has been added to the -mm tree.  Its filename is
     mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch

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
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

