From: akpm@linux-foundation.org
Subject: + lguest-cleanup-for-map_switcher.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:51:31 -0700
Message-ID: <200908060051.n760pV9x029842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbZHFAvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@cn.fujitsu.com, rusty@rustcorp.com.au


The patch titled
     lguest: cleanup for map_switcher()
has been added to the -mm tree.  Its filename is
     lguest-cleanup-for-map_switcher.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lguest: cleanup for map_switcher()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

We can use alloc_page() instead of get_zeroed_page() and virt_to_page()

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
+		if (!switcher_page[i])
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
lguest-cleanup-for-map_switcher.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch

