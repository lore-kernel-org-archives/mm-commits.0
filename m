From: akpm@linux-foundation.org
Subject: + ip2-fix-crashes-on-load-unload.patch added to -mm tree
Date: Tue, 20 May 2008 01:46:38 -0700
Message-ID: <200805200846.m4K8kc0b013917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760697AbYETIrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com, jirislaby@gmail.com


The patch titled
     ip2: fix crashes on load/unload
has been added to the -mm tree.  Its filename is
     ip2-fix-crashes-on-load-unload.patch

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
Subject: ip2: fix crashes on load/unload
From: Alan Cox <alan@redhat.com>

This doesn't need to be two modules, and making it one cleans up the
problem

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/Makefile  |    4 ++--
 drivers/char/ip2/ip2main.c |   23 -----------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff -puN drivers/char/ip2/Makefile~ip2-fix-crashes-on-load-unload drivers/char/ip2/Makefile
--- a/drivers/char/ip2/Makefile~ip2-fix-crashes-on-load-unload
+++ a/drivers/char/ip2/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Computone IntelliPort Plus Driver
 #
 
-obj-$(CONFIG_COMPUTONE)         += ip2.o ip2main.o
+obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2base.o
+ip2-objs			:= ip2base.o ip2main.o
 
diff -puN drivers/char/ip2/ip2main.c~ip2-fix-crashes-on-load-unload drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-fix-crashes-on-load-unload
+++ a/drivers/char/ip2/ip2main.c
@@ -346,27 +346,6 @@ have_requested_irq( char irq )
 }
 
 /******************************************************************************/
-/* Function:   init_module()                                                  */
-/* Parameters: None                                                           */
-/* Returns:    Success (0)                                                    */
-/*                                                                            */
-/* Description:                                                               */
-/* This is a required entry point for an installable module. It simply calls  */
-/* the driver initialisation function and returns what it returns.            */
-/******************************************************************************/
-#ifdef MODULE
-static int __init
-ip2_init_module(void)
-{
-#ifdef IP2DEBUG_INIT
-	printk (KERN_DEBUG "Loading module ...\n" );
-#endif
-    return 0;
-}
-module_init(ip2_init_module);
-#endif /* MODULE */
-
-/******************************************************************************/
 /* Function:   cleanup_module()                                               */
 /* Parameters: None                                                           */
 /* Returns:    Nothing                                                        */
@@ -779,8 +758,6 @@ out:
 	return err;
 }
 
-EXPORT_SYMBOL(ip2_loadmain);
-
 /******************************************************************************/
 /* Function:   ip2_init_board()                                               */
 /* Parameters: Index of board in configuration structure                      */
_

Patches currently in -mm which might be from alan@redhat.com are

linux-next.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch
watchdog-clean-up-and-check-advantech-watchdog.patch
watchdog-ali-watchdog-locking-and-style.patch
watchdog-ar7-watchdog.patch
watchdog-atp-watchdog.patch
watchdog-at91-watchdog-to-unlocked_ioctl.patch
watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch
watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch
watchdog-ep93xx_wdt-unlocked_ioctl.patch
watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch
watchdog-hpwdt-couple-of-include-cleanups.patch
watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch
watchdog-ibmasr-coding-style-locking-verify.patch
watchdog-indydog-clean-up-and-tidy.patch
watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch
watchdog-it8712f-unlocked_ioctl.patch
watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch
watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch
watchdog-ixp4xx_wdt-unlocked_ioctl.patch
watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch
watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch
watchdog-mpc-watchdog-clean-up-and-locking.patch
watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch
watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch
watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch
watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch
watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage.patch
watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch
watchdog-rm9k_wdt-clean-up.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch
watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch
watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-stg7240_wdt-unlocked_ioctl.patch
watchdog-sbc8360-clean-up.patch
watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch
watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-sc1200_wdt-clean-up-fix-locking-and-use-unlocked_ioctl.patch
watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch
watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch
watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch
watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch
watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdrtas-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch
watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
mm-fix-atomic_t-overflow-in-vm.patch
ip2-fix-crashes-on-load-unload.patch
serial-8250_gscc-add-module_license.patch
remove-is_tty.patch
riscom8-remove-redundant-null-pointer-test.patch
unexport-proc_clear_tty.patch

