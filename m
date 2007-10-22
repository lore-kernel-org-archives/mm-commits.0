From: akpm@linux-foundation.org
Subject: + char-cyclades-fix-potential-null-dereference.patch added to -mm tree
Date: Mon, 22 Oct 2007 12:12:17 -0700
Message-ID: <200710221912.l9MJCHJ8009041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915AbXJVTMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 15:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bunk@kernel.org


The patch titled
     Char: cyclades, fix potential NULL dereference
has been added to the -mm tree.  Its filename is
     char-cyclades-fix-potential-null-dereference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, fix potential NULL dereference
From: Jiri Slaby <jirislaby@gmail.com>

t=To ztxdone is jumped even if tty is NULL and tty_wakeup placed after this
label doesn't expect NULLed parameter, so this will cause an oops in some
situations (why they scheduled a wakeup there before remove bottom half
processing patch?).  wakeup only in the case when we have non-null tty
struct.

Spotted by Adrian Bunk.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-potential-null-dereference drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-potential-null-dereference
+++ a/drivers/char/cyclades.c
@@ -1602,8 +1602,8 @@ static void cyz_handle_tx(struct cyclade
 			info->icount.tx++;
 		}
 #endif
-ztxdone:
 		tty_wakeup(tty);
+ztxdone:
 		/* Update tx_put */
 		cy_writel(&buf_ctrl->tx_put, tx_put);
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-fix-potential-null-dereference.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
