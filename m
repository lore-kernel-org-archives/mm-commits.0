From: akpm@linux-foundation.org
Subject: [merged] lguest-cleanup-for-map_switcher.patch removed from -mm tree
Date: Fri, 07 Aug 2009 12:57:41 -0700
Message-ID: <200908071957.n77JvfQv004026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933422AbZHGT6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 15:58:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@cn.fujitsu.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: cleanup for map_switcher()
has been removed from the -mm tree.  Its filename was
     lguest-cleanup-for-map_switcher.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lguest: cleanup for map_switcher()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

We can use alloc_page() instead of get_zeroed_page() and virt_to_page()

[akpm@linux-foundation.org: build fix]
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/core.c~lguest-cleanup-for-map_switcher drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-cleanup-for-map_switcher
+++ a/drivers/lguest/core.c
@@ -67,12 +67,11 @@ static __init int map_switcher(void)
 	 * so we make sure they're zeroed.
 	 */
 	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
-		unsigned long addr = get_zeroed_page(GFP_KERNEL);
-		if (!addr) {
+		switcher_page[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
+		if (!switcher_page[i]) {
 			err = -ENOMEM;
 			goto free_some_pages;
 		}
-		switcher_page[i] = virt_to_page(addr);
 	}
 
 	/*
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

generic-ipi-fix-hotplug_cfd.patch
linux-next.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch

