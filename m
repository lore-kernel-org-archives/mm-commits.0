From: akpm@osdl.org
Subject: - swsusp-use-__gfp_wait.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:20 -0800
Message-ID: <200612072259.kB7MxKeL029498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163675AbWLGW7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: use __GFP_WAIT
has been removed from the -mm tree.  Its filename was
     swsusp-use-__gfp_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: use __GFP_WAIT
From: "Rafael J. Wysocki" <rjw@sisk.pl>

swsusp uses GFP_ATOMIC, but it can afford to use __GFP_WAIT, which will
permit it to reclaim clean pagecache instead of emitting scary
page-allocation-failure messages.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/swap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/power/swap.c~swsusp-use-__gfp_wait kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-use-__gfp_wait
+++ a/kernel/power/swap.c
@@ -63,7 +63,7 @@ static int submit(int rw, pgoff_t page_o
 {
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_ATOMIC, 1);
+	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
 	if (!bio)
 		return -ENOMEM;
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
@@ -216,7 +216,7 @@ static int write_page(void *buf, sector_
 		return -ENOSPC;
 
 	if (bio_chain) {
-		src = (void *)__get_free_page(GFP_ATOMIC);
+		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 		if (src) {
 			memcpy(src, buf, PAGE_SIZE);
 		} else {
@@ -473,7 +473,7 @@ static int get_swap_reader(struct swap_m
 	if (!start)
 		return -EINVAL;
 
-	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_ATOMIC);
+	handle->cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
 	if (!handle->cur)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

