From: akpm@linux-foundation.org
Subject: - mm-debug-dump-pageframes-on-bad_page.patch removed from -mm tree
Date: Tue, 02 Dec 2008 17:08:23 -0800
Message-ID: <200812030108.mB318Nbn030740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYLCBIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 20:08:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     mm debug: dump pageframes on bad_page()
has been removed from the -mm tree.  Its filename was
     mm-debug-dump-pageframes-on-bad_page.patch

This patch was dropped because it gets rejects and I don't recall ever learning anything from it...

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm debug: dump pageframes on bad_page()
From: Manfred Spraul <manfred@colorfullife.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/page_alloc.c~mm-debug-dump-pageframes-on-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-dump-pageframes-on-bad_page
+++ a/mm/page_alloc.c
@@ -231,6 +231,21 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
+	{
+		int i;
+		unsigned char *ptr = (unsigned char *)page;
+		ptr -= 64;
+
+		printk(KERN_EMERG "Hexdump:");
+		for (i=0;i<192;i++) {
+			if ((i%16) == 0) {
+				printk("\n");
+				printk(KERN_EMERG "%03x:", i);
+			}
+			printk(" %02x", ptr[i]);
+		}
+		printk("\n");
+	}
 	page->flags &= ~PAGE_FLAGS_CLEAR_WHEN_BAD;
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

repeatable-slab-corruption-with-ltp-msgctl08.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

