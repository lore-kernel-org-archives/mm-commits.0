From: akpm@linux-foundation.org
Subject: + find_bit-micro-optimise-find_next__bit.patch added to -mm tree
Date: Thu, 05 Jan 2017 17:19:06 -0800
Message-ID: <586ef08a.yZe+xDRyhTV2fTqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdAFBSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 20:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, linux@rasmusvillemoes.dk, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/find_bit.c: micro-optimise find_next_*_bit
has been added to the -mm tree.  Its filename is
     find_bit-micro-optimise-find_next__bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/find_bit-micro-optimise-find_next__bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/find_bit-micro-optimise-find_next__bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: lib/find_bit.c: micro-optimise find_next_*_bit

This saves 20 bytes on my x86-64 build, mostly due to alignment
considerations ...  I think it actually saves about five bytes of
instructions.  There's really two parts to this commit.  First, the first
half of the test: (!nbits || start >= nbits) is trivially a subset of the
second half, since nbits and start are both unsigned.  Second, while
looking at the disassembly, I noticed that GCC was predicting the branch
taken.  Since this is a failure case, it's clearly the less likely of the
two branches, so add an unlikely() to override GCC's heuristics.

Link: http://lkml.kernel.org/r/1482513603-9630-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/find_bit.c~find_bit-micro-optimise-find_next__bit lib/find_bit.c
--- a/lib/find_bit.c~find_bit-micro-optimise-find_next__bit
+++ a/lib/find_bit.c
@@ -33,7 +33,7 @@ static unsigned long _find_next_bit(cons
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

find_bit-micro-optimise-find_next__bit.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

