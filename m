From: akpm@linux-foundation.org
Subject: + scsi-fix-ncr5380-section-mismatch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:10:52 -0800
Message-ID: <200801270510.m0R5Anw0030810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYA0FLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     scsi: fix NCR5380 section mismatch
has been added to the -mm tree.  Its filename is
     scsi-fix-ncr5380-section-mismatch.patch

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
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
rcu-fix-section-mismatch.patch
git-alsa.patch
sound-fix-cs5535-section-mismatch.patch
git-dvb.patch
radio-fix-sf16fmi-section-mismatch.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
scsi-fix-ncr5380-section-mismatch.patch
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
sound-fix-opti9xx-miro-section-mismatch.patch
profile-likely-unlikely-macros.patch
