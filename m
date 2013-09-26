From: akpm@linux-foundation.org
Subject: + kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch added to -mm tree
Date: Thu, 26 Sep 2013 14:41:21 -0700
Message-ID: <5244aa01.lMpHZlCkyMGbAHuW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3IZVlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stefani@seibold.net, lars@metafoo.de

Subject: + kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch added to -mm tree
To: lars@metafoo.de,stefani@seibold.net
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:41:21 -0700


The patch titled
     Subject: kfifo: kfifo_copy_{to,from}_user: fix copied bytes calculation
has been added to the -mm tree.  Its filename is
     kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kfifo-kfifo_copy_tofrom_user-fix-copied-bytes-calculation.patch
linux-next.patch

