From: akpm@linux-foundation.org
Subject: + x86-microcode-patch-loader-style-corrections.patch added to -mm tree
Date: Wed, 13 Aug 2008 19:04:02 -0700
Message-ID: <200808140204.m7E2429x017878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbYHNCRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 22:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oruba@amd.com, mingo@elte.hu, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk


The patch titled
     x86: microcode patch loader style corrections
has been added to the -mm tree.  Its filename is
     x86-microcode-patch-loader-style-corrections.patch

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
Subject: x86: microcode patch loader style corrections
From: Peter Oruba <peter.oruba@amd.com>

Style corrections to main microcode module.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/microcode.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/microcode.c~x86-microcode-patch-loader-style-corrections arch/x86/kernel/microcode.c
--- a/arch/x86/kernel/microcode.c~x86-microcode-patch-loader-style-corrections
+++ a/arch/x86/kernel/microcode.c
@@ -55,8 +55,8 @@
  *		in a single CPU package.
  *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
  *		Tigran Aivazian <tigran@veritas.com>,
- *		Serialize updates as required on HT processors due to speculative
- *		nature of implementation.
+ *		Serialize updates as required on HT processors due to
+ *		speculative nature of implementation.
  *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
  *		Fix the panic when writing zero-length microcode chunk.
  *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
@@ -71,7 +71,7 @@
  *		Thanks to Stuart Swales for pointing out this bug.
  */
 
-//#define DEBUG /* pr_debug */
+/*#define DEBUG pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -381,7 +381,7 @@ static long get_next_ucode(void **mc, lo
 	return offset + total_size;
 }
 
-static int do_microcode_update (void)
+static int do_microcode_update(void)
 {
 	long cursor = 0;
 	int error = 0;
@@ -422,18 +422,20 @@ out:
 	return error;
 }
 
-static int microcode_open (struct inode *unused1, struct file *unused2)
+static int microcode_open(struct inode *unused1, struct file *unused2)
 {
 	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
-static ssize_t microcode_write (struct file *file, const char __user *buf, size_t len, loff_t *ppos)
+static ssize_t microcode_write(struct file *file, const char __user *buf,
+			       size_t len, loff_t *ppos)
 {
 	ssize_t ret;
 
 	if ((len >> PAGE_SHIFT) > num_physpages) {
-		printk(KERN_ERR "microcode: too much data (max %ld pages)\n", num_physpages);
+		printk(KERN_ERR "microcode: too much data (max %ld pages)\n",
+		       num_physpages);
 		return -EINVAL;
 	}
 
@@ -465,7 +467,7 @@ static struct miscdevice microcode_dev =
 	.fops		= &microcode_fops,
 };
 
-static int __init microcode_dev_init (void)
+static int __init microcode_dev_init(void)
 {
 	int error;
 
@@ -480,7 +482,7 @@ static int __init microcode_dev_init (vo
 	return 0;
 }
 
-static void microcode_dev_exit (void)
+static void microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
@@ -488,7 +490,7 @@ static void microcode_dev_exit (void)
 MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #else
 #define microcode_dev_init() 0
-#define microcode_dev_exit() do { } while(0)
+#define microcode_dev_exit() do { } while (0)
 #endif
 
 static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
@@ -836,7 +838,7 @@ static int __init microcode_init (void)
 	return 0;
 }
 
-static void __exit microcode_exit (void)
+static void __exit microcode_exit(void)
 {
 	microcode_dev_exit();
 
_

Patches currently in -mm which might be from peter.oruba@amd.com are

x86-microcode-patch-loader-style-corrections.patch
x86-microcode-patch-loader-style-corrections-fix.patch

