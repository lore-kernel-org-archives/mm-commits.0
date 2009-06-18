From: akpm@linux-foundation.org
Subject: [merged] ppdev-reduce-kernel-log-spam.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:21 -0700
Message-ID: <200906182247.n5IMlLUQ006492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759008AbZFRWr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     ppdev: reduce kernel log spam
has been removed from the -mm tree.  Its filename was
     ppdev-reduce-kernel-log-spam.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppdev: reduce kernel log spam
From: Michael Buesch <mb@bu3sch.de>

One of my programs frequently grabs the parport, does something with it
and then drops it again. This results in spamming of the kernel log with

"... registered pardevice"
"... unregistered pardevice"

These messages are completely useless, except for debugging ppdev,
probably.  So put them under DEBUG (or dynamic debug).

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/char/ppdev.c~ppdev-reduce-kernel-log-spam drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~ppdev-reduce-kernel-log-spam
+++ a/drivers/char/ppdev.c
@@ -114,8 +114,7 @@ static ssize_t pp_read (struct file * fi
 
 	if (!(pp->flags & PP_CLAIMED)) {
 		/* Don't have the port claimed */
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
@@ -198,8 +197,7 @@ static ssize_t pp_write (struct file * f
 
 	if (!(pp->flags & PP_CLAIMED)) {
 		/* Don't have the port claimed */
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
@@ -313,7 +311,7 @@ static int register_device (int minor, s
 	}
 
 	pp->pdev = pdev;
-	printk (KERN_DEBUG "%s: registered pardevice\n", name);
+	pr_debug("%s: registered pardevice\n", name);
 	return 0;
 }
 
@@ -343,8 +341,7 @@ static int pp_do_ioctl(struct file *file
 		int ret;
 
 		if (pp->flags & PP_CLAIMED) {
-			printk (KERN_DEBUG CHRDEV
-				"%x: you've already got it!\n", minor);
+			pr_debug(CHRDEV "%x: you've already got it!\n", minor);
 			return -EINVAL;
 		}
 
@@ -379,7 +376,7 @@ static int pp_do_ioctl(struct file *file
 	    }
 	case PPEXCL:
 		if (pp->pdev) {
-			printk (KERN_DEBUG CHRDEV "%x: too late for PPEXCL; "
+			pr_debug(CHRDEV "%x: too late for PPEXCL; "
 				"already registered\n", minor);
 			if (pp->flags & PP_EXCL)
 				/* But it's not really an error. */
@@ -491,8 +488,7 @@ static int pp_do_ioctl(struct file *file
 	/* Everything else requires the port to be claimed, so check
 	 * that now. */
 	if ((pp->flags & PP_CLAIMED) == 0) {
-		printk (KERN_DEBUG CHRDEV "%x: claim the port first\n",
-			minor);
+		pr_debug(CHRDEV "%x: claim the port first\n", minor);
 		return -EINVAL;
 	}
 
@@ -624,8 +620,7 @@ static int pp_do_ioctl(struct file *file
 		return 0;
 
 	default:
-		printk (KERN_DEBUG CHRDEV "%x: What? (cmd=0x%x)\n", minor,
-			cmd);
+		pr_debug(CHRDEV "%x: What? (cmd=0x%x)\n", minor, cmd);
 		return -EINVAL;
 	}
 
@@ -698,9 +693,8 @@ static int pp_release (struct inode * in
 	}
 	if (compat_negot) {
 		parport_negotiate (pp->pdev->port, IEEE1284_MODE_COMPAT);
-		printk (KERN_DEBUG CHRDEV
-			"%x: negotiated back to compatibility mode because "
-			"user-space forgot\n", minor);
+		pr_debug(CHRDEV "%x: negotiated back to compatibility "
+			"mode because user-space forgot\n", minor);
 	}
 
 	if (pp->flags & PP_CLAIMED) {
@@ -713,7 +707,7 @@ static int pp_release (struct inode * in
 		info->phase = pp->saved_state.phase;
 		parport_release (pp->pdev);
 		if (compat_negot != 1) {
-			printk (KERN_DEBUG CHRDEV "%x: released pardevice "
+			pr_debug(CHRDEV "%x: released pardevice "
 				"because user-space forgot\n", minor);
 		}
 	}
@@ -723,8 +717,7 @@ static int pp_release (struct inode * in
 		parport_unregister_device (pp->pdev);
 		kfree (name);
 		pp->pdev = NULL;
-		printk (KERN_DEBUG CHRDEV "%x: unregistered pardevice\n",
-			minor);
+		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
 	}
 
 	kfree (pp);
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch

