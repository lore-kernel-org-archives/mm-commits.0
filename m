From: akpm@linux-foundation.org
Subject: + introduce-down_try-so-we-can-move-away-from-down_trylock.patch added to -mm tree
Date: Mon, 28 Jul 2008 17:19:45 -0700
Message-ID: <200807290019.m6T0JjqN003824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYG2AU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, hch@infradead.org, matthew@wil.cx, sfr@canb.auug.org.au


The patch titled
     semaphores: introduce down_try() so we can move away from down_trylock()
has been added to the -mm tree.  Its filename is
     introduce-down_try-so-we-can-move-away-from-down_trylock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+static inline int __must_check down_try(struct semaphore *sem)
+{
+        return !down_trylock(sem);
+}
 #endif /* __LINUX_SEMAPHORE_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
introduce-down_try-so-we-can-move-away-from-down_trylock.patch
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

