From: akpm@linux-foundation.org
Subject: - advansys-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:14 -0800
Message-ID: <200712172340.lBHNeEBI008274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964818AbXLQXxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:53:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     advansys: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     advansys-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: advansys: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'advansys_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/advansys.c~advansys-fix-section-mismatch-warning drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~advansys-fix-section-mismatch-warning
+++ a/drivers/scsi/advansys.c
@@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_
 
 #define ASC_IOADR_TABLE_MAX_IX  11
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
 };
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
