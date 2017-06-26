From: akpm@linux-foundation.org
Subject: [merged]
 cmdline-fix-get_options-overflow-while-parsing-ranges.patch removed from
 -mm tree
Date: Mon, 26 Jun 2017 13:22:46 -0700
Message-ID: <20170626202246.uAlE71KvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdFZUWs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 16:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, matvejchikov@gmail.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: lib/cmdline.c: fix get_options() overflow while parsing ranges
has been removed from the -mm tree.  Its filename was
     cmdline-fix-get_options-overflow-while-parsing-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


