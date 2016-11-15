From: akpm@linux-foundation.org
Subject: + z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch added to -mm tree
Date: Tue, 15 Nov 2016 15:42:06 -0800
Message-ID: <582b9d4e.BWe00UyYgfmJ3Zmf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcKOXmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:42:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: don't fail kernel build if z3fold_header is too big
has been added to the -mm tree.  Its filename is
     z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: don't fail kernel build if z3fold_header is too big

Currently the whole kernel build will be stopped if the size of struct
z3fold_header is greater than the size of one chunk, which is 64 bytes by
default.  This may stand in the way of automated test/debug builds so
let's remove that and just fail the z3fold initialization in such case
instead.

Link: http://lkml.kernel.org/r/20161115170030.f0396011fa00423ff711a3b4@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/z3fold.c~z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big mm/z3fold.c
--- a/mm/z3fold.c~z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big
+++ a/mm/z3fold.c
@@ -870,10 +870,15 @@ MODULE_ALIAS("zpool-z3fold");
 
 static int __init init_z3fold(void)
 {
-	/* Make sure the z3fold header will fit in one chunk */
-	BUILD_BUG_ON(sizeof(struct z3fold_header) > ZHDR_SIZE_ALIGNED);
-	zpool_register_driver(&z3fold_zpool_driver);
+	/* Fail the initialization if z3fold header won't fit in one chunk */
+	if (sizeof(struct z3fold_header) > ZHDR_SIZE_ALIGNED) {
+		pr_err("z3fold: z3fold_header size (%d) is bigger than "
+			"the chunk size (%d), can't proceed\n",
+			sizeof(struct z3fold_header) , ZHDR_SIZE_ALIGNED);
+		return -E2BIG;
+	}
 
+	zpool_register_driver(&z3fold_zpool_driver);
 	return 0;
 }
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-make-pages_nr-atomic.patch
z3fold-extend-compaction-function.patch
z3fold-use-per-page-spinlock.patch
z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch
z3fold-discourage-use-of-pages-that-werent-compacted.patch

