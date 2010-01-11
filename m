From: akpm@linux-foundation.org
Subject: + arm-add-missing-parentheses.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:50:56 -0800
Message-ID: <201001112250.o0BMoulD000751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab0AKW4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:56:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ben-linux@fluff.org, linux@arm.linux.org.uk, linux@simtec.co.uk


The patch titled
     arm: add missing parentheses
has been added to the -mm tree.  Its filename is
     arm-add-missing-parentheses.patch

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
Subject: arm: add missing parentheses
From: Roel Kluin <roel.kluin@gmail.com>

`!' has a higher precedence than `&' so parentheses are required.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2440/mach-osiris-dvs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-s3c2440/mach-osiris-dvs.c~arm-add-missing-parentheses arch/arm/mach-s3c2440/mach-osiris-dvs.c
--- a/arch/arm/mach-s3c2440/mach-osiris-dvs.c~arm-add-missing-parentheses
+++ a/arch/arm/mach-s3c2440/mach-osiris-dvs.c
@@ -77,8 +77,8 @@ static int osiris_dvs_notify(struct noti
 		}
 		break;
 	case CPUFREQ_POSTCHANGE:
-		if (!old_dvs & new_dvs ||
-		    !cur_dvs & new_dvs) {
+		if (!(old_dvs & new_dvs) ||
+		    !(cur_dvs & new_dvs)) {
 			pr_debug("entering dvs\n");
 			cur_dvs = true;
 			gpio_set_value(OSIRIS_GPIO_DVS, 0);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
arm-add-missing-parentheses.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
v4l-dvb-wrong-variable-tested.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

