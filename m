From: akpm@linux-foundation.org
Subject: - auxdisplay-small-cleanups.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:28 -0700
Message-ID: <200807242333.m6ONXSat011930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756839AbYGXXda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     auxdisplay: small cleanups
has been removed from the -mm tree.  Its filename was
     auxdisplay-small-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: auxdisplay: small cleanups
From: Akinobu Mita <akinobu.mita@gmail.com>

- Use BUILD_BUG_ON for CFAG12864B_SIZE instead of runtime-check

- Use get_zeroed_page()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/cfag12864b.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/auxdisplay/cfag12864b.c~auxdisplay-small-cleanups drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~auxdisplay-small-cleanups
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -336,16 +336,9 @@ static int __init cfag12864b_init(void)
 			"ks0108 is not initialized\n");
 		goto none;
 	}
+	BUILD_BUG_ON(PAGE_SIZE < CFAG12864B_SIZE);
 
-	if (PAGE_SIZE < CFAG12864B_SIZE) {
-		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
-			"page size (%i) < cfag12864b size (%i)\n",
-			(unsigned int)PAGE_SIZE, CFAG12864B_SIZE);
-		ret = -ENOMEM;
-		goto none;
-	}
-
-	cfag12864b_buffer = (unsigned char *) __get_free_page(GFP_KERNEL);
+	cfag12864b_buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
 	if (cfag12864b_buffer == NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"can't get a free page\n");
@@ -367,8 +360,6 @@ static int __init cfag12864b_init(void)
 	if (cfag12864b_workqueue == NULL)
 		goto cachealloced;
 
-	memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
-
 	cfag12864b_clear();
 	cfag12864b_on();
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

