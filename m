From: akpm@linux-foundation.org
Subject: + cris-replace-old-style-member-inits-with-designated-inits.patch added to -mm tree
Date: Tue, 29 May 2007 17:48:54 -0700
Message-ID: <200705300048.l4U0mskQ015719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbXE3AtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, starvik@axis.com


The patch titled
     CRIS: replace old-style member inits with designated inits
has been added to the -mm tree.  Its filename is
     cris-replace-old-style-member-inits-with-designated-inits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS: replace old-style member inits with designated inits
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the old-style structure member initializers with designated
initializers.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/cryptocop.c |    8 ++++----
 arch/cris/arch-v32/drivers/i2c.c       |    8 ++++----
 arch/cris/arch-v32/drivers/pcf8563.c   |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/cris/arch-v32/drivers/cryptocop.c~cris-replace-old-style-member-inits-with-designated-inits arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~cris-replace-old-style-member-inits-with-designated-inits
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -267,10 +267,10 @@ static void print_user_dma_lists(struct 
 
 
 const struct file_operations cryptocop_fops = {
-	owner: THIS_MODULE,
-	open: cryptocop_open,
-	release: cryptocop_release,
-	ioctl: cryptocop_ioctl
+	.owner =	THIS_MODULE,
+	.open =		cryptocop_open,
+	.release =	cryptocop_release,
+	.ioctl =	cryptocop_ioctl
 };
 
 
diff -puN arch/cris/arch-v32/drivers/i2c.c~cris-replace-old-style-member-inits-with-designated-inits arch/cris/arch-v32/drivers/i2c.c
--- a/arch/cris/arch-v32/drivers/i2c.c~cris-replace-old-style-member-inits-with-designated-inits
+++ a/arch/cris/arch-v32/drivers/i2c.c
@@ -574,10 +574,10 @@ i2c_ioctl(struct inode *inode, struct fi
 }
 
 static const struct file_operations i2c_fops = {
-	owner:    THIS_MODULE,
-	ioctl:    i2c_ioctl,
-	open:     i2c_open,
-	release:  i2c_release,
+	.owner =    THIS_MODULE,
+	.ioctl =    i2c_ioctl,
+	.open =     i2c_open,
+	.release =  i2c_release,
 };
 
 int __init
diff -puN arch/cris/arch-v32/drivers/pcf8563.c~cris-replace-old-style-member-inits-with-designated-inits arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c~cris-replace-old-style-member-inits-with-designated-inits
+++ a/arch/cris/arch-v32/drivers/pcf8563.c
@@ -51,10 +51,10 @@ int pcf8563_open(struct inode *, struct 
 int pcf8563_release(struct inode *, struct file *);
 
 static const struct file_operations pcf8563_fops = {
-	owner: THIS_MODULE,
-	ioctl: pcf8563_ioctl,
-	open: pcf8563_open,
-	release: pcf8563_release,
+	.owner =	THIS_MODULE,
+	.ioctl =	pcf8563_ioctl,
+	.open =		pcf8563_open,
+	.release =	pcf8563_release,
 };
 
 unsigned char
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
