From: akpm@linux-foundation.org
Subject: [patch 5/8] lib/cmdline.c: fix get_options() overflow while
 parsing ranges
Date: Fri, 23 Jun 2017 15:08:49 -0700
Message-ID: <594d9171.mnN2nlGQeWBgynFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754466AbdFWWIu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, matvejchikov@gmail.com, corbet@lwn.net, stable@vger.kernel.org

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
