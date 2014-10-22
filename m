From: akpm@linux-foundation.org
Subject: + bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
 added to -mm tree
Date: Wed, 22 Oct 2014 12:43:44 -0700
Message-ID: <544808f0.XBPd9co/bqA0Z8DR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaJVTno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, linux@rasmusvillemoes.dk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
has been added to the -mm tree.  Its filename is
     bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()

If __bitmap_shift_left() or __bitmap_shift_right() are asked to shift by a
multiple of BITS_PER_LONG, they will try to shift a long value by
BITS_PER_LONG bits which is undefined.  Change the functions to avoid the
undefined shift.

Coverity id: 1192175
Coverity id: 1192174

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~bitmap-fix-undefined-shift-in-__bitmap_shift_leftright lib/bitmap.c
--- a/lib/bitmap.c~bitmap-fix-undefined-shift-in-__bitmap_shift_leftright
+++ a/lib/bitmap.c
@@ -131,7 +131,9 @@ void __bitmap_shift_right(unsigned long
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = upper << (BITS_PER_LONG - rem) | lower >> rem;
+		dst[k] = lower >> rem;
+		if (rem)
+			dst[k] |= upper << (BITS_PER_LONG - rem);
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
@@ -172,7 +174,9 @@ void __bitmap_shift_left(unsigned long *
 		upper = src[k];
 		if (left && k == lim - 1)
 			upper &= (1UL << left) - 1;
-		dst[k + off] = lower  >> (BITS_PER_LONG - rem) | upper << rem;
+		dst[k + off] = upper << rem;
+		if (rem)
+			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
 		if (left && k + off == lim - 1)
 			dst[k + off] &= (1UL << left) - 1;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-add-strictlimit-knob-v2.patch

