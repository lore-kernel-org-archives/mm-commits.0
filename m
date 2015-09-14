From: akpm@linux-foundation.org
Subject: +
 lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch added to
 -mm tree
Date: Mon, 14 Sep 2015 14:25:58 -0700
Message-ID: <55f73b66.XqWdFzj6497W4qbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbINVZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch

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
Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Acked-by: James Bottomley <JBottomley@Odin.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3 lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3
+++ a/lib/string_helpers.c
@@ -59,6 +59,10 @@ void string_get_size(u64 size, u64 blk_s
 	}
 
 	exp = divisor[units] / (u32)blk_size;
+	/*
+	 * size must be strictly greater than exp here to ensure that remainder
+	 * is greater than divisor[units] coming out of the if below.
+	 */
 	if (size > exp) {
 		remainder = do_div(size, divisor[units]);
 		remainder *= blk_size;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch
lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch
lib-test-string_helpersc-add-string_get_size-tests.patch

