From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch removed from
 -mm tree
Date: Fri, 04 Dec 2015 15:14:50 -0800
Message-ID: <56621e6a.oXP3gyvf0XZMfnVv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbbLDXOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch

This patch was dropped because it was folded into mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix

restore the casts

Cc: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix kernel/sysctl.c
--- a/kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix
+++ a/kernel/sysctl.c
@@ -1575,8 +1575,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(mmap_rnd_bits),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &mmap_rnd_bits_min,
-		.extra2		= &mmap_rnd_bits_max,
+		.extra1		= (void *)&mmap_rnd_bits_min,
+		.extra2		= (void *)&mmap_rnd_bits_max,
 	},
 #endif
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
@@ -1586,8 +1586,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(mmap_rnd_compat_bits),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &mmap_rnd_compat_bits_min,
-		.extra2		= &mmap_rnd_compat_bits_max,
+		.extra1		= (void *)&mmap_rnd_compat_bits_min,
+		.extra2		= (void *)&mmap_rnd_compat_bits_max,
 	},
 #endif
 	{ }
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
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
linux-next-git-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

