From: akpm@linux-foundation.org
Subject: + libfc-uses-select-crc32.patch added to -mm tree
Date: Mon, 12 Jan 2009 15:00:35 -0800
Message-ID: <200901122300.n0CN0Zd0023031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758723AbZALXAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:00:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com


The patch titled
     libfc: uses/select CRC32
has been added to the -mm tree.  Its filename is
     libfc-uses-select-crc32.patch

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

linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
libfc-uses-select-crc32.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

