From: akpm@linux-foundation.org
Subject: - scsi-fix-ncr5380-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:19 -0800
Message-ID: <200801290149.m0T1nJqP027479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYA2B4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:56:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix NCR5380 section mismatch
has been removed from the -mm tree.  Its filename was
     scsi-fix-ncr5380-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix NCR5380 section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Many release() methods that are not __exit or __devexit call this
__devexit function, so remove its "__devexit" attribute.

scsi/g_NCR5380.c:
WARNING: vmlinux.o(.text+0xadaf8c): Section mismatch: reference to .exit.text:NCR5380_exit (between 'generic_NCR5380_release_resources' and 'generic_NCR5380_biosparam')
WARNING: vmlinux.o(.text+0xadd18c): Section mismatch: reference to .exit.text:NCR5380_exit (between 'generic_NCR5380_release_resources' and 'generic_NCR5380_biosparam')
scsi/pas16.c, seagate.c:
WARNING: vmlinux.o(.text+0xb29e91): Section mismatch: reference to .exit.text:NCR5380_exit (between 'pas16_release' and 'seagate_st0x_info')
t128.c:
WARNING: vmlinux.o(.text+0xb2a774): Section mismatch: reference to .exit.text:NCR5380_exit (between 't128_release' and 't128_biosparam')
dtc.c, sym2/sym_fw.c:
WARNING: vmlinux.o(.text+0xb2f215): Section mismatch: reference to .exit.text:NCR5380_exit (between 'dtc_release' and 'sym_fw1_patch')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR5380.c~scsi-fix-ncr5380-section-mismatch drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~scsi-fix-ncr5380-section-mismatch
+++ a/drivers/scsi/NCR5380.c
@@ -932,7 +932,7 @@ static int __devinit NCR5380_init(struct
  *	@instance: adapter to remove
  */
 
-static void __devexit NCR5380_exit(struct Scsi_Host *instance)
+static void NCR5380_exit(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
