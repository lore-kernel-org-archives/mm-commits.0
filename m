From: akpm@linux-foundation.org
Subject: + mm-page_allocc-remove-hand-coded-get_order.patch added to -mm tree
Date: Tue, 15 Apr 2008 02:35:22 -0700
Message-ID: <200804150935.m3F9ZMap021548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763567AbYDOJf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, pavel@suse.cz


The patch titled
     mm/page_alloc.c: remove hand-coded get_order()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-remove-hand-coded-get_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: remove hand-coded get_order()
From: Pavel Machek <pavel@ucw.cz>

Remove hand-coded get_order() from page_alloc.c.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-remove-hand-coded-get_order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-remove-hand-coded-get_order
+++ a/mm/page_alloc.c
@@ -4345,9 +4345,7 @@ void *__init alloc_large_system_hash(con
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
-			unsigned long order;
-			for (order = 0; ((1UL << order) << PAGE_SHIFT) < size; order++)
-				;
+			unsigned long order = get_order(size);
 			table = (void*) __get_free_pages(GFP_ATOMIC, order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
git-x86.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
git-hrt.patch
git-net.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
mm-page_allocc-remove-hand-coded-get_order.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

