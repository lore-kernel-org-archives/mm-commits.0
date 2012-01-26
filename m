From: akpm@linux-foundation.org
Subject: + kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch added to -mm tree
Date: Wed, 25 Jan 2012 16:41:42 -0800
Message-ID: <20120126004142.3F474A0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53334 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2AZAlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 19:41:44 -0500
Received: by eaaf1 with SMTP id f1so1796eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 16:41:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     Subject: kmod-avoid-deadlock-by-recursive-kmod-call-fix
has been added to the -mm tree.  Its filename is
     kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch

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
Subject: kmod-avoid-deadlock-by-recursive-kmod-call-fix

add comment to kmod_thread_locker

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/kmod.c~kmod-avoid-deadlock-by-recursive-kmod-call-fix kernel/kmod.c
--- a/kernel/kmod.c~kmod-avoid-deadlock-by-recursive-kmod-call-fix
+++ a/kernel/kmod.c
@@ -44,6 +44,12 @@
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
+
+/*
+ * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
+ * locking to protect this global - it is private to the singleton khelper
+ * thread and should only ever be modified by that thread.
+ */
 static const struct task_struct *kmod_thread_locker;
 
 #define CAP_BSET	(void *)1
_
Subject: Subject: kmod-avoid-deadlock-by-recursive-kmod-call-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

