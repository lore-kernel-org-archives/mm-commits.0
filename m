From: akpm@linux-foundation.org
Subject: [merged] jbdh-bitfields-should-be-unsigned.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:36 -0700
Message-ID: <200909232003.n8NK3ace019574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbZIWUKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, jack@ucw.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     jbd.h: bitfields should be unsigned
has been removed from the -mm tree.  Its filename was
     jbdh-bitfields-should-be-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch

