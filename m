From: akpm@linux-foundation.org
Subject: + misdn-dsp_cmxc-fix-size-checks.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:56:13 -0700
Message-ID: <200808282356.m7SNuDSb021017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbYH1X40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, kkeil@suse.de


The patch titled
     mISDN/dsp_cmx.c: fix size checks
has been added to the -mm tree.  Its filename is
     misdn-dsp_cmxc-fix-size-checks.patch

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
Subject: mISDN/dsp_cmx.c: fix size checks
From: Adrian Bunk <bunk@kernel.org>

The checks for ensuring that the array indices are inside the range
were flipped.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_cmx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/mISDN/dsp_cmx.c~misdn-dsp_cmxc-fix-size-checks drivers/isdn/mISDN/dsp_cmx.c
--- a/drivers/isdn/mISDN/dsp_cmx.c~misdn-dsp_cmxc-fix-size-checks
+++ a/drivers/isdn/mISDN/dsp_cmx.c
@@ -452,10 +452,10 @@ one_member:
 			if (finddsp->features.pcm_id == dsp->features.pcm_id) {
 				if (finddsp->pcm_slot_rx >= 0 &&
 				    finddsp->pcm_slot_rx < sizeof(freeslots))
-					freeslots[finddsp->pcm_slot_tx] = 0;
+					freeslots[finddsp->pcm_slot_rx] = 0;
 				if (finddsp->pcm_slot_tx >= 0 &&
 				    finddsp->pcm_slot_tx < sizeof(freeslots))
-					freeslots[finddsp->pcm_slot_rx] = 0;
+					freeslots[finddsp->pcm_slot_tx] = 0;
 			}
 		}
 		i = 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ntfs-update-homepage.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
misdn-dsp_cmxc-fix-size-checks.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

