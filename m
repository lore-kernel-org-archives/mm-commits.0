From: akpm@linux-foundation.org
Subject: [merged]
 gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:13 -0700
Message-ID: <20200408020213.-FqAlyQfy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@embeddedor.com, mm-commits@vger.kernel.org, oberpar@linux.ibm.com


The patch titled
     Subject: gcov: gcc_4_7: replace zero-length array with flexible-array member
has been removed from the -mm tree.  Its filename was
     gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: gcov: gcc_4_7: replace zero-length array with flexible-array member

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
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by this
change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied.  As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/20200213152241.GA877@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member
+++ a/kernel/gcov/gcc_4_7.c
@@ -68,7 +68,7 @@ struct gcov_fn_info {
 	unsigned int ident;
 	unsigned int lineno_checksum;
 	unsigned int cfg_checksum;
-	struct gcov_ctr_info ctrs[0];
+	struct gcov_ctr_info ctrs[];
 };
 
 /**
_

Patches currently in -mm which might be from gustavo@embeddedor.com are
