From: akpm@linux-foundation.org
Subject: [merged] spi_bitbang-add-more-lowlevel-function-documentation.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:50 -0800
Message-ID: <200902232006.n1NK6opp013433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbZBWURa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bitbang: add more lowlevel function documentation
has been removed from the -mm tree.  Its filename was
     spi_bitbang-add-more-lowlevel-function-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch

