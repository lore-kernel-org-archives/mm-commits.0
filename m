From: akpm@linux-foundation.org
Subject: +
 lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 15:30:30 -0700
Message-ID: <55a58d86.kMo/kriwwLoeswsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbGNWab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xinhuix.pan@intel.com, cmetcalf@ezchip.com, linux@rasmusvillemoes.dk, sudeep.holla@arm.com, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: fix a special string handling bug in __bitmap_parselist
has been added to the -mm tree.  Its filename is
     lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch

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
Subject: lib/bitmap.c: fix a special string handling bug in __bitmap_parselist

If string end with '-', for exapmle, bitmap_parselist("1,0-",&mask,
nmaskbits), It is not in a valid pattern, so add a check after loop. 
Return -EINVAL on such condition.

Signed-off-by: Pan Xinhui <xinhuix.pan@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/bitmap.c~lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist
+++ a/lib/bitmap.c
@@ -546,6 +546,7 @@ static int __bitmap_parselist(const char
 					return -EINVAL;
 				b = 0;
 				in_range = 1;
+				at_start = 1;
 				continue;
 			}
 
@@ -558,6 +559,9 @@ static int __bitmap_parselist(const char
 			at_start = 0;
 			totaldigits++;
 		}
+		/* if no digit is after '-', it's wrong*/
+		if (at_start && in_range)
+			return -EINVAL;
 		if (!(a <= b))
 			return -EINVAL;
 		if (b >= nmaskbits)
_

Patches currently in -mm which might be from xinhuix.pan@intel.com are

lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch
lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch
linux-next.patch

