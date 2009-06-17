From: akpm@linux-foundation.org
Subject: [merged] kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:10 -0700
Message-ID: <200906171837.n5HIbAoK003206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbZFQSpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     kernel/kfifo.c: replace conditional test with is_power_of_2()
has been removed from the -mm tree.  Its filename was
     kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/kfifo.c: replace conditional test with is_power_of_2()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kfifo.c~kernel-kfifoc-replace-conditional-test-with-is_power_of_2 kernel/kfifo.c
--- a/kernel/kfifo.c~kernel-kfifoc-replace-conditional-test-with-is_power_of_2
+++ a/kernel/kfifo.c
@@ -74,7 +74,7 @@ struct kfifo *kfifo_alloc(unsigned int s
 	 * round up to the next power of 2, since our 'let the indices
 	 * wrap' tachnique works only in this case.
 	 */
-	if (size & (size - 1)) {
+	if (!is_power_of_2(size)) {
 		BUG_ON(size > 0x80000000);
 		size = roundup_pow_of_two(size);
 	}
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch

