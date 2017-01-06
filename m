From: akpm@linux-foundation.org
Subject: + find_bit-micro-optimise-find_next__bit-v2.patch added to -mm
 tree
Date: Fri, 06 Jan 2017 13:41:29 -0800
Message-ID: <58700f09.tvpuOPPCwU6KpdDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932854AbdAFVkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 16:40:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, linux@rasmusvillemoes.dk, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: find_bit-micro-optimise-find_next__bit-v2
has been added to the -mm tree.  Its filename is
     find_bit-micro-optimise-find_next__bit-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/find_bit-micro-optimise-find_next__bit-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/find_bit-micro-optimise-find_next__bit-v2.patch

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
Subject: find_bit-micro-optimise-find_next__bit-v2

Link: http://lkml.kernel.org/r/1483709016-1834-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c       |    2 +-
 tools/lib/find_bit.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2 lib/find_bit.c
--- a/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2
+++ a/lib/find_bit.c
@@ -151,7 +151,7 @@ static unsigned long _find_next_bit_le(c
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
diff -puN tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2 tools/lib/find_bit.c
--- a/tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2
+++ a/tools/lib/find_bit.c
@@ -34,7 +34,7 @@ static unsigned long _find_next_bit(cons
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

find_bit-micro-optimise-find_next__bit.patch
find_bit-micro-optimise-find_next__bit-v2.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

