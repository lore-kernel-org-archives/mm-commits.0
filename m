From: akpm@linux-foundation.org
Subject: + sgiseeq-fix-return-type-of-sgiseeq_remove.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:54:46 -0700
Message-ID: <200708222254.l7MMskmI009067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758659AbXHVWzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     sgiseeq: fix return type of sgiseeq_remove
has been added to the -mm tree.  Its filename is
     sgiseeq-fix-return-type-of-sgiseeq_remove.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sgiseeq: fix return type of sgiseeq_remove
From: Ralf Baechle <ralf@linux-mips.org>

The driver remove method needs to return an int not void.  This was just
never noticed because usually this driver is not being built as a module.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sgiseeq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/sgiseeq.c~sgiseeq-fix-return-type-of-sgiseeq_remove drivers/net/sgiseeq.c
--- a/drivers/net/sgiseeq.c~sgiseeq-fix-return-type-of-sgiseeq_remove
+++ a/drivers/net/sgiseeq.c
@@ -726,7 +726,7 @@ err_out:
 	return err;
 }
 
-static void __exit sgiseeq_remove(struct platform_device *pdev)
+static int __exit sgiseeq_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct sgiseeq_private *sp = netdev_priv(dev);
@@ -735,6 +735,8 @@ static void __exit sgiseeq_remove(struct
 	free_page((unsigned long) sp->srings);
 	free_netdev(dev);
 	platform_set_drvdata(pdev, NULL);
+
+	return 0;
 }
 
 static struct platform_driver sgiseeq_driver = {
_

Patches currently in -mm which might be from ralf@linux-mips.org are

serial_txx9-fix-modem-control-line-handling.patch
newport_con-warning-fix.patch
au1100fb-move-au1100fb_fb_blank-beforce.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch
