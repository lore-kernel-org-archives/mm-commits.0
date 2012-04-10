From: akpm@linux-foundation.org
Subject: + mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch added to -mm tree
Date: Tue, 10 Apr 2012 11:43:45 -0700
Message-ID: <20120410184345.C5CADA0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37824 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab2DJSnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 14:43:46 -0400
Received: by ghbz15 with SMTP id z15so15288ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 11:43:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, markus@trippelsdorf.de, oleg@redhat.com


The patch titled
     Subject: mm-correctly-synchronize-rss-counters-at-exit-exec-fix
has been added to the -mm tree.  Its filename is
     mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch

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
Subject: mm-correctly-synchronize-rss-counters-at-exit-exec-fix

Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec-fix kernel/fork.c
--- a/kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec-fix
+++ a/kernel/fork.c
@@ -782,8 +782,8 @@ void mm_release(struct task_struct *tsk,
 	}
 
 	/*
-	 * Final rss-counter synchronization. After this point must be
-	 * no page-faults into this mm from current context, otherwise
+	 * Final rss-counter synchronization. After this point there must be
+	 * no pagefaults into this mm from the current context.  Otherwise
 	 * mm->rss_stat will be inconsistent.
 	 */
 	if (mm)
_
Subject: Subject: mm-correctly-synchronize-rss-counters-at-exit-exec-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

