From: akpm@linux-foundation.org
Subject: + asm-generic-remove-fastcall.patch added to -mm tree
Date: Thu, 20 Dec 2007 18:27:08 -0800
Message-ID: <200712210227.lBL2R8vu025445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbXLUC1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 21:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     asm-generic: remove fastcall
has been added to the -mm tree.  Its filename is
     asm-generic-remove-fastcall.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: asm-generic: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/iomap.h      |   36 ++++++++++++++---------------
 include/asm-generic/mutex-dec.h  |    6 ++--
 include/asm-generic/mutex-xchg.h |    6 ++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff -puN include/asm-generic/iomap.h~asm-generic-remove-fastcall include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~asm-generic-remove-fastcall
+++ a/include/asm-generic/iomap.h
@@ -25,17 +25,17 @@
  * in the low address range. Architectures for which this is not
  * true can't use this generic implementation.
  */
-extern unsigned int fastcall ioread8(void __iomem *);
-extern unsigned int fastcall ioread16(void __iomem *);
-extern unsigned int fastcall ioread16be(void __iomem *);
-extern unsigned int fastcall ioread32(void __iomem *);
-extern unsigned int fastcall ioread32be(void __iomem *);
-
-extern void fastcall iowrite8(u8, void __iomem *);
-extern void fastcall iowrite16(u16, void __iomem *);
-extern void fastcall iowrite16be(u16, void __iomem *);
-extern void fastcall iowrite32(u32, void __iomem *);
-extern void fastcall iowrite32be(u32, void __iomem *);
+extern unsigned int ioread8(void __iomem *);
+extern unsigned int ioread16(void __iomem *);
+extern unsigned int ioread16be(void __iomem *);
+extern unsigned int ioread32(void __iomem *);
+extern unsigned int ioread32be(void __iomem *);
+
+extern void iowrite8(u8, void __iomem *);
+extern void iowrite16(u16, void __iomem *);
+extern void iowrite16be(u16, void __iomem *);
+extern void iowrite32(u32, void __iomem *);
+extern void iowrite32be(u32, void __iomem *);
 
 /*
  * "string" versions of the above. Note that they
@@ -48,13 +48,13 @@ extern void fastcall iowrite32be(u32, vo
  * memory across multiple ports, use "memcpy_toio()"
  * and friends.
  */
-extern void fastcall ioread8_rep(void __iomem *port, void *buf, unsigned long count);
-extern void fastcall ioread16_rep(void __iomem *port, void *buf, unsigned long count);
-extern void fastcall ioread32_rep(void __iomem *port, void *buf, unsigned long count);
-
-extern void fastcall iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void fastcall iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void fastcall iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void ioread8_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread16_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread32_rep(void __iomem *port, void *buf, unsigned long count);
+
+extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
 
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
diff -puN include/asm-generic/mutex-dec.h~asm-generic-remove-fastcall include/asm-generic/mutex-dec.h
--- a/include/asm-generic/mutex-dec.h~asm-generic-remove-fastcall
+++ a/include/asm-generic/mutex-dec.h
@@ -18,7 +18,7 @@
  * 1 even when the "1" assertion wasn't true.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		fail_fn(count);
@@ -37,7 +37,7 @@ __mutex_fastpath_lock(atomic_t *count, f
  * or anything the slow path function returns.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -61,7 +61,7 @@ __mutex_fastpath_lock_retval(atomic_t *c
  * to return 0 otherwise.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	smp_mb();
 	if (unlikely(atomic_inc_return(count) <= 0))
diff -puN include/asm-generic/mutex-xchg.h~asm-generic-remove-fastcall include/asm-generic/mutex-xchg.h
--- a/include/asm-generic/mutex-xchg.h~asm-generic-remove-fastcall
+++ a/include/asm-generic/mutex-xchg.h
@@ -23,7 +23,7 @@
  * even when the "1" assertion wasn't true.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		fail_fn(count);
@@ -42,7 +42,7 @@ __mutex_fastpath_lock(atomic_t *count, f
  * or anything the slow path function returns
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		return fail_fn(count);
@@ -65,7 +65,7 @@ __mutex_fastpath_lock_retval(atomic_t *c
  * to return 0 otherwise.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	smp_mb();
 	if (unlikely(atomic_xchg(count, 1) != 0))
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-net.patch
git-sh.patch
git-x86.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
asm-generic-remove-fastcall.patch
