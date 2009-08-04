From: akpm@linux-foundation.org
Subject: + kgdb-remove-redundant-test.patch added to -mm tree
Date: Tue, 04 Aug 2009 02:07:54 -0700
Message-ID: <200908040907.n7497saC017696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932480AbZHDJH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 05:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jason.wessel@windriver.com


The patch titled
     kgdb: remove redundant test
has been added to the -mm tree.  Its filename is
     kgdb-remove-redundant-test.patch

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
Subject: kgdb: remove redundant test
From: Roel Kluin <roel.kluin@gmail.com>

The for loop starts with a breakno of 0, and ends when it's 4. so
this test is always true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kgdb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/kgdb.c~kgdb-remove-redundant-test arch/x86/kernel/kgdb.c
--- a/arch/x86/kernel/kgdb.c~kgdb-remove-redundant-test
+++ a/arch/x86/kernel/kgdb.c
@@ -225,8 +225,7 @@ static void kgdb_correct_hw_break(void)
 			dr7 |= ((breakinfo[breakno].len << 2) |
 				 breakinfo[breakno].type) <<
 			       ((breakno << 2) + 16);
-			if (breakno >= 0 && breakno <= 3)
-				set_debugreg(breakinfo[breakno].addr, breakno);
+			set_debugreg(breakinfo[breakno].addr, breakno);
 
 		} else {
 			if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
kgdb-remove-redundant-test.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
arch-s390-kvm-sigpc-fix-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
mips-read-buffer-overflow.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
drivers-parisc-pdc_stablec-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
perf-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
usb-gadget-read-buffer-overflow.patch
libertas-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
adfs-remove-redundant-test-on-unsigned.patch

