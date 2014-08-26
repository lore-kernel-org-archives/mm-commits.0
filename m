From: akpm@linux-foundation.org
Subject: + acct-eliminate-compile-warning-fix.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:25:31 -0700
Message-ID: <53fd176b.CNez9m8Ol1tq5E1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52669 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbaHZXZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:25:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1834094qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:25:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ying.xue@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acct-eliminate-compile-warning-fix
has been added to the -mm tree.  Its filename is
     acct-eliminate-compile-warning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/acct-eliminate-compile-warning-fix.patch

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
Subject: acct-eliminate-compile-warning-fix

retain the local for code size improvements

Cc: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN kernel/acct.c~acct-eliminate-compile-warning-fix kernel/acct.c
--- a/kernel/acct.c~acct-eliminate-compile-warning-fix
+++ a/kernel/acct.c
@@ -499,11 +499,15 @@ static void do_acct_process(struct bsd_a
 	ac.ac_gid16 = ac.ac_gid;
 #endif
 #if ACCT_VERSION == 3
-	ac.ac_pid = task_tgid_nr_ns(current, acct->ns);
-	rcu_read_lock();
-	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
-				     acct->ns);
-	rcu_read_unlock();
+	{
+		struct pid_namespace *ns = acct->ns;
+
+		ac.ac_pid = task_tgid_nr_ns(current, ns);
+		rcu_read_lock();
+		ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
+					     ns);
+		rcu_read_unlock();
+	}
 #endif
 	/*
 	 * Get freeze protection. If the fs is frozen, just skip the write
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-unisys-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
watchdog-control-hard-lockup-detection-default-fix.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

