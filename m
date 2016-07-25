From: akpm@linux-foundation.org
Subject: + randomize_range-use-random-long-instead-of-int.patch added to
 -mm tree
Date: Mon, 25 Jul 2016 13:42:32 -0700
Message-ID: <579679b8.loX2vjWjMxJIxhqb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbcGYUmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 16:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.c.roberts@intel.com, keescook@chromium.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/car/random.c: randomize_range(): use random long instead of int
has been added to the -mm tree.  Its filename is
     randomize_range-use-random-long-instead-of-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/randomize_range-use-random-long-instead-of-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/randomize_range-use-random-long-instead-of-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

randomize_range-use-random-long-instead-of-int.patch

