From: akpm@linux-foundation.org
Subject: [merged] sundance-bitwise-or-has-higher-precedence-than.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:52 -0800
Message-ID: <200902241932.n1OJWqxX004463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbZBXTd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sundance: bitwise OR has higher precedence than ?:
has been removed from the -mm tree.  Its filename was
     sundance-bitwise-or-has-higher-precedence-than.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sundance: bitwise OR has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sundance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sundance.c~sundance-bitwise-or-has-higher-precedence-than drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-bitwise-or-has-higher-precedence-than
+++ a/drivers/net/sundance.c
@@ -909,7 +909,7 @@ static void check_duplex(struct net_devi
 			printk(KERN_INFO "%s: Setting %s-duplex based on MII #%d "
 				   "negotiated capability %4.4x.\n", dev->name,
 				   duplex ? "full" : "half", np->phys[0], negotiated);
-		iowrite16(ioread16(ioaddr + MACCtrl0) | duplex ? 0x20 : 0, ioaddr + MACCtrl0);
+		iowrite16(ioread16(ioaddr + MACCtrl0) | (duplex ? 0x20 : 0), ioaddr + MACCtrl0);
 	}
 }
 
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

