From: akpm@linux-foundation.org
Subject: - introduce-down_try-so-we-can-move-away-from-down_trylock.patch removed from -mm tree
Date: Tue, 29 Jul 2008 21:12:57 -0700
Message-ID: <200807300425.m6U4PhSB006794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbYG3EZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 00:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, hch@infradead.org, matthew@wil.cx, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     semaphores: introduce down_try() so we can move away from down_trylock()
has been removed from the -mm tree.  Its filename was
     introduce-down_try-so-we-can-move-away-from-down_trylock.patch

This patch was dropped because of pain integrating it with linux-next. Sorry.

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: semaphores: introduce down_try() so we can move away from down_trylock()
From: Rusty Russell <rusty@rustcorp.com.au>

I planned on removing the much-disliked down_trylock() (with its backwards
return codes) in 2.6.27, but it's creating something of a logjam with
other patches in -mm and linux-next.

Andrew suggested introducing "down_try" as a wrapper now, to make the
transition easier.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/semaphore.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN include/linux/semaphore.h~introduce-down_try-so-we-can-move-away-from-down_trylock include/linux/semaphore.h
--- a/include/linux/semaphore.h~introduce-down_try-so-we-can-move-away-from-down_trylock
+++ a/include/linux/semaphore.h
@@ -46,4 +46,18 @@ extern int __must_check down_trylock(str
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
+/**
+ * down_try - try to down a semaphore, but don't block
+ * @sem: the semaphore
+ *
+ * This is equivalent to down_trylock(), but has the same return codes as
+ * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
+ *
+ * down_trylock() with its confusing return codes will be deprecated
+ * soon.  It will not be missed.
+ */
+static inline bool __must_check down_try(struct semaphore *sem)
+{
+	return !down_trylock(sem);
+}
 #endif /* __LINUX_SEMAPHORE_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

introduce-down_try-so-we-can-move-away-from-down_trylock.patch
scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch
linux-next.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-revert-link-changes.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch

