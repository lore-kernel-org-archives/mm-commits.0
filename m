From: akpm@linux-foundation.org
Subject: + bitops-avoid-integer-overflow-in-genmask_ull.patch added to -mm tree
Date: Thu, 03 Aug 2017 14:50:36 -0700
Message-ID: <59839aac.NkMm+m3V3oCXizj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbdHCVuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 17:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: avoid integer overflow in GENMASK(_ULL)
has been added to the -mm tree.  Its filename is
     bitops-avoid-integer-overflow-in-genmask_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitops-avoid-integer-overflow-in-genmask_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitops-avoid-integer-overflow-in-genmask_ull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: bitops: avoid integer overflow in GENMASK(_ULL)

GENMASK(_ULL) performs a left-shift of ~0UL(L), which technically results
in an integer overflow.  clang raises a warning if the overflow occurs in
a preprocessor expression.  Clear the low-order bits through a
substraction instead of the left-shift to avoid the overflow.

(akpm: no change in .text size in my testing)

Link: http://lkml.kernel.org/r/20170803212020.24939-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/bitops.h~bitops-avoid-integer-overflow-in-genmask_ull include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-avoid-integer-overflow-in-genmask_ull
+++ a/include/linux/bitops.h
@@ -19,10 +19,11 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #define GENMASK(h, l) \
-	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
+	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
 
 #define GENMASK_ULL(h, l) \
-	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
+	(((~0ULL) - (1ULL << (l)) + 1) & \
+	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
_

Patches currently in -mm which might be from mka@chromium.org are

mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch
bitops-avoid-integer-overflow-in-genmask_ull.patch

