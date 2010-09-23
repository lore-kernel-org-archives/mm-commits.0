From: akpm@linux-foundation.org
Subject: + gpio-sx150x-fix-error-code-value.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:21:17 -0700
Message-ID: <201009232321.o8NNLHFN025348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab0IWXWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, david-b@pacbell.net, gbean@codeaurora.org, khali@linux-fr.org


The patch titled
     gpio: sx150x: fix error code value
has been added to the -mm tree.  Its filename is
     gpio-sx150x-fix-error-code-value.patch

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
Subject: gpio: sx150x: fix error code value
From: Vasiliy Kulikov <segooon@gmail.com>

The return code of sx150x_get_io() is propagated as error code, so it
should look like standard code.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Gregory Bean <gbean@codeaurora.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/sx150x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/sx150x.c~gpio-sx150x-fix-error-code-value drivers/gpio/sx150x.c
--- a/drivers/gpio/sx150x.c~gpio-sx150x-fix-error-code-value
+++ a/drivers/gpio/sx150x.c
@@ -179,7 +179,7 @@ static int sx150x_get_io(struct sx150x_c
 	sx150x_find_cfg(offset, 1, &reg, &mask, &shift);
 	err = sx150x_i2c_read(chip->client, reg, &data);
 	if (err >= 0)
-		err = (data & mask) != 0 ? 1 : 0;
+		err = (data & mask) != 0 ? -EIO : 0;
 
 	return err;
 }
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
md-check-return-code-of-read_sb_page.patch
mm-mempolicy-check-return-code-of-check_range.patch
drivers-rtc-classc-fix-device_register-error-handling.patch
gpio-sx150x-fix-error-code-value.patch
memstick-core-fix-device_register-error-handling.patch

