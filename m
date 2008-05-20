From: akpm@linux-foundation.org
Subject: + gpio-mcp23s08-debug-fix.patch added to -mm tree
Date: Tue, 20 May 2008 00:18:40 -0700
Message-ID: <200805200718.m4K7Iexg010605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYETHTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, dbrownell@users.sourceforge.net


The patch titled
     gpio: mcp23s08 debug fix
has been added to the -mm tree.  Its filename is
     gpio-mcp23s08-debug-fix.patch

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
Subject: gpio: mcp23s08 debug fix
From: Roel Kluin <12o3l@tiscali.nl>

The return value of mcp23s08_read_regs() can only be evaluated when signed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/mcp23s08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/mcp23s08.c~gpio-mcp23s08-debug-fix drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpio-mcp23s08-debug-fix
+++ a/drivers/gpio/mcp23s08.c
@@ -168,7 +168,7 @@ static void mcp23s08_dbg_show(struct seq
 {
 	struct mcp23s08	*mcp;
 	char		bank;
-	unsigned	t;
+	int		t;
 	unsigned	mask;
 
 	mcp = container_of(chip, struct mcp23s08, chip);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

linux-next.patch
gpio-mcp23s08-debug-fix.patch
gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

