From: akpm@linux-foundation.org
Subject: +
 ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch added to -mm tree
Date: Tue, 08 Dec 2015 15:30:31 -0800
Message-ID: <56676817.N99yJC1jte6dgtTm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbbLHXad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:30:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jann@thejh.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix
has been added to the -mm tree.  Its filename is
     ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch

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
Subject: ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix

fix warning

kernel/ptrace.c: In function '__ptrace_may_access':
kernel/ptrace.c:238: warning: ISO C90 forbids mixed declarations and code

Cc: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix
+++ a/kernel/ptrace.c
@@ -219,6 +219,7 @@ static int ptrace_has_cap(struct user_na
 static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	const struct cred *cred = current_cred(), *tcred;
+	int dumpable = 0;
 	kuid_t caller_uid;
 	kgid_t caller_gid;
 
@@ -235,7 +236,7 @@ static int __ptrace_may_access(struct ta
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
 	 */
-	int dumpable = 0;
+
 	/* Don't let security modules deny introspection */
 	if (same_thread_group(task, current))
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
linux-next-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

