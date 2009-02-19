From: akpm@linux-foundation.org
Subject: + atm-add-missing-parentheses.patch added to -mm tree
Date: Wed, 18 Feb 2009 16:04:30 -0800
Message-ID: <200902190004.n1J04U56025312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654AbZBSAEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 19:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, chas@cmf.nrl.navy.mil


The patch titled
     atm: bitwise OR has higher precedence than ?:
has been added to the -mm tree.  Its filename is
     atm-add-missing-parentheses.patch

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
atm-bitwise-or-has-higher-precedence-than.patch
atm-add-missing-parentheses.patch
drivers-net-tg3c-fix-confusion.patch
smsc-timeout-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
paride-pgc-xs-confusion.patch
b43-bitwise-or-has-higher-precedence-than.patch
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

