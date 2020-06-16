From: akpm@linux-foundation.org
Subject: + bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 12:51:40 -0700
Message-ID: <20200616195140.m4xPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbgFPTvl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:51:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yury.norov@gmail.com, pablo@netfilter.org, linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, sbrivio@redhat.com


The patch titled
     Subject: lib/bitmap.c: fix bitmap_cut() for partial overlapping case
has been added to the -mm tree.  Its filename is
     bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefano Brivio <sbrivio@redhat.com>
Subject: lib/bitmap.c: fix bitmap_cut() for partial overlapping case

Patch series "lib: Fix bitmap_cut() for overlaps, add test"


This patch (of 2):

Yury Norov reports that bitmap_cut() will not produce the right outcome if
src and dst partially overlap, with src pointing at some location after
dst, because the memmove() affects src before we store the bits that we
need to keep, that is, the bits preceding the cut -- as long as we the
beginning of the cut is not aligned to a long.

Fix this by storing those bits before the memmove().

Note that this is just a theoretical concern so far, as the only user of
this function, pipapo_drop() from the nftables set back-end implemented in
net/netfilter/nft_set_pipapo.c, always supplies entirely overlapping src
and dst.

Link: http://lkml.kernel.org/r/cover.1592155364.git.sbrivio@redhat.com
Link: http://lkml.kernel.org/r/003e38d4428cd6091ef00b5b03354f1bd7d9091e.1592155364.git.sbrivio@redhat.com
Fixes: 2092767168f0 ("bitmap: Introduce bitmap_cut(): cut bits and shift remaining")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reported-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bitmap.c~bitmap-fix-bitmap_cut-for-partial-overlapping-case
+++ a/lib/bitmap.c
@@ -212,13 +212,13 @@ void bitmap_cut(unsigned long *dst, cons
 	unsigned long keep = 0, carry;
 	int i;
 
-	memmove(dst, src, len * sizeof(*dst));
