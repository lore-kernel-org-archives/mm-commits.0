From: akpm@linux-foundation.org
Subject: + spi-fix-compile-error.patch added to -mm tree
Date: Wed, 29 Oct 2008 00:54:51 -0700
Message-ID: <200810290754.m9T7spCe009333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbYJ2Hy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 03:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, david-b@pacbell.net


The patch titled
     spi: fix compile error
has been added to the -mm tree.  Its filename is
     spi-fix-compile-error.patch

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
Subject: spi: fix compile error
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Fix compile error below:

     LD      drivers/spi/built-in.o
     CC [M]  drivers/spi/spi_gpio.o
   In file included from drivers/spi/spi_gpio.c:26:
   include/linux/spi/spi_bitbang.h:23: error: field `work' has incomplete type
   make[2]: *** [drivers/spi/spi_gpio.o] Error 1
   make[1]: *** [drivers/spi] Error 2
   make: *** [drivers] Error 2

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi_bitbang.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/spi/spi_bitbang.h~spi-fix-compile-error include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi-fix-compile-error
+++ a/include/linux/spi/spi_bitbang.h
@@ -18,6 +18,9 @@
  *	duplex (MicroWire) controllers.  Provide chipslect() and txrx_bufs(),
  *	and custom setup()/cleanup() methods.
  */
+
+#include <linux/workqueue.h>
+
 struct spi_bitbang {
 	struct workqueue_struct	*workqueue;
 	struct work_struct	work;
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

spi-fix-compile-error.patch

