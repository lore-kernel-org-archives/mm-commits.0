From: akpm@linux-foundation.org
Subject: + spi_bitbang-add-more-lowlevel-function-documentation.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:05:13 -0800
Message-ID: <200902192305.n1JN5DZ8029303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbZBSXFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, dbrownell@users.sourceforge.net


The patch titled
     spi_bitbang: add more lowlevel function documentation
has been added to the -mm tree.  Its filename is
     spi_bitbang-add-more-lowlevel-function-documentation.patch

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
Subject: spi_bitbang: add more lowlevel function documentation
From: Michael Buesch <mb@bu3sch.de>

This adds more documentation of the lowlevel API to avoid future bugs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi_bitbang.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/spi/spi_bitbang.h~spi_bitbang-add-more-lowlevel-function-documentation include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi_bitbang-add-more-lowlevel-function-documentation
+++ a/include/linux/spi/spi_bitbang.h
@@ -83,6 +83,13 @@ extern int spi_bitbang_stop(struct spi_b
  *  int getmiso(struct spi_device *);
  *  void spidelay(unsigned);
  *
+ * setsck()'s is_on parameter is a zero/nonzero boolean.
+ *
+ * setmosi()'s is_on parameter is a zero/nonzero boolean.
+ *
+ * getmiso() is required to return 0 or 1 only. Any other value is invalid
+ * and will result in improper operation.
+ *
  * A non-inlined routine would call bitbang_txrx_*() routines.  The
  * main loop could easily compile down to a handful of instructions,
  * especially if the delay is a NOP (to run at peak speed).
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
spi_bitbang-add-more-lowlevel-function-documentation.patch
linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch

