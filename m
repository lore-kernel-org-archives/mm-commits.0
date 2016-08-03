From: akpm@linux-foundation.org
Subject: + random-remove-unused-randomize_range.patch added to -mm tree
Date: Wed, 03 Aug 2016 16:57:14 -0700
Message-ID: <57a284da.3fo8L9M4mEmyrewd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbcHDAVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 20:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, keescook@chromium.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random: remove unused randomize_range()
has been added to the -mm tree.  Its filename is
     random-remove-unused-randomize_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/random-remove-unused-randomize_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/random-remove-unused-randomize_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: random: remove unused randomize_range()

All call sites for randomize_range have been updated to use the much
simpler and more robust randomize_page().  Remove the now unnecessary
code.

Link: http://lkml.kernel.org/r/20160803233913.32511-8-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c  |   19 -------------------
 include/linux/random.h |    1 -
 2 files changed, 20 deletions(-)

diff -puN drivers/char/random.c~random-remove-unused-randomize_range drivers/char/random.c
--- a/drivers/char/random.c~random-remove-unused-randomize_range
+++ a/drivers/char/random.c
@@ -2100,25 +2100,6 @@ unsigned long get_random_long(void)
 }
 EXPORT_SYMBOL(get_random_long);
 
-/*
- * randomize_range() returns a start address such that
- *
- *    [...... <range> .....]
- *  start                  end
- *
- * a <range> with size "len" starting at the return value is inside in the
- * area defined by [start, end], but is otherwise randomized.
- */
-unsigned long
-randomize_range(unsigned long start, unsigned long end, unsigned long len)
-{
-	unsigned long range = end - len - start;
-
-	if (end <= start + len)
-		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
-}
-
 /**
  * randomize_page - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.
diff -puN include/linux/random.h~random-remove-unused-randomize_range include/linux/random.h
--- a/include/linux/random.h~random-remove-unused-randomize_range
+++ a/include/linux/random.h
@@ -34,7 +34,6 @@ extern const struct file_operations rand
 
 unsigned int get_random_int(void);
 unsigned long get_random_long(void);
-unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests.patch
random-remove-unused-randomize_range.patch

