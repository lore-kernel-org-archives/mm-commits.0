From: akpm@linux-foundation.org
Subject: + lib-strscpy-remove-word-at-a-time-optimization.patch added to
 -mm tree
Date: Tue, 09 Jan 2018 15:28:55 -0800
Message-ID: <5a555037.VXGDzwA8fmq1xwXQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757586AbeAIX3B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, dvyukov@google.com, eguan@redhat.com, glider@google.com, keescook@chromium.org, metcalf@alum.mit.edu, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/strscpy: remove word-at-a-time optimization.
has been added to the -mm tree.  Its filename is
     lib-strscpy-remove-word-at-a-time-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-strscpy-remove-word-at-a-time-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-strscpy-remove-word-at-a-time-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: lib/strscpy: remove word-at-a-time optimization.

strscpy() performs the word-at-a-time optimistic reads.  So it may may
access the memory past the end of the object, which is perfectly fine
since strscpy() doesn't use that (past-the-end) data and makes sure the
optimistic read won't cross a page boundary.

But KASAN doesn't know anything about that so it will complain.  There are
several possible ways to address this issue, but none are perfect.  See
https://lkml.kernel.org/r/9f0a9cf6-51f7-cd1f-5dc6-6d510a7b8ec4@virtuozzo.com

It seems the best solution is to simply disable word-at-a-time
optimization.  My trivial testing shows that byte-at-a-time could be up to
x4.3 times slower than word-at-a-time.  It may seems like a lot, but it's
actually ~1.2e-10 sec per symbol vs ~4.8e-10 sec per symbol on modern
hardware.  And we don't use strscpy() in a performance critical paths to
copy large amounts of data, so it shouldn't matter anyway.

Link: http://lkml.kernel.org/r/20180109163745.3692-1-aryabinin@virtuozzo.com
Fixes: 30035e45753b7 ("string: provide strscpy()")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eryu Guan <eguan@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Chris Metcalf <metcalf@alum.mit.edu>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

diff -puN lib/string.c~lib-strscpy-remove-word-at-a-time-optimization lib/string.c
--- a/lib/string.c~lib-strscpy-remove-word-at-a-time-optimization
+++ a/lib/string.c
@@ -29,7 +29,6 @@
 #include <linux/errno.h>
 
 #include <asm/byteorder.h>
-#include <asm/word-at-a-time.h>
 #include <asm/page.h>
 
 #ifndef __HAVE_ARCH_STRNCASECMP
@@ -177,45 +176,8 @@ EXPORT_SYMBOL(strlcpy);
  */
 ssize_t strscpy(char *dest, const char *src, size_t count)
 {
-	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
-	size_t max = count;
 	long res = 0;
 
-	if (count == 0)
-		return -E2BIG;
-
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	/*
-	 * If src is unaligned, don't cross a page boundary,
-	 * since we don't know if the next page is mapped.
-	 */
-	if ((long)src & (sizeof(long) - 1)) {
-		size_t limit = PAGE_SIZE - ((long)src & (PAGE_SIZE - 1));
-		if (limit < max)
-			max = limit;
-	}
-#else
-	/* If src or dest is unaligned, don't do word-at-a-time. */
-	if (((long) dest | (long) src) & (sizeof(long) - 1))
-		max = 0;
-#endif
-
-	while (max >= sizeof(unsigned long)) {
-		unsigned long c, data;
-
-		c = *(unsigned long *)(src+res);
-		if (has_zero(c, &data, &constants)) {
-			data = prep_zero_mask(c, data, &constants);
-			data = create_zero_mask(data);
-			*(unsigned long *)(dest+res) = c & zero_bytemask(data);
-			return res + find_zero(data);
-		}
-		*(unsigned long *)(dest+res) = c;
-		res += sizeof(unsigned long);
-		count -= sizeof(unsigned long);
-		max -= sizeof(unsigned long);
-	}
