From: akpm@linux-foundation.org
Subject: [merged] lib-idr-fix-out-of-bounds-pointer-dereference.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:28 -0700
Message-ID: <53ea6dac.BWhhUkqzhEeAlTS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:37579 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaHLTk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:29 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1068888igd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, koct9i@gmail.com, laijs@cn.fujitsu.com, preobr@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: fix out-of-bounds pointer dereference
has been removed from the -mm tree.  Its filename was
     lib-idr-fix-out-of-bounds-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: lib/idr.c: fix out-of-bounds pointer dereference

I'm working on address sanitizer project for kernel.  Recently we started
experiments with stack instrumentation, to detect out-of-bounds read/write
bugs on stack.

Just after booting I've hit out-of-bounds read on stack in idr_for_each
(and in __idr_remove_all as well):

	struct idr_layer **paa = &pa[0];

	while (id >= 0 && id <= max) {
		...
		while (n < fls(id)) {
			n += IDR_BITS;
			p = *--paa; <--- here we are reading pa[-1] value.
		}
	}

Despite the fact that after this dereference we are exiting out of loop
and never use p, such behaviour is undefined and should be avoided.

Fix this by moving pointer derference to the beggining of the loop, right
before we will use it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alexey Preobrazhensky <preobr@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN lib/idr.c~lib-idr-fix-out-of-bounds-pointer-dereference lib/idr.c
--- a/lib/idr.c~lib-idr-fix-out-of-bounds-pointer-dereference
+++ a/lib/idr.c
@@ -590,26 +590,27 @@ static void __idr_remove_all(struct idr
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	*paa = idp->top;
 	RCU_INIT_POINTER(idp->top, NULL);
 	max = idr_max(idp->layers);
 
 	id = 0;
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = p->ary[(id >> n) & IDR_MASK];
+			*++paa = p;
 		}
 
 		bt_mask = id;
 		id += 1 << n;
 		/* Get the highest bit that the above add changed from 0->1. */
 		while (n < fls(id ^ bt_mask)) {
-			if (p)
-				free_layer(idp, p);
+			if (*paa)
+				free_layer(idp, *paa);
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 	idp->layers = 0;
@@ -692,15 +693,16 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = rcu_dereference_raw(idp->top);
+	*paa = rcu_dereference_raw(idp->top);
 	max = idr_max(idp->layers);
 
 	id = 0;
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > 0 && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
+			*++paa = p;
 		}
 
 		if (p) {
@@ -712,7 +714,7 @@ int idr_for_each(struct idr *idp,
 		id += 1 << n;
 		while (n < fls(id)) {
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 
@@ -740,17 +742,18 @@ void *idr_get_next(struct idr *idp, int
 	int n, max;
 
 	/* find first ent */
-	p = rcu_dereference_raw(idp->top);
+	p = *paa = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer + 1) * IDR_BITS;
 	max = idr_max(p->layer + 1);
 
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > 0 && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
+			*++paa = p;
 		}
 
 		if (p) {
@@ -768,7 +771,7 @@ void *idr_get_next(struct idr *idp, int
 		id = round_up(id + 1, 1 << n);
 		while (n < fls(id)) {
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 	return NULL;
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

