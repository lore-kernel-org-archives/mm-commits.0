Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8C3CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjJRV7x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjJRVny (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F712A
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD1C433C8;
        Wed, 18 Oct 2023 21:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665432;
        bh=vFz11V8x8BEqZvsp6f5GfAcDLS+ie7ltkC0bxZBSngQ=;
        h=Date:To:From:Subject:From;
        b=FRwrPSGRQ0c2hu4V4NQyRqjelGrt1owiVK9YWdBUYDOI+UgbgkI9/zr2lEfFeQl68
         H4AqZ2hRZ5SnxD/2SarIWm+ntUuzE8bMajG7gD4pKz4n20bLn21JGvTUCO7P7y0fqO
         48zOxOKbIIxvpYxzr5lFguKHl7r/e/+C8/1k07jg=
Date:   Wed, 18 Oct 2023 14:43:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, Jason@zx2c4.com, hch@infradead.org,
        david.laight@aculab.com, andriy.shevchenko@linux.intel.com,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmax-allow-comparisons-of-int-against-unsigned-char-short.patch removed from -mm tree
Message-Id: <20231018214352.27FD1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: minmax: allow comparisons of 'int' against 'unsigned char/short'
has been removed from the -mm tree.  Its filename was
     minmax-allow-comparisons-of-int-against-unsigned-char-short.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax: allow comparisons of 'int' against 'unsigned char/short'
Date: Mon, 18 Sep 2023 08:18:40 +0000

Since 'unsigned char/short' get promoted to 'signed int' it is safe to
compare them against an 'int' value.

Link: https://lkml.kernel.org/r/8732ef5f809c47c28a7be47c938b28d4@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h~minmax-allow-comparisons-of-int-against-unsigned-char-short
+++ a/include/linux/minmax.h
@@ -26,8 +26,9 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) \
-	(__is_signed(x) == __is_signed(y))
+#define __types_ok(x, y) 			\
+	(__is_signed(x) == __is_signed(y) ||	\
+		__is_signed((x) + 0) == __is_signed((y) + 0))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are


