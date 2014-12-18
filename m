From: akpm@linux-foundation.org
Subject: +
 linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch added to
 -mm tree
Date: Thu, 18 Dec 2014 14:29:43 -0800
Message-ID: <54935557.NtUVSa4aBtXdanJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaLRW3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/nodemask.h: update bitmap wrappers to take unsigned int
has been added to the -mm tree.  Its filename is
     linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/nodemask.h: update bitmap wrappers to take unsigned int

Since the various bitmap_* functions now take an unsigned int as nbits
parameter, it makes sense to also update the various wrappers.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/nodemask.h~linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int include/linux/nodemask.h
--- a/include/linux/nodemask.h~linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int
+++ a/include/linux/nodemask.h
@@ -120,13 +120,13 @@ static inline void __node_clear(int node
 }
 
 #define nodes_setall(dst) __nodes_setall(&(dst), MAX_NUMNODES)
-static inline void __nodes_setall(nodemask_t *dstp, int nbits)
+static inline void __nodes_setall(nodemask_t *dstp, unsigned int nbits)
 {
 	bitmap_fill(dstp->bits, nbits);
 }
 
 #define nodes_clear(dst) __nodes_clear(&(dst), MAX_NUMNODES)
-static inline void __nodes_clear(nodemask_t *dstp, int nbits)
+static inline void __nodes_clear(nodemask_t *dstp, unsigned int nbits)
 {
 	bitmap_zero(dstp->bits, nbits);
 }
@@ -144,7 +144,7 @@ static inline int __node_test_and_set(in
 #define nodes_and(dst, src1, src2) \
 			__nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -152,7 +152,7 @@ static inline void __nodes_and(nodemask_
 #define nodes_or(dst, src1, src2) \
 			__nodes_or(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_or(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -160,7 +160,7 @@ static inline void __nodes_or(nodemask_t
 #define nodes_xor(dst, src1, src2) \
 			__nodes_xor(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_xor(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -168,7 +168,7 @@ static inline void __nodes_xor(nodemask_
 #define nodes_andnot(dst, src1, src2) \
 			__nodes_andnot(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -176,7 +176,7 @@ static inline void __nodes_andnot(nodema
 #define nodes_complement(dst, src) \
 			__nodes_complement(&(dst), &(src), MAX_NUMNODES)
 static inline void __nodes_complement(nodemask_t *dstp,
-					const nodemask_t *srcp, int nbits)
+					const nodemask_t *srcp, unsigned int nbits)
 {
 	bitmap_complement(dstp->bits, srcp->bits, nbits);
 }
@@ -184,7 +184,7 @@ static inline void __nodes_complement(no
 #define nodes_equal(src1, src2) \
 			__nodes_equal(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_equal(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
 }
@@ -192,7 +192,7 @@ static inline int __nodes_equal(const no
 #define nodes_intersects(src1, src2) \
 			__nodes_intersects(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_intersects(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
 }
@@ -200,25 +200,25 @@ static inline int __nodes_intersects(con
 #define nodes_subset(src1, src2) \
 			__nodes_subset(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_subset(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_empty(src) __nodes_empty(&(src), MAX_NUMNODES)
-static inline int __nodes_empty(const nodemask_t *srcp, int nbits)
+static inline int __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define nodes_full(nodemask) __nodes_full(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_full(const nodemask_t *srcp, int nbits)
+static inline int __nodes_full(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
 
 #define nodes_weight(nodemask) __nodes_weight(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_weight(const nodemask_t *srcp, int nbits)
+static inline int __nodes_weight(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_weight(srcp->bits, nbits);
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

