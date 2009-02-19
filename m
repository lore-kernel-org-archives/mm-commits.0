From: akpm@linux-foundation.org
Subject: + sundance-bitwise-or-has-higher-precedence-than.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:45:44 -0800
Message-ID: <200902192045.n1JKjik3021860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbZBSUpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:45:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     sundance: bitwise OR has higher precedence than ?:
has been added to the -mm tree.  Its filename is
     sundance-bitwise-or-has-higher-precedence-than.patch

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
atm-bitwise-or-has-higher-precedence-than.patch
atm-add-missing-parentheses.patch
drivers-net-tg3c-fix-confusion.patch
smsc-timeout-reaches-1.patch
sundance-bitwise-or-has-higher-precedence-than.patch
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

