From: akpm@linux-foundation.org
Subject: [merged]
 linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:22:16 -0800
Message-ID: <54de5cf8.9If7d4rgIiJv4zEo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbBMUWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/nodemask.h: update bitmap wrappers to take unsigned int
has been removed from the -mm tree.  Its filename was
     linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

