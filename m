From: akpm@linux-foundation.org
Subject: + intel-rng-undo-mess-made-by-an-80-column-extremist.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:38:24 -0700
Message-ID: <200706080538.l585cOkI020180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936322AbXFHFjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mb@bu3sch.de


The patch titled
     intel-rng: undo mess made by an 80 column extremist
has been added to the -mm tree.  Its filename is
     intel-rng-undo-mess-made-by-an-80-column-extremist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-rng: undo mess made by an 80 column extremist
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The intel-rng printed a nice well formatted message when the port was
disabled.  Someone then came along and blindly trashed it by screwing up a
trim down to 80 columns.

Put it back into the right format and keep the overlong lines as the result
is also MUCH easier to read in this specific case.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/char/hw_random/intel-rng.c~intel-rng-undo-mess-made-by-an-80-column-extremist drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~intel-rng-undo-mess-made-by-an-80-column-extremist
+++ a/drivers/char/hw_random/intel-rng.c
@@ -296,12 +296,10 @@ static int __init intel_init_hw_struct(s
 	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
 		static __initdata /*const*/ char warning[] =
-			KERN_WARNING PFX "Firmware space is locked read-only. "
-			KERN_WARNING PFX "If you can't or\n don't want to "
-			KERN_WARNING PFX "disable this in firmware setup, and "
-			KERN_WARNING PFX "if\n you are certain that your "
-			KERN_WARNING PFX "system has a functional\n RNG, try"
-			KERN_WARNING PFX "using the 'no_fwh_detect' option.\n";
+			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
+			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
+			KERN_WARNING PFX "you are certain that your system has a functional\n"
+			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
libata-correct-abuse-of-language.patch
libata-core-sff-fix-multiple-assumptions-about-dma.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
