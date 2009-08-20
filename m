From: akpm@linux-foundation.org
Subject: [merged] jbd2h-bitfields-should-be-unsigned.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:13:07 -0700
Message-ID: <200908202013.n7KKD72i016164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292AbZHTUNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, jack@ucw.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     jbd2.h: bitfields should be unsigned
has been removed from the -mm tree.  Its filename was
     jbd2h-bitfields-should-be-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2.h: bitfields should be unsigned
From: H Hartley Sweeten <hartleys@visionengravers.com>

bitfields should be unsigned.

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/jbd.h~jbd2h-bitfields-should-be-unsigned include/linux/jbd.h
diff -puN include/linux/jbd2.h~jbd2h-bitfields-should-be-unsigned include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd2h-bitfields-should-be-unsigned
+++ a/include/linux/jbd2.h
@@ -652,7 +652,7 @@ struct transaction_s
 	 * This transaction is being forced and some process is
 	 * waiting for it to finish.
 	 */
-	int t_synchronous_commit:1;
+	unsigned int t_synchronous_commit:1;
 
 	/*
 	 * For use by the filesystem to store fs-specific data
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
drivers-mtd-mtdcorec-make-symbols-static.patch
fs-bufferc-clean-up-export-macros.patch
aioc-move-export-macros-to-line-after-function.patch
gpio-include-linux-gpioh-not-asm-gpioh.patch
atyfb-coding-style-cleanup.patch
jbdh-bitfields-should-be-unsigned.patch

