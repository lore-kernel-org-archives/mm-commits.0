From: akpm@linux-foundation.org
Subject: + pnp-increase-number-of-devices-supported-per-protocol.patch added to -mm tree
Date: Thu, 10 Apr 2008 11:44:56 -0700
Message-ID: <200804101844.m3AIiumh011994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYDJSpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 14:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     pnp: increase number of devices supported per protocol
has been added to the -mm tree.  Its filename is
     pnp-increase-number-of-devices-supported-per-protocol.patch

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
Subject: pnp: increase number of devices supported per protocol
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Increase the PNP "number of devices" limit.  We currently use an unsigned
char, which limits us to 256 devices per protocol.  This patch changes that to
an unsigned int.

Not all backends can take advantage of this: we limit ISAPNP to 10 devices in
isapnp_cfg_begin(), and PNPBIOS is limited to 256 devices because the BIOS
interfaces use a one-byte device node number.

But there is no limit on the number of PNPACPI devices we may have.  Large HP
Integrity machines have more than 256, which causes the current "unsigned char
number" to wrap around.  This causes errors like this:

    pnp: PnP ACPI init
    kobject_add failed for 00:00 with -EEXIST, don't try to register things with the same name in the same directory.

    Call Trace:
     [<a000000100010720>] show_stack+0x40/0xa0
     [<a0000001000107b0>] dump_stack+0x30/0x60
     [<a0000001001dbdf0>] kobject_add+0x290/0x2c0
     [<a0000001002bfd40>] device_add+0x160/0x860
     [<a0000001002c0470>] device_register+0x30/0x60
     [<a00000010026ba70>] __pnp_add_device+0x130/0x180
     [<a00000010026bb70>] pnp_add_device+0xb0/0xe0
     [<a0000001007f2730>] pnpacpi_add_device+0x510/0x5a0
     [<a0000001007f2810>] pnpacpi_add_device_handler+0x50/0x80

This patch increases the limit to fix this PNPACPI problem.  It should not
have any adverse effect on ISAPNP or PNPBIOS because their limits are still
enforced in the backends.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pnp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pnp.h~pnp-increase-number-of-devices-supported-per-protocol include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-increase-number-of-devices-supported-per-protocol
+++ a/include/linux/pnp.h
@@ -175,7 +175,7 @@ static inline void pnp_set_card_drvdata(
 struct pnp_dev {
 	struct device dev;		/* Driver Model device interface */
 	u64 dma_mask;
-	unsigned char number;		/* used as an index, must be unique */
+	unsigned int number;		/* used as an index, must be unique */
 	int status;
 
 	struct list_head global_list;	/* node in global list of devices */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
pnp-increase-number-of-devices-supported-per-protocol.patch
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
simplify-initcall_debug-output.patch
hisax-depend-on-config_pnp-not-__isapnp__.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

