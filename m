From: akpm@linux-foundation.org
Subject: +
 linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch added to
 -mm tree
Date: Thu, 18 Dec 2014 14:29:45 -0800
Message-ID: <54935559.WqYYObXs2I1WjYqi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaLRW3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/cpumask.h: update bitmap wrappers to take unsigned int
has been added to the -mm tree.  Its filename is
     linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

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
Subject: linux/cpumask.h: update bitmap wrappers to take unsigned int

Since the various bitmap_* functions now take an unsigned int as nbits
parameter, it makes sense to also update the various wrappers, even though
they're marked as obsolete.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/cpumask.h~linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int include/linux/cpumask.h
--- a/include/linux/cpumask.h~linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int
+++ a/include/linux/cpumask.h
@@ -905,13 +905,13 @@ static inline void __cpu_clear(int cpu,
 }
 
 #define cpus_setall(dst) __cpus_setall(&(dst), NR_CPUS)
-static inline void __cpus_setall(cpumask_t *dstp, int nbits)
+static inline void __cpus_setall(cpumask_t *dstp, unsigned int nbits)
 {
 	bitmap_fill(dstp->bits, nbits);
 }
 
 #define cpus_clear(dst) __cpus_clear(&(dst), NR_CPUS)
-static inline void __cpus_clear(cpumask_t *dstp, int nbits)
+static inline void __cpus_clear(cpumask_t *dstp, unsigned int nbits)
 {
 	bitmap_zero(dstp->bits, nbits);
 }
@@ -927,21 +927,21 @@ static inline int __cpu_test_and_set(int
 
 #define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
 static inline int __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
 static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
 static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -949,40 +949,40 @@ static inline void __cpus_xor(cpumask_t
 #define cpus_andnot(dst, src1, src2) \
 				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
 static inline int __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
 static inline int __cpus_equal(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
 static inline int __cpus_intersects(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
 static inline int __cpus_subset(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+					const cpumask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
-static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
+static inline int __cpus_empty(const cpumask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
-static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
+static inline int __cpus_weight(const cpumask_t *srcp, unsigned int nbits)
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

