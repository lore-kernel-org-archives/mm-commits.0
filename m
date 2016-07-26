From: akpm@linux-foundation.org
Subject: [withdrawn] randomize_range-use-random-long-instead-of-int.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 12:23:20 -0700
Message-ID: <5797b8a8.G7AGvry2xqo+sTQJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbcGZTXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 15:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.c.roberts@intel.com, keescook@chromium.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/car/random.c: randomize_range(): use random long instead of int
has been removed from the -mm tree.  Its filename was
     randomize_range-use-random-long-instead-of-int.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: William Roberts <william.c.roberts@intel.com>
Subject: drivers/car/random.c: randomize_range(): use random long instead of int

Use a long when generating the random range rather than an int.  This will
produce better random distributions as well as matching all the types at
hand.

Link: http://lkml.kernel.org/r/1469471141-25669-1-git-send-email-william.c.roberts@intel.com
Signed-off-by: William Roberts <william.c.roberts@intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/random.c~randomize_range-use-random-long-instead-of-int drivers/char/random.c
--- a/drivers/char/random.c~randomize_range-use-random-long-instead-of-int
+++ a/drivers/char/random.c
@@ -1837,7 +1837,8 @@ randomize_range(unsigned long start, uns
 
 	if (end <= start + len)
 		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
+
+	return PAGE_ALIGN(get_random_long() % range + start);
 }
 
 /* Interface for in-kernel drivers of true hardware RNGs.
_

Patches currently in -mm which might be from william.c.roberts@intel.com are


