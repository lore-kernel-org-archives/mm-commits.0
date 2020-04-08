From: akpm@linux-foundation.org
Subject: [merged]
 lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:00:54 -0700
Message-ID: <20200408020054.o7qiosiHr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHCAz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ts_bm.c: replace zero-length array with flexible-array member
has been removed from the -mm tree.  Its filename was
     lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
