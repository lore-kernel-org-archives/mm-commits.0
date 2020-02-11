From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch added
 to -mm tree
Date: Tue, 11 Feb 2020 15:21:55 -0800
Message-ID: <20200211232155.G77XK66d5%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgBKXV4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 18:21:56 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ts_bm.c: replace zero-length array with flexible-array member
has been added to the -mm tree.  Its filename is
     lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: lib/ts_bm.c: replace zero-length array with flexible-array member

The current codebase makes use of the zero-length array language extension
to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning in
case the flexible array does not occur last in the structure, which will
help us prevent some kind of undefined behavior bugs from being
inadvertenly introduced[3] to the codebase from now on.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/20200211205620.GA24694@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ts_bm.c~lib-ts_bm-replace-zero-length-array-with-flexible-array-member
+++ a/lib/ts_bm.c
@@ -52,7 +52,7 @@ struct ts_bm
 	u8 *		pattern;
 	unsigned int	patlen;
 	unsigned int 	bad_shift[ASIZE];
-	unsigned int	good_shift[0];
+	unsigned int	good_shift[];
 };
 
 static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

lib-bch-replace-zero-length-array-with-flexible-array-member.patch
lib-objagg-replace-zero-length-arrays-with-flexible-array-member.patch
lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_fsm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_kmp-replace-zero-length-array-with-flexible-array-member.patch
