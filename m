From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch removed
 from -mm tree
Date: Thu, 17 Sep 2015 15:59:09 -0700
Message-ID: <55fb45bd.E7U7PkJ+xcWCfIWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbIQW7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 18:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3
has been removed from the -mm tree.  Its filename was
     lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch

This patch was dropped because it was folded into lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3

Add a couple of simple tests for string_get_size().  The last one will
hang the kernel without the 'lib/string_helpers.c: fix infinite loop in
string_get_size()' fix.

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
lib-test-string_helpersc-add-string_get_size-tests.patch
lib-test-string_helpersc-add-string_get_size-tests-v5.patch

