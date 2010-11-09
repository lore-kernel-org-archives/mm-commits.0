From: akpm@linux-foundation.org
Subject: + kernel-range-fix-clean_sort_range-for-the-case-of-full-array.patch added to -mm tree
Date: Mon, 08 Nov 2010 16:00:21 -0800
Message-ID: <201011090000.oA900LuK017476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab0KIACV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 19:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khoroshilov@ispras.ru, geert@linux-m68k.org, hpa@zytor.com, yinghai@kernel.org


The patch titled
     kernel/range.c: fix clean_sort_range() for the case of full array
has been added to the -mm tree.  Its filename is
     kernel-range-fix-clean_sort_range-for-the-case-of-full-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/range.c: fix clean_sort_range() for the case of full array
From: Alexey Khoroshilov <khoroshilov@ispras.ru>

clean_sort_range() should return a number of nonempty elements of range
array, but if the array is full clean_sort_range() returns 0.

The problem is that the number of nonempty elements is evaluated by
finding the first empty element of the array.  If there is no such element
it returns an initial value of local variable nr_range that is zero.

The fix is trivial: it changes initial value of nr_range to size of the
array.

The bug can lead to loss of information regarding all ranges, since
typically returned value of clean_sort_range() is considered as an actual
number of ranges in the array after a series of add/subtract operations.

Found by Analytical Verification project of Linux Verification Center
(linuxtesting.org), thanks to Alexander Kolosov.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/range.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/range.c~kernel-range-fix-clean_sort_range-for-the-case-of-full-array kernel/range.c
--- a/kernel/range.c~kernel-range-fix-clean_sort_range-for-the-case-of-full-array
+++ a/kernel/range.c
@@ -119,7 +119,7 @@ static int cmp_range(const void *x1, con
 
 int clean_sort_range(struct range *range, int az)
 {
-	int i, j, k = az - 1, nr_range = 0;
+	int i, j, k = az - 1, nr_range = az;
 
 	for (i = 0; i < k; i++) {
 		if (range[i].end)
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

kernel-range-fix-clean_sort_range-for-the-case-of-full-array.patch

