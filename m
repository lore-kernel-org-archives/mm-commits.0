From: akpm@linux-foundation.org
Subject: + scsi-only-print-data-direction-warning-once-for-a-command.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:57:40 -0800
Message-ID: <200801110057.m0B0vewX018582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbYAKA6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, James.Bottomley@steeleye.com


The patch titled
     scsi: only print data direction warning once for a command
has been added to the -mm tree.  Its filename is
     scsi-only-print-data-direction-warning-once-for-a-command.patch

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
Subject: scsi: only print data direction warning once for a command
From: Andi Kleen <ak@suse.de>

When I use cdparanoia my logs get spammed a lot by

printk: 464 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
   program cdparanoia not setting count and/or reply_len properly
printk: 1078 messages suppressed.

and many more of those. With this patch the message is only printed once
for a command in a row.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sg.c~scsi-only-print-data-direction-warning-once-for-a-command drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~scsi-only-print-data-direction-warning-once-for-a-command
+++ a/drivers/scsi/sg.c
@@ -602,8 +602,9 @@ sg_write(struct file *filp, const char _
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		if (printk_ratelimit())
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+		static char cmd[TASK_COMM_LEN];
+		if (printk_ratelimit() && strcmp(current->comm, cmd)) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
 			       "guessing data in;\n" KERN_WARNING "   "
@@ -611,6 +612,9 @@ sg_write(struct file *filp, const char _
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
+			strcpy(cmd, current->comm);
+		}
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
_

Patches currently in -mm which might be from ak@suse.de are

kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
pci-disable-decoding-during-sizing-of-bars.patch
scsi-only-print-data-direction-warning-once-for-a-command.patch
git-x86.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
fix-x86-32-bit-frame_pointer-chasing-code.patch
i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
allow-executables-larger-than-2gb.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
