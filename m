From: akpm@linux-foundation.org
Subject: - dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:00 -0700
Message-ID: <200804282150.m3SLo0Sl017432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934526AbYD1Vue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, hannes@saeurebad.de, macro@linux-mips.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dz: test after postfix decrement fails in dz_console_putchar()
has been removed from the -mm tree.  Its filename was
     dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: test after postfix decrement fails in dz_console_putchar()
From: Roel Kluin <12o3l@tiscali.nl>

When loops reaches 0 the postfix decrement still subtracts, so the subsequent
test fails.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: <stable@kernel.org>
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

origin.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-kbuild.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

