From: akpm@linux-foundation.org
Subject: + auxdisplay-small-cleanups.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:57:50 -0700
Message-ID: <200807220957.m6M9voH6022043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYGVJ5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, maxextreme@gmail.com


The patch titled
     auxdisplay: small cleanups
has been added to the -mm tree.  Its filename is
     auxdisplay-small-cleanups.patch

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
move-memory_read_from_buffer-from-fsh-to-stringh.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer-fix.patch
auxdisplay-small-cleanups.patch
workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

