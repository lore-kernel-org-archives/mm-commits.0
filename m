From: akpm@linux-foundation.org
Subject: + cmdline-fix-get_options-overflow-while-parsing-ranges.patch
 added to -mm tree
Date: Tue, 20 Jun 2017 13:47:46 -0700
Message-ID: <594989f2.8gYx0Isbl1/ABT4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752428AbdFTUrw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 16:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matvejchikov@gmail.com, corbet@lwn.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline.c: fix get_options() overflow while parsing ranges
has been added to the -mm tree.  Its filename is
     cmdline-fix-get_options-overflow-while-parsing-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cmdline-fix-get_options-overflow-while-parsing-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cmdline-fix-get_options-overflow-while-parsing-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ilya Matveychikov <matvejchikov@gmail.com>
Subject: lib/cmdline.c: fix get_options() overflow while parsing ranges

When using get_options() it's possible to specify a range of numbers, like
1-100500.  The problem is that it doesn't track array size while calling
internally to get_range() which iterates over the range and fills the
memory with numbers.

Link: http://lkml.kernel.org/r/2613C75C-B04D-4BFF-82A6-12F97BA0F620@gmail.com
Signed-off-by: Ilya V. Matveychikov <matvejchikov@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/cmdline.c~cmdline-fix-get_options-overflow-while-parsing-ranges lib/cmdline.c
--- a/lib/cmdline.c~cmdline-fix-get_options-overflow-while-parsing-ranges
+++ a/lib/cmdline.c
@@ -23,14 +23,14 @@
  *	the values[M, M+1, ..., N] into the ints array in get_options.
  */
 
-static int get_range(char **str, int *pint)
+static int get_range(char **str, int *pint, int n)
 {
 	int x, inc_counter, upper_range;
 
 	(*str)++;
 	upper_range = simple_strtol((*str), NULL, 0);
 	inc_counter = upper_range - *pint;
-	for (x = *pint; x < upper_range; x++)
+	for (x = *pint; n && x < upper_range; x++, n--)
 		*pint++ = x;
 	return inc_counter;
 }
@@ -97,7 +97,7 @@ char *get_options(const char *str, int n
 			break;
 		if (res == 3) {
 			int range_nums;
-			range_nums = get_range((char **)&str, ints + i);
+			range_nums = get_range((char **)&str, ints + i, nints - i);
 			if (range_nums < 0)
 				break;
 			/*
_

Patches currently in -mm which might be from matvejchikov@gmail.com are

cmdline-fix-get_options-overflow-while-parsing-ranges.patch

