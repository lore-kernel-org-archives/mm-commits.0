From: akpm@linux-foundation.org
Subject: + lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch
 tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:18:02 -0700
Message-ID: <55f7398a.BVx43aRgdIpfs02W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, James.Bottomley@HansenPartnership.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c: fix infinite loop in string_get_size()
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib/string_helpers.c: fix infinite loop in string_get_size()

Some string_get_size() calls (e.g.:
 string_get_size(1, 512, STRING_UNITS_10, ..., ...)
 string_get_size(15, 64, STRING_UNITS_10, ..., ...)
) result in an infinite loop. The problem is that if size is equal to
divisor[units]/blk_size and is smaller than divisor[units] we'll end
up with size == 0 when we start doing sf_cap calculations:

For string_get_size(1, 512, STRING_UNITS_10, ..., ...) case:
   ...
   remainder = do_div(size, divisor[units]); -> size is 0, remainder is 1
   remainder *= blk_size; -> remainder is 512
   ...
   size *= blk_size; -> size is still 0
   size += remainder / divisor[units]; -> size is still 0

The caller causing the issue is sd_read_capacity(), the problem was
noticed on Hyper-V, such weird size was reported by host when scanning
collides with device removal.  This is probably a separate issue worth
fixing, this patch is intended to prevent the library routing from
infinite looping.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size
+++ a/lib/string_helpers.c
@@ -59,7 +59,7 @@ void string_get_size(u64 size, u64 blk_s
 	}
 
 	exp = divisor[units] / (u32)blk_size;
-	if (size >= exp) {
+	if (size > exp) {
 		remainder = do_div(size, divisor[units]);
 		remainder *= blk_size;
 		i++;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch

