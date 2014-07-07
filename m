From: akpm@linux-foundation.org
Subject: + lib-bitmap-simplify-bitmap_parselist.patch added to -mm tree
Date: Mon, 07 Jul 2014 16:22:22 -0700
Message-ID: <53bb2bae.Ui0GYk/QBvlNZhoQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:34248 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaGGXWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:24 -0400
Received: by mail-ig0-f201.google.com with SMTP id h15so5028igd.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: simplify bitmap_parselist
has been added to the -mm tree.  Its filename is
     lib-bitmap-simplify-bitmap_parselist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-simplify-bitmap_parselist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-simplify-bitmap_parselist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: simplify bitmap_parselist

We want len to be the index of the first '\n', or the length of the string
if there is no newline.  This is a good example of the usefulness of
strchrnul().  Use that instead, thus eliminating a branch and a call to
strlen().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-simplify-bitmap_parselist lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-simplify-bitmap_parselist
+++ a/lib/bitmap.c
@@ -665,13 +665,8 @@ static int __bitmap_parselist(const char
 
 int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
 {
-	char *nl  = strchr(bp, '\n');
-	int len;
-
-	if (nl)
-		len = nl - bp;
-	else
-		len = strlen(bp);
+	char *nl  = strchrnul(bp, '\n');
+	int len = nl - bp;
 
 	return __bitmap_parselist(bp, len, 0, maskp, nmaskbits);
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch
lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch
lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch
lib-bitmap-simplify-bitmap_parselist.patch
lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch
lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch
lib-bitmap-micro-optimize-bitmap_allocate_region.patch
lib-bitmap-add-missing-mask-in-bitmap_shift_right.patch
lib-bitmap-add-missing-mask-in-bitmap_and.patch
lib-bitmap-add-missing-mask-in-bitmap_andnot.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch

