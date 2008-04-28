From: akpm@linux-foundation.org
Subject: - mm-page_allocc-remove-hand-coded-get_order.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:04 -0700
Message-ID: <200804282154.m3SLs4Hg017965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936825AbYD1VyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: remove hand-coded get_order()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-hand-coded-get_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
hci_usbh-fix-hard-to-trigger-race.patch

