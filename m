From: akpm@linux-foundation.org
Subject: [folded] mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:56:58 -0700
Message-ID: <201107252356.p6PNuwA4006208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GYX5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dkiper@net-space.pl, ian.campbell@citrix.com, jeremy@goop.org, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix
has been removed from the -mm tree.  Its filename was
     mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch

This patch was dropped because it was folded into mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix
From: Andrew Morton <akpm@linux-foundation.org>

use explicit indirect-call syntax

Cc: Daniel Kiper <dkiper@net-space.pl>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org> 
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix
+++ a/mm/memory_hotplug.c
@@ -450,7 +450,7 @@ static int online_pages_range(unsigned l
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
-			online_page_callback(page);
+			(*online_page_callback)(page);
 			onlined_pages++;
 		}
 	*(unsigned long *)arg = onlined_pages;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
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

