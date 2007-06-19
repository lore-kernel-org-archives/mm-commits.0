From: akpm@linux-foundation.org
Subject: + blink-only-blink-when-parameter-is-set.patch added to -mm tree
Date: Tue, 19 Jun 2007 13:51:37 -0700
Message-ID: <200706192051.l5JKpbv1020921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXFSUwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 16:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de


The patch titled
     blink: only blink when parameter is set
has been added to the -mm tree.  Its filename is
     blink-only-blink-when-parameter-is-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blink: only blink when parameter is set
From: Bernhard Walle <bwalle@suse.de>

This patch in the blink driver changes the module to only blink when the
parameter 'blink' is set to true.  This is to allow the module to be
compiled in the kernel and not as module.

As the blink module was initially written for kdump, and as the kernel is
relocatable on lots of architectures, there's no need to compile a separate
kdump kernel.  The blinking can now enabled via the boot command line for
the kdump kernel when necessary.

The patch also adds some author/license information and marks the init
function as '__init'.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/blink.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/misc/blink.c~blink-only-blink-when-parameter-is-set drivers/misc/blink.c
--- a/drivers/misc/blink.c~blink-only-blink-when-parameter-is-set
+++ a/drivers/misc/blink.c
@@ -3,6 +3,10 @@
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 
+static int blink;
+module_param(blink, bool, S_IRUGO);
+MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)");
+
 static void do_blink(unsigned long data);
 
 static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
@@ -16,12 +20,19 @@ static void do_blink(unsigned long data)
 	add_timer(&blink_timer);
 }
 
-static int blink_init(void)
+static int __init blink_init(void)
 {
 	printk(KERN_INFO "Enabling keyboard blinking\n");
-	do_blink(0);
+
+	if (blink)
+		do_blink(0);
+
 	return 0;
 }
 
 module_init(blink_init);
 
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andi Kleen <ak@suse.de>");
+MODULE_DESCRIPTION("Blinks the keyboard LEDs");
+
_

Patches currently in -mm which might be from bwalle@suse.de are

git-scsi-misc.patch
blink-only-blink-when-parameter-is-set.patch
