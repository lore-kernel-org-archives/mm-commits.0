From: akpm@linux-foundation.org
Subject: + gpiolib-extend-gpio-label-column-width-in-debugfs-file.patch added to -mm tree
Date: Thu, 13 Nov 2008 17:02:50 -0800
Message-ID: <200811140102.mAE12ora005916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbYKNBD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 20:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.nikula@nokia.com, david-b@pacbell.net, stable@kernel.org


The patch titled
     gpiolib: extend gpio label column width in debugfs file
has been added to the -mm tree.  Its filename is
     gpiolib-extend-gpio-label-column-width-in-debugfs-file.patch

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
Subject: gpiolib: extend gpio label column width in debugfs file
From: Jarkko Nikula <jarkko.nikula@nokia.com>

There are already various drivers having bigger label than 12 bytes.  Most
of them fit well under 20 bytes but make column width exact so that
oversized labels don't mess up output alignment.

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: <stable@kernel.org>		[2.6.26.x, 2.6.26.x, 2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-extend-gpio-label-column-width-in-debugfs-file drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-extend-gpio-label-column-width-in-debugfs-file
+++ a/drivers/gpio/gpiolib.c
@@ -1134,7 +1134,7 @@ static void gpiolib_dbg_show(struct seq_
 			continue;
 
 		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
-		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
+		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
 			is_out ? "out" : "in ",
 			chip->get
_

Patches currently in -mm which might be from jarkko.nikula@nokia.com are

gpiolib-extend-gpio-label-column-width-in-debugfs-file.patch

