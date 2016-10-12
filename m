From: akpm@linux-foundation.org
Subject: [merged] random-remove-unused-randomize_range.patch removed from
 -mm tree
Date: Wed, 12 Oct 2016 12:25:05 -0700
Message-ID: <57fe8e11.H4fj1eawLvmJzCQd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33357 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754850AbcJLTZG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, keescook@chromium.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random: remove unused randomize_range()
has been removed from the -mm tree.  Its filename was
     random-remove-unused-randomize_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: random: remove unused randomize_range()

All call sites for randomize_range have been updated to use the much
simpler and more robust randomize_addr().  Remove the now unnecessary
code.

Link: http://lkml.kernel.org/r/20160803233913.32511-8-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Kees Cook <keescook@chromium.org>
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
