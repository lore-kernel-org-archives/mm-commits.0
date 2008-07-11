From: akpm@linux-foundation.org
Subject: + calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:37:13 -0700
Message-ID: <200807111842.m6BIgs3r030687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbYGKSo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     calgary: fix a comparison warning the PCI Calgary 64 driver
has been added to the -mm tree.  Its filename is
     calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch

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
Subject: calgary: fix a comparison warning the PCI Calgary 64 driver
From: David Howells <dhowells@redhat.com>

Fix an integer comparison always false warning in the PCI Calgary 64 driver.

A u8 is being compared to something that's 512 by default, resulting in the
following warning:

arch/x86/kernel/pci-calgary_64.c:1285: warning: comparison is always false due to limited range of data type

This was introduced by patch b34e90b8f0f30151349134f87b5dc6ef75a5218c.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~calgary-fix-a-comparison-warning-the-pci-calgary-64-driver arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~calgary-fix-a-comparison-warning-the-pci-calgary-64-driver
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -1280,13 +1280,15 @@ static inline int __init determine_tce_t
 static int __init build_detail_arrays(void)
 {
 	unsigned long ptr;
-	int i, scal_detail_size, rio_detail_size;
+	unsigned numnodes, i;
+	int scal_detail_size, rio_detail_size;
 
-	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES){
+	numnodes = rio_table_hdr->num_scal_dev;
+	if (numnodes > MAX_NUMNODES){
 		printk(KERN_WARNING
 			"Calgary: MAX_NUMNODES too low! Defined as %d, "
 			"but system has %d nodes.\n",
-			MAX_NUMNODES, rio_table_hdr->num_scal_dev);
+			MAX_NUMNODES, numnodes);
 		return -ENODEV;
 	}
 
@@ -1307,8 +1309,7 @@ static int __init build_detail_arrays(vo
 	}
 
 	ptr = ((unsigned long)rio_table_hdr) + 3;
-	for (i = 0; i < rio_table_hdr->num_scal_dev;
-		    i++, ptr += scal_detail_size)
+	for (i = 0; i < numnodes; i++, ptr += scal_detail_size)
 		scal_devs[i] = (struct scal_detail *)ptr;
 
 	for (i = 0; i < rio_table_hdr->num_rio_dev;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
acpi-fix-build-with-config_pm_sleep=n.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
fix-a-const-assignment-in-moxa_load_fw.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

