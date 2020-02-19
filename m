From: akpm@linux-foundation.org
Subject: [merged]
 lib-objagg-replace-zero-length-arrays-with-flexible-array-member.patch
 removed from -mm tree
Date: Wed, 19 Feb 2020 11:16:28 -0800
Message-ID: <20200219191628.b7JvC5Ne7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgBSTQa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 14:16:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@embeddedor.com, jiri@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/objagg.c: replace zero-length arrays with flexible-array member
has been removed from the -mm tree.  Its filename was
     lib-objagg-replace-zero-length-arrays-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: lib/objagg.c: replace zero-length arrays with flexible-array member

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

Link: http://lkml.kernel.org/r/20200211205356.GA23101@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objagg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/objagg.c~lib-objagg-replace-zero-length-arrays-with-flexible-array-member
+++ a/lib/objagg.c
@@ -28,7 +28,7 @@ struct objagg_hints_node {
 	struct objagg_hints_node *parent;
 	unsigned int root_id;
 	struct objagg_obj_stats_info stats_info;
-	unsigned long obj[0];
+	unsigned long obj[];
 };
 
 static struct objagg_hints_node *
@@ -66,7 +66,7 @@ struct objagg_obj {
 				* including nested objects
 				*/
 	struct objagg_obj_stats stats;
-	unsigned long obj[0];
+	unsigned long obj[];
 };
 
 static unsigned int objagg_obj_ref_inc(struct objagg_obj *objagg_obj)
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

lib-bch-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_fsm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_kmp-replace-zero-length-array-with-flexible-array-member.patch
