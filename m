From: akpm@linux-foundation.org
Subject: + drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch added to -mm tree
Date: Fri, 27 Aug 2010 14:16:42 -0700
Message-ID: <201008272116.o7RLGgtt016617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab0H0VRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 17:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, cjb@laptop.org, linux-mmc@vger.kernel.org, ppisa@pikron.com


The patch titled
     drivers/mmc/host/imxmmc.c: adjust confusing if indentation
has been added to the -mm tree.  Its filename is
     drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch

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
Subject: drivers/mmc/host/imxmmc.c: adjust confusing if indentation
From: Julia Lawall <julia@diku.dk>

Move the second if (reg & ...) test into the branch indicated by its
indentation.  The test was previously always executed after the if
containing that branch, but it was always false unless the if branch was
taken.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Pavel Pisa <ppisa@pikron.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/imxmmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/imxmmc.c~drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation drivers/mmc/host/imxmmc.c
--- a/drivers/mmc/host/imxmmc.c~drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation
+++ a/drivers/mmc/host/imxmmc.c
@@ -148,11 +148,12 @@ static int imxmci_start_clock(struct imx
 
 		while (delay--) {
 			reg = readw(host->base + MMC_REG_STATUS);
-			if (reg & STATUS_CARD_BUS_CLK_RUN)
+			if (reg & STATUS_CARD_BUS_CLK_RUN) {
 				/* Check twice before cut */
 				reg = readw(host->base + MMC_REG_STATUS);
 				if (reg & STATUS_CARD_BUS_CLK_RUN)
 					return 0;
+			}
 
 			if (test_bit(IMXMCI_PEND_STARTED_b, &host->pending_events))
 				return 0;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch

