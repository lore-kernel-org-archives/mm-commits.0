From: akpm@linux-foundation.org
Subject: + dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:05:53 -0700
Message-ID: <200804152305.m3FN5rgl020586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYDOXGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, hannes@saeurebad.de, macro@linux-mips.org


The patch titled
     dz: test after postfix decrement fails in dz_console_putchar()
has been added to the -mm tree.  Its filename is
     dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch

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
Subject: dz: test after postfix decrement fails in dz_console_putchar()
From: Roel Kluin <12o3l@tiscali.nl>

When loops reaches 0 the postfix decrement still subtracts, so the subsequent
test fails.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/dz.c~dz-test-after-postfix-decrement-fails-in-dz_console_putchar drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-test-after-postfix-decrement-fails-in-dz_console_putchar
+++ a/drivers/serial/dz.c
@@ -819,7 +819,7 @@ static void dz_console_putchar(struct ua
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	} while (loops--);
+	} while (--loops);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

mm-fix-possible-off-by-one-in-walk_pte_range.patch
git-powerpc.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-net.patch
git-scsi-misc.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
git-cryptodev.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch
dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch

