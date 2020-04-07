From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 148/166] gcov: gcc_3_4: replace zero-length array
 with flexible-array member
Date: Mon, 06 Apr 2020 20:11:55 -0700
Message-ID: <20200407031155.sjtwHB7DK%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDL5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:57 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gustavo@embeddedor.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, oberpar@linux.ibm.com, torvalds@linux-foundation.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: gcov: gcc_3_4: replace zero-length array with flexible-array member

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

Link: http://lkml.kernel.org/r/20200302224501.GA14175@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_3_4.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/gcov/gcc_3_4.c~gcov-gcc_3_4-replace-zero-length-array-with-flexible-array-member
+++ a/kernel/gcov/gcc_3_4.c
@@ -38,7 +38,7 @@ static struct gcov_info *gcov_info_head;
 struct gcov_fn_info {
 	unsigned int ident;
 	unsigned int checksum;
-	unsigned int n_ctrs[0];
+	unsigned int n_ctrs[];
 };
 
 /**
@@ -78,7 +78,7 @@ struct gcov_info {
 	unsigned int			n_functions;
 	const struct gcov_fn_info	*functions;
 	unsigned int			ctr_mask;
-	struct gcov_ctr_info		counts[0];
+	struct gcov_ctr_info		counts[];
 };
 
 /**
@@ -352,7 +352,7 @@ struct gcov_iterator {
 	unsigned int count;
 
 	int num_types;
-	struct type_info type_info[0];
+	struct type_info type_info[];
 };
 
 static struct gcov_fn_info *get_func(struct gcov_iterator *iter)
_
