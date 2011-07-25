From: akpm@linux-foundation.org
Subject: [folded] mm-make-some-struct-pages-const-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:53:28 -0700
Message-ID: <201107252353.p6PNrSpS006040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GYXyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:54:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, ian.campbell@citrix.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm-make-some-struct-pages-const-fix
has been removed from the -mm tree.  Its filename was
     mm-make-some-struct-pages-const-fix.patch

This patch was dropped because it was folded into mm-make-some-struct-pages-const.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-make-some-struct-pages-const-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/mm.h: In function 'lowmem_page_address':
include/linux/mm.h:723: warning: initialization discards qualifiers from pointer target type
In file included from include/linux/ring_buffer.h:5,
                 from include/linux/ftrace_event.h:4,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:77,
                 from fs/aio.c:17:
include/linux/mm.h: In function 'lowmem_page_address':
include/linux/mm.h:723: warning: initialization discards qualifiers from pointer target type

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-make-some-struct-pages-const-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-make-some-struct-pages-const-fix
+++ a/include/linux/mm.h
@@ -720,7 +720,7 @@ static inline void set_page_links(struct
 
 static __always_inline void *lowmem_page_address(const struct page *page)
 {
-	return __va(PFN_PHYS(page_to_pfn(page)));
+	return __va(PFN_PHYS(page_to_pfn((struct page *)page)));
 }
 
 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch
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

