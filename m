Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFC1E82CBB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 17:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjI0Ral (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjI0Ral (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 13:30:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24FCF3
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 10:30:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF4C433C7;
        Wed, 27 Sep 2023 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695835839;
        bh=CVrsjc5x+C/rdcZma67sYuSdp78ASsu8ZOb0/TFjkuI=;
        h=Date:To:From:Subject:From;
        b=Edu1E+vlcmziEydwe274AqxGy6Av/ipFEkDk1v5eqTuIWzI+Y8j66GE4Il3FnPa17
         LQNoX6eaPmpvsLRj5EOpTjx3OUhL+FHnua91QBnDdVI8+VBtRi0oNixu2hysDNd/Mp
         Pz3041C6zZ2lNnkdkpQJ4tzS46LxJYsReG8hOCjY=
Date:   Wed, 27 Sep 2023 10:30:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, Jason@zx2c4.com, hch@infradead.org,
        david.laight@aculab.com, andriy.shevchenko@linux.intel.com,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-allow-comparisons-of-int-against-unsigned-char-short.patch added to mm-nonmm-unstable branch
Message-Id: <20230927173039.3EBF4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: allow comparisons of 'int' against 'unsigned char/short'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-allow-comparisons-of-int-against-unsigned-char-short.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch

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

minmax-add-umina-b-and-umaxa-b.patch
minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch

