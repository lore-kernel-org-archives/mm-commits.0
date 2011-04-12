From: akpm@linux-foundation.org
Subject: + lib-remove-abs64-rework-abs.patch added to -mm tree
Date: Tue, 12 Apr 2011 14:08:50 -0700
Message-ID: <201104122108.p3CL8oH1002827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568Ab1DLVIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 17:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     lib: remove abs64(), rework abs()
has been added to the -mm tree.  Its filename is
     lib-remove-abs64-rework-abs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: remove abs64(), rework abs()
From: Alexey Dobriyan <adobriyan@gmail.com>

We don't need no stinking abs64() given some GCC extensions (especially
__builtin_choose_expr()).

One abs() implementation is better than two abs() implementations.

New abs() doesn't expand type needlessly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_irq.c |    4 +--
 include/linux/kernel.h    |   43 +++++++++++++++++-------------------
 lib/div64.c               |    2 -
 3 files changed, 24 insertions(+), 25 deletions(-)

diff -puN drivers/gpu/drm/drm_irq.c~lib-remove-abs64-rework-abs drivers/gpu/drm/drm_irq.c
--- a/drivers/gpu/drm/drm_irq.c~lib-remove-abs64-rework-abs
+++ a/drivers/gpu/drm/drm_irq.c
@@ -154,7 +154,7 @@ static void vblank_disable_and_save(stru
 	 * available. In that case we can't account for this and just
 	 * hope for the best.
 	 */
-	if ((vblrc > 0) && (abs64(diff_ns) > 1000000)) {
+	if ((vblrc > 0) && (abs(diff_ns) > 1000000)) {
 		atomic_inc(&dev->_vblank_count[crtc]);
 		smp_mb__after_atomic_inc();
 	}
@@ -1290,7 +1290,7 @@ bool drm_handle_vblank(struct drm_device
 	 * e.g., due to spurious vblank interrupts. We need to
 	 * ignore those for accounting.
 	 */
-	if (abs64(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {
+	if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {
 		/* Store new timestamp in ringbuffer. */
 		vblanktimestamp(dev, crtc, vblcount + 1) = tvblank;
 
diff -puN include/linux/kernel.h~lib-remove-abs64-rework-abs include/linux/kernel.h
--- a/include/linux/kernel.h~lib-remove-abs64-rework-abs
+++ a/include/linux/kernel.h
@@ -143,28 +143,27 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-/*
- * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
- * input types abs() returns a signed long.
- * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
- * for those.
- */
-#define abs(x) ({						\
-		long ret;					\
-		if (sizeof(x) == sizeof(long)) {		\
-			long __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		} else {					\
-			int __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		}						\
-		ret;						\
-	})
-
-#define abs64(x) ({				\
-		s64 __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+#define abs(x)								\
+({									\
+	typeof(x) _x = (x);						\
+									\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), signed char),	\
+		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), short),	\
+		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), int),		\
+		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long),		\
+		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long long),	\
+		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
+	_x)))));							\
+})
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
diff -puN lib/div64.c~lib-remove-abs64-rework-abs lib/div64.c
--- a/lib/div64.c~lib-remove-abs64-rework-abs
+++ a/lib/div64.c
@@ -121,7 +121,7 @@ s64 div64_s64(s64 dividend, s64 divisor)
 {
 	s64 quot, t;
 
-	quot = div64_u64(abs64(dividend), abs64(divisor));
+	quot = div64_u64(abs(dividend), abs(divisor));
 	t = (dividend ^ divisor) >> 63;
 
 	return (quot ^ t) - t;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
kstrtox-fix-compile-warnings-in-test.patch
kstrtox-simpler-code-in-_kstrtoull.patch
lib-add-kstrto_from_user.patch
lib-remove-abs64-rework-abs.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
sysctl-add-proc_dointvec_bool-handler.patch

