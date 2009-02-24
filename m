From: akpm@linux-foundation.org
Subject: [merged] atm-bitwise-or-has-higher-precedence-than.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:43 -0800
Message-ID: <200902241932.n1OJWhhw004443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbZBXTdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, chas3@users.sourceforge.net, chas@cmf.nrl.navy.mil, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     atm: bitwise or has higher precedence than ?:
has been removed from the -mm tree.  Its filename was
     atm-bitwise-or-has-higher-precedence-than.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: bitwise or has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: chas williams <chas3@users.sourceforge.net>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/lanai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/atm/lanai.c~atm-bitwise-or-has-higher-precedence-than drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~atm-bitwise-or-has-higher-precedence-than
+++ a/drivers/atm/lanai.c
@@ -901,7 +901,7 @@ static int __devinit eeprom_read(struct 
 		clock_l(); udelay(5);
 		for (i = 128; i != 0; i >>= 1) {   /* write command out */
 			tmp = (lanai->conf1 & ~CONFIG1_PROMDATA) |
-			    (data & i) ? CONFIG1_PROMDATA : 0;
+			    ((data & i) ? CONFIG1_PROMDATA : 0);
 			if (lanai->conf1 != tmp) {
 				set_config1(tmp);
 				udelay(5);	/* Let new data settle */
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

