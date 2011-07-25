From: akpm@linux-foundation.org
Subject: [folded] mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:54:06 -0700
Message-ID: <201107252354.p6PNs6uV006071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GYXyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ian.campbell@citrix.com, mm-commits@vger.kernel.org


The patch titled
     mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#24: FILE: include/linux/page-flags.h:138:
+static inline int Page##uname(const struct page *page) ^I^I^I\$

WARNING: please, no space before tabs
#33: FILE: include/linux/page-flags.h:176:
+static inline int Page##uname(const struct page *page) ^I^I^I\$

total: 0 errors, 2 warnings, 16 lines checked

./patches/mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes
+++ a/include/linux/page-flags.h
@@ -135,7 +135,7 @@ enum pageflags {
  * Macros to create function definitions for page flags
  */
 #define TESTPAGEFLAG(uname, lname)					\
-static inline int Page##uname(const struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return test_bit(PG_##lname, &page->flags); }
 
 #define SETPAGEFLAG(uname, lname)					\
@@ -173,7 +173,7 @@ static inline int __TestClearPage##uname
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
-static inline int Page##uname(const struct page *page) 			\
+static inline int Page##uname(const struct page *page)			\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

