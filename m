From: akpm@linux-foundation.org
Subject: [folded-merged] exec-account-for-argv-envp-pointers-fix.patch
 removed from -mm tree
Date: Fri, 23 Jun 2017 15:06:42 -0700
Message-ID: <594d90f2.PwRVU2RDzBGOzeNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdFWWGo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exec-account-for-argv-envp-pointers-fix
has been removed from the -mm tree.  Its filename was
     exec-account-for-argv-envp-pointers-fix.patch

This patch was dropped because it was folded into exec-account-for-argv-envp-pointers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: exec-account-for-argv-envp-pointers-fix

additional commenting from Kees

Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/exec.c~exec-account-for-argv-envp-pointers-fix fs/exec.c
--- a/fs/exec.c~exec-account-for-argv-envp-pointers-fix
+++ a/fs/exec.c
@@ -226,6 +226,14 @@ static struct page *get_arg_page(struct
 		/*
 		 * Since the stack will hold pointers to the strings, we
 		 * must account for them as well.
+		 *
+		 * The size calculation is the entire vma while each arg page is
+		 * built, so each time we get here it's calculating how far it
+		 * is currently (rather than each call being just the newly
+		 * added size from the arg page).  As a result, we need to
+		 * always add the entire size of the pointers, so that on the
+		 * last call to get_arg_page() we'll actually have the entire
+		 * correct size.
 		 */
 		ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
 		if (ptr_size > ULONG_MAX - size)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
exec-account-for-argv-envp-pointers.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

