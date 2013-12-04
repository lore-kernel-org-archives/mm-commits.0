From: akpm@linux-foundation.org
Subject: [merged] scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
 removed from -mm tree
Date: Wed, 04 Dec 2013 12:52:41 -0800
Message-ID: <529f9619.bJAExUT4McaySI7m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3LDUwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 15:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] scsi-do-not-call-do_div-with-a-64-bit-divisor.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 12:52:41 -0800


The patch titled
     Subject: scsi: do not call do_div() with a 64-bit divisor
has been removed from the -mm tree.  Its filename was
     scsi-do-not-call-do_div-with-a-64-bit-divisor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: scsi: do not call do_div() with a 64-bit divisor

do_div() is meant for divisions of 64-bit number by 32-bit numbers. 
Passing 64-bit divisor types caused issues in the past on 32-bit
platforms, cfr.  commit ea077b1b96e073eac5c ("m68k: Truncate base in
do_div()").

As scsi_device.sector_size is unsigned (int), factor should be unsigned
int, too.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-do-not-call-do_div-with-a-64-bit-divisor drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-do-not-call-do_div-with-a-64-bit-divisor
+++ a/drivers/scsi/sd.c
@@ -1628,7 +1628,7 @@ static unsigned int sd_completed_bytes(s
 		end_lba <<= 1;
 	} else {
 		/* be careful ... don't want any overflows */
-		u64 factor = scmd->device->sector_size / 512;
+		unsigned int factor = scmd->device->sector_size / 512;
 		do_div(start_lba, factor);
 		do_div(end_lba, factor);
 	}
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
inith-add-missing-initcall-variants.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

