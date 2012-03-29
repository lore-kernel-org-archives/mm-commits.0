From: akpm@linux-foundation.org
Subject: + spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:44:33 -0700
Message-ID: <20120329214433.991B2A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52518 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab2C2Vog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:44:36 -0400
Received: by faaa19 with SMTP id a19so27022faa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:44:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, w.sang@pengutronix.de


The patch titled
     Subject: spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix
has been added to the -mm tree.  Its filename is
     spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix

- s/hold/held in various places

- reindent for 80 cols

- a few grammatical tweaks

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spinlocks.txt |   40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN Documentation/spinlocks.txt~spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix Documentation/spinlocks.txt
--- a/Documentation/spinlocks.txt~spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix
+++ a/Documentation/spinlocks.txt
@@ -148,40 +148,40 @@ indeed), while write-locks need to prote
 
 spin_is_locked is a bad idea
 
-spin_is_locked checks if a lock is currently hold.  On uniprocessor kernels
-it always returns 0. In general this function should be avoided because most
-uses of it are either redundant or broken.
+spin_is_locked checks if a lock is currently held.  On uniprocessor
+kernels it always returns 0.  In general this function should be avoided
+because most uses of it are either redundant or broken.
 
-People often use spin_is_locked() to check if a particular lock is hold when a function
-is called to enforce a locking discipline, like
+People often use spin_is_locked() to check if a particular lock is held
+when a function is called to enforce a locking discipline, like
 
-	WARN_ON(!spin_is_locked(!my_lock))
+	WARN_ON(!spin_is_locked(&my_lock))
 
 or
 
-	BUG_ON(!spin_is_locked(!my_lock))
+	BUG_ON(!spin_is_locked(&my_lock))
 
 or some variant of those.
 
 This does not work on uniprocessor kernels because they will always fail.
-While there are ways around that they are ugly and not recommended.
-Better use lockdep_assert_held(). This also only checks on a lock debugging
-kernel (which you should occasionally run on your code anyways because
-it catches many more problems).
+While there are ways around that they are ugly and not recommended.  It is
+better to use lockdep_assert_held().  This also only checks on a lock
+debugging kernel (which you should occasionally run on your code anyway
+because it catches many more problems).
 
-In generally this would be better done with static annotation anyways
-(there's some support for it in sparse)
+In generally this would be better done with static annotation anyway
+(there is some support for it in sparse)
 
 	BUG_ON(spin_is_locked(obj->lock));
 	kfree(obj);
 
-Another usage is checking whether a lock is not hold when freeing an object.
-However this is redundant because lock debugging supports this anyways
-without explicit code. Just delete the BUG_ON.
-
-A third usage is to check in a console function if a lock is hold, to get
-a panic crash dump out even when some other thread died in it.
-This is better implemented with spin_try_lock() et.al. and a timeout.
+Another usage is checking whether a lock is not held when freeing an
+object.  However this is redundant because lock debugging supports this
+already without explicit code.  Just delete the BUG_ON.
+
+A third usage is to check in a console function if a lock is held, to get
+a panic crash dump even when some other thread died in it.  This is better
+implemented with spin_try_lock() et.al.  and a timeout.
 
 Other usages are usually simply races.
 
_
Subject: Subject: spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

