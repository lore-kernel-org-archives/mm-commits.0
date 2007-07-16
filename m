From: akpm@linux-foundation.org
Subject: - cris-replace-old-style-member-inits-with-designated-inits.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:58 -0700
Message-ID: <200707162050.l6GKownT001352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759398AbXGPV0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: replace old-style member inits with designated inits
has been removed from the -mm tree.  Its filename was
     cris-replace-old-style-member-inits-with-designated-inits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
