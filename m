From: akpm@linux-foundation.org
Subject: [folded-merged] acct-eliminate-compile-warning-fix.patch removed
 from -mm tree
Date: Thu, 09 Oct 2014 13:48:05 -0700
Message-ID: <5436f485.Wkc+z76DhcqtMAs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaJIUsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ying.xue@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acct-eliminate-compile-warning-fix
has been removed from the -mm tree.  Its filename was
     acct-eliminate-compile-warning-fix.patch

This patch was dropped because it was folded into acct-eliminate-compile-warning.patch

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

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-introduce-a-general-rcu-get_user_pages_fast.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation.patch
acct-eliminate-compile-warning.patch

