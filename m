From: akpm@linux-foundation.org
Subject: [merged] libfc-uses-select-crc32.patch removed from -mm tree
Date: Wed, 14 Jan 2009 12:42:02 -0800
Message-ID: <200901142042.n0EKg2WD008751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbZANUmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, robert.w.love@intel.com, mm-commits@vger.kernel.org


The patch titled
     libfc: uses/select CRC32
has been removed from the -mm tree.  Its filename was
     libfc-uses-select-crc32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfc: uses/select CRC32
From: Randy Dunlap <randy.dunlap@oracle.com>

libfc uses crc32 functions, so cause it to be built via select:

drivers/built-in.o: In function `fc_frame_crc_check':
(.text+0x75dae): undefined reference to `crc32_le'
drivers/built-in.o: In function `fc_fcp_recv':
fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/Kconfig~libfc-uses-select-crc32 drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~libfc-uses-select-crc32
+++ a/drivers/scsi/Kconfig
@@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select CRC32
 	---help---
 	  Fibre Channel library module
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-of-documentation-vmtxt-and-proctxt.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
jbd-fix-missing-kernel-doc.patch
resources-fix-parameter-name-and-kernel-doc.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-fix-kbuildtxt-typos.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

