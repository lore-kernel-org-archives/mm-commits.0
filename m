From: akpm@linux-foundation.org
Subject: + scsi_debug-needs-crc_t10dif.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:49:07 -0800
Message-ID: <200901132249.n0DMn7FJ016821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbZAMWtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com


The patch titled
     scsi_debug: needs CRC_T10DIF
has been added to the -mm tree.  Its filename is
     scsi_debug-needs-crc_t10dif.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi_debug: needs CRC_T10DIF
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi_debug build error:

drivers/built-in.o: In function `resp_read':
scsi_debug.c:(.text+0x21379a): undefined reference to `crc_t10dif'
drivers/built-in.o: In function `resp_write':
scsi_debug.c:(.text+0x213fca): undefined reference to `crc_t10dif'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/Kconfig~scsi_debug-needs-crc_t10dif drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi_debug-needs-crc_t10dif
+++ a/drivers/scsi/Kconfig
@@ -1536,6 +1536,7 @@ config SCSI_NSP32
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
+	select CRC_T10DIF
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
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
proc-move-inode-comment-text-file-to-source-file.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
libfc-uses-select-crc32.patch
scsi_debug-needs-crc_t10dif.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

