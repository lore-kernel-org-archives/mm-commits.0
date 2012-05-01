From: akpm@linux-foundation.org
Subject: + ipc-mqueue-correct-mq_attr_ok-test-fix.patch added to -mm tree
Date: Tue, 01 May 2012 12:36:50 -0700
Message-ID: <20120501193650.CFF95A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58419 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab2EATgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:36:52 -0400
Received: by ghbz15 with SMTP id z15so501192ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:36:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dledford@redhat.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc-mqueue-correct-mq_attr_ok-test-fix
has been added to the -mm tree.  Its filename is
     ipc-mqueue-correct-mq_attr_ok-test-fix.patch

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
Subject: ipc-mqueue-correct-mq_attr_ok-test-fix

add a local to simplify overflow-checking expression

Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix
+++ a/ipc/mqueue.c
@@ -672,6 +672,7 @@ static void remove_notification(struct m
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
 	int mq_treesize;
+	unsigned long total_size;
 
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
@@ -690,9 +691,8 @@ static int mq_attr_ok(struct ipc_namespa
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
-	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
-			    mq_treesize) <
-	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
+	total_size = attr->mq_maxmsg * attr->mq_msgsize;
+	if (total_size + mq_treesize < total_size)
 		return 0;
 	return 1;
 }
_
Subject: Subject: ipc-mqueue-correct-mq_attr_ok-test-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

