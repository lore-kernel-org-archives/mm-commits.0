From: akpm@linux-foundation.org
Subject: [merged]
 linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:22:18 -0800
Message-ID: <54de5cfa.DPMW4N5PpgPnWyou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbBMUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/cpumask.h: update bitmap wrappers to take unsigned int
has been removed from the -mm tree.  Its filename was
     linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

