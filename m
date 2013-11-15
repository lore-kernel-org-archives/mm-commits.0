From: akpm@linux-foundation.org
Subject: [merged]
 kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 12:09:29 -0800
Message-ID: <52867f79.dr3lM+mYwxkP9Yvh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KOUJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stefani@seibold.net, lars@metafoo.de

Subject: [merged] kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch removed from -mm tree
To: lars@metafoo.de,stefani@seibold.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:29 -0800


The patch titled
     Subject: kfifo: kfifo_copy_{to,from}_user: fix copied bytes calculation
has been removed from the -mm tree.  Its filename was
     kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: kfifo: kfifo_copy_{to,from}_user: fix copied bytes calculation

'copied' and 'len' are in bytes, while 'ret' is in elements, so we need to
multiply 'ret' with the size of one element to get the correct result.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/kfifo.c~kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation lib/kfifo.c
--- a/lib/kfifo.c~kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation
+++ a/lib/kfifo.c
@@ -215,7 +215,7 @@ static unsigned long kfifo_copy_from_use
 	 * incrementing the fifo->in index counter
 	 */
 	smp_wmb();
-	*copied = len - ret;
+	*copied = len - ret * esize;
 	/* return the number of elements which are not copied */
 	return ret;
 }
@@ -275,7 +275,7 @@ static unsigned long kfifo_copy_to_user(
 	 * incrementing the fifo->out index counter
 	 */
 	smp_wmb();
-	*copied = len - ret;
+	*copied = len - ret * esize;
 	/* return the number of elements which are not copied */
 	return ret;
 }
_

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch
linux-next.patch

