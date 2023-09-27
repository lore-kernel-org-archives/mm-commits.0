Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD197E82CB7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 17:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjI0Ral (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjI0Raj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 13:30:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6528A1
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 10:30:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E175C433C8;
        Wed, 27 Sep 2023 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695835837;
        bh=4F7q4Eytdhdq3gK9l4yx1SujtuvsyY+gAoZVygQ2mUU=;
        h=Date:To:From:Subject:From;
        b=xziqURrhUjcu1aDlY77MuHuPmkecr51Pd5VoxfgPfSR+qn+1qrjdUzqqHcyAHojcn
         vcCMt9A4WH9zd5ZEqa+wsYhqyVMtKOLpB2WAuBKQkn/64QgLrw2To1QjpX120rgF4k
         j/qw8Wf7qu4qiCo43mqOjgYEMJG2jToY99wGsSIU=
Date:   Wed, 27 Sep 2023 10:30:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, Jason@zx2c4.com, hch@infradead.org,
        david.laight@aculab.com, andriy.shevchenko@linux.intel.com,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch added to mm-nonmm-unstable branch
Message-Id: <20230927173037.6E175C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: fix indentation of __cmp_once() and __clamp_once()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Mon, 18 Sep 2023 08:17:57 +0000

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/minmax.h~minmax-fix-indentation-of-__cmp_once-and-__clamp_once
+++ a/include/linux/minmax.h
@@ -35,11 +35,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -49,16 +49,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are

minmax-add-umina-b-and-umaxa-b.patch
minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch

