From: akpm@linux-foundation.org
Subject: + lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch added to -mm tree
Date: Tue, 14 Jul 2015 15:30:28 -0700
Message-ID: <55a58d84.z3yHRPyt3HnBqEGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbGNWa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xinhuix.pan@intel.com, cmetcalf@ezchip.com, linux@rasmusvillemoes.dk, sudeep.holla@arm.com, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: correct a code style and do some, optimization
has been added to the -mm tree.  Its filename is
     lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pan Xinhui <xinhuix.pan@intel.com>
Subject: lib/bitmap.c: correct a code style and do some, optimization

We can avoid in-loop incrementation of ndigits.  Save current totaldigits
to ndigits before loop, and check ndigits against totaldigits after the
loop.

Signed-off-by: Pan Xinhui <xinhuix.pan@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-correct-a-code-style-and-do-some-optimization lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-correct-a-code-style-and-do-some-optimization
+++ a/lib/bitmap.c
@@ -367,7 +367,8 @@ int __bitmap_parse(const char *buf, unsi
 
 	nchunks = nbits = totaldigits = c = 0;
 	do {
-		chunk = ndigits = 0;
+		chunk = 0;
+		ndigits = totaldigits;
 
 		/* Get the next chunk of the bitmap */
 		while (buflen) {
@@ -406,9 +407,9 @@ int __bitmap_parse(const char *buf, unsi
 				return -EOVERFLOW;
 
 			chunk = (chunk << 4) | hex_to_bin(c);
-			ndigits++; totaldigits++;
+			totaldigits++;
 		}
-		if (ndigits == 0)
+		if (ndigits == totaldigits)
 			return -EINVAL;
 		if (nchunks == 0 && chunk == 0)
 			continue;
_

Patches currently in -mm which might be from xinhuix.pan@intel.com are

lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch
lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch
linux-next.patch

