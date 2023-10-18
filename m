Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81411CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjJRVoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjJRVnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03AFFE
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB8CC433CA;
        Wed, 18 Oct 2023 21:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665429;
        bh=flBRvmVoA96CnClzfuKT12UVToCgGbWzL6kTLXFjnD4=;
        h=Date:To:From:Subject:From;
        b=zGOYMDZzVyNyuELnwby/cKLdTmkyVoAdVwkUi/QK/JXexqz4AGSxlaOzIB02AZums
         ES4Wp/dMzv9e/McnxrXKauzkCXqQgcTPBuJDp14XkZloppe9LLwTjPxwBWUZ2pTMQD
         QmojCyGS3WzGhDFjEmieZ3V8v1GS3CcNEgqmmVPg=
Date:   Wed, 18 Oct 2023 14:43:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, Jason@zx2c4.com, hch@infradead.org,
        david.laight@aculab.com, andriy.shevchenko@linux.intel.com,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmax-add-umina-b-and-umaxa-b.patch removed from -mm tree
Message-Id: <20231018214349.8DB8CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: minmax: add umin(a, b) and umax(a, b)
has been removed from the -mm tree.  Its filename was
     minmax-add-umina-b-and-umaxa-b.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax: add umin(a, b) and umax(a, b)
Date: Mon, 18 Sep 2023 08:16:30 +0000

Patch series "minmax: Relax type checks in min() and max()", v4.

The min() (etc) functions in minmax.h require that the arguments have
exactly the same types.

However when the type check fails, rather than look at the types and fix
the type of a variable/constant, everyone seems to jump on min_t().  In
reality min_t() ought to be rare - when something unusual is being done,
not normality.

The orginal min() (added in 2.4.9) replaced several inline functions and
included the type - so matched the implicit casting of the function call. 
This was renamed min_t() in 2.4.10 and the current min() added.  There is
no actual indication that the conversion of negatve values to large
unsigned values has ever been an actual problem.

A quick grep shows 5734 min() and 4597 min_t().  Having the casts on
almost half of the calls shows that something is clearly wrong.

If the wrong type is picked (and it is far too easy to pick the type of
the result instead of the larger input) then significant bits can get
discarded.

Pretty much the worst example is in the derived clamp_val(), consider:
        unsigned char x = 200u;
        y = clamp_val(x, 10u, 300u);

I also suspect that many of the min_t(u16, ...) are actually wrong.  For
example copy_data() in printk_ringbuffer.c contains:

        data_size = min_t(u16, buf_size, len);

Here buf_size is 'unsigned int' and len 'u16', pass a 64k buffer (can you
prove that doesn't happen?) and no data is returned.  Apparantly it did -
and has since been fixed.

The only reason that most of the min_t() are 'fine' is that pretty much
all the values in the kernel are between 0 and INT_MAX.

Patch 1 adds umin(), this uses integer promotions to convert both
arguments to 'unsigned long long'.  It can be used to compare a signed
type that is known to contain a non-negative value with an unsigned type. 
The compiler typically optimises it all away.  Added first so that it can
be referred to in patch 2.

Patch 2 replaces the 'same type' check with a 'same signedness' one.  This
makes min(unsigned_int_var, sizeof()) be ok.  The error message is also
improved and will contain the expanded form of both arguments (useful for
seeing how constants are defined).

Patch 3 just fixes some whitespace.

Patch 4 allows comparisons of 'unsigned char' and 'unsigned short' to
signed types.  The integer promotion rules convert them both to 'signed
int' prior to the comparison so they can never cause a negative value be
converted to a large positive one.

Patch 5 (rewritted for v4) allows comparisons of unsigned values against
non-negative constant integer expressions.  This makes
min(unsigned_int_var, 4) be ok.

The only common case that is still errored is the comparison of signed
values against unsigned constant integer expressions below __INT_MAX__. 
Typcally min(int_val, sizeof (foo)), the real fix for this is casting the
constant: min(int_var, (int)sizeof (foo)).

With all the patches applied pretty much all the min_t() could be replaced
by min(), and most of the rest by umin().  However they all need careful
inspection due to code like:

        sz = min_t(unsigned char, sz - 1, LIM - 1) + 1;

which converts 0 to LIM.


This patch (of 6):

umin() and umax() can be used when min()/max() errors a signed v unsigned
compare when the signed value is known to be non-negative.

Unlike min_t(some_unsigned_type, a, b) umin() will never mask off high
bits if an inappropriate type is selected.

The '+ 0u + 0ul + 0ull' may look strange.
The '+ 0u' is needed for 'signed int' on 64bit systems.
The '+ 0ul' is needed for 'signed long' on 32bit systems.
The '+ 0ull' is needed for 'signed long long'.

Link: https://lkml.kernel.org/r/b97faef60ad24922b530241c5d7c933c@AcuMS.aculab.com
Link: https://lkml.kernel.org/r/41d93ca827a248698ec64bf57e0c05a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/minmax.h~minmax-add-umina-b-and-umaxa-b
+++ a/include/linux/minmax.h
@@ -77,6 +77,23 @@
 #define max(x, y)	__careful_cmp(x, y, >)
 
 /**
+ * umin - return minimum of two non-negative values
+ *   Signed types are zero extended to match a larger unsigned type.
+ * @x: first value
+ * @y: second value
+ */
+#define umin(x, y)	\
+	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, <)
+
+/**
+ * umax - return maximum of two non-negative values
+ * @x: first value
+ * @y: second value
+ */
+#define umax(x, y)	\
+	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, >)
+
+/**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are


