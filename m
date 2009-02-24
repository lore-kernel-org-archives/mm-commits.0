From: akpm@linux-foundation.org
Subject: [merged] atm-add-missing-parentheses.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:46 -0800
Message-ID: <200902241932.n1OJWkTq004449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbZBXTd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     atm: bitwise OR has higher precedence than ?:
has been removed from the -mm tree.  Its filename was
     atm-add-missing-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: bitwise OR has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/firestream.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/atm/firestream.c~atm-add-missing-parentheses drivers/atm/firestream.c
--- a/drivers/atm/firestream.c~atm-add-missing-parentheses
+++ a/drivers/atm/firestream.c
@@ -1690,17 +1690,17 @@ static int __devinit fs_init (struct fs_
 		  | (0 * SARMODE0_SHADEN) /* We don't use shadow registers. */
 		  | (1 * SARMODE0_INTMODE_READCLEAR)
 		  | (1 * SARMODE0_CWRE)
-		  | IS_FS50(dev)?SARMODE0_PRPWT_FS50_5: 
-		                 SARMODE0_PRPWT_FS155_3
+		  | (IS_FS50(dev) ? SARMODE0_PRPWT_FS50_5:
+			  SARMODE0_PRPWT_FS155_3)
 		  | (1 * SARMODE0_CALSUP_1)
-		  | IS_FS50 (dev)?(0
+		  | (IS_FS50(dev) ? (0
 				   | SARMODE0_RXVCS_32
 				   | SARMODE0_ABRVCS_32 
 				   | SARMODE0_TXVCS_32):
 		                  (0
 				   | SARMODE0_RXVCS_1k
 				   | SARMODE0_ABRVCS_1k 
-				   | SARMODE0_TXVCS_1k));
+				   | SARMODE0_TXVCS_1k)));
 
 	/* 10ms * 100 is 1 second. That should be enough, as AN3:9 says it takes
 	   1ms. */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

