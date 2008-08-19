From: akpm@linux-foundation.org
Subject: + make-gpiochip-label-const.patch added to -mm tree
Date: Tue, 19 Aug 2008 01:42:20 -0700
Message-ID: <200808190842.m7J8gKb4007643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYHSIm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 04:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     gpio: make gpiochip label const
has been added to the -mm tree.  Its filename is
     make-gpiochip-label-const.patch

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
Subject: gpio: make gpiochip label const
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Mark gpiochip label as a const char pointer.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/gpio.h~make-gpiochip-label-const include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~make-gpiochip-label-const
+++ a/include/asm-generic/gpio.h
@@ -61,7 +61,7 @@ struct module;
  * is calculated by subtracting @base from the gpio number.
  */
 struct gpio_chip {
-	char			*label;
+	const char		*label;
 	struct device		*dev;
 	struct module		*owner;
 
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
linux-next.patch
make-gpiochip-label-const.patch

