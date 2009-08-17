From: akpm@linux-foundation.org
Subject: + jbdh-bitfields-should-be-unsigned.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:09:31 -0700
Message-ID: <200908172109.n7HL9VxZ000445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756875AbZHQVKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, jack@ucw.cz, tytso@mit.edu


The patch titled
     jbd.h: bitfields should be unsigned
has been added to the -mm tree.  Its filename is
     jbdh-bitfields-should-be-unsigned.patch

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
Subject: jbd.h: bitfields should be unsigned
From: H Hartley Sweeten <hartleys@visionengravers.com>

bitfields should be unsigned.

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h |    2 +-
 linux/jbd2.h        |    0 
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/jbd.h~jbdh-bitfields-should-be-unsigned include/linux/jbd.h
--- a/include/linux/jbd.h~jbdh-bitfields-should-be-unsigned
+++ a/include/linux/jbd.h
@@ -556,7 +556,7 @@ struct transaction_s
 	 * This transaction is being forced and some process is
 	 * waiting for it to finish.
 	 */
-	int t_synchronous_commit:1;
+	unsigned int t_synchronous_commit:1;
 };
 
 /**
diff -puN include/linux/jbd2.h~jbdh-bitfields-should-be-unsigned include/linux/jbd2.h
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
drivers-mtd-mtdcorec-make-symbols-static.patch
jbd2h-bitfields-should-be-unsigned.patch
gpio-include-linux-gpioh-not-asm-gpioh.patch
atyfb-coding-style-cleanup.patch
jbdh-bitfields-should-be-unsigned.patch

