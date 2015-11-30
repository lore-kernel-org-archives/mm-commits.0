From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix.patch removed from -mm
 tree
Date: Mon, 30 Nov 2015 15:54:34 -0800
Message-ID: <565ce1ba.4wR61SRRZfOf14rG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbbK3Xyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 18:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dcashman@google.com, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix

switch the /proc/sys/kernel/ tunables to 0600

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Cashman <dcashman@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Salyzyn <salyzyn@android.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix kernel/sysctl.c
--- a/kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-fix
+++ a/kernel/sysctl.c
@@ -1573,7 +1573,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "mmap_rnd_bits",
 		.data		= &mmap_rnd_bits,
 		.maxlen		= sizeof(mmap_rnd_bits),
-		.mode		= 0644,
+		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &mmap_rnd_bits_min,
 		.extra2		= &mmap_rnd_bits_max,
@@ -1584,7 +1584,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "mmap_rnd_compat_bits",
 		.data		= &mmap_rnd_compat_bits,
 		.maxlen		= sizeof(mmap_rnd_compat_bits),
-		.mode		= 0644,
+		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &mmap_rnd_compat_bits_min,
 		.extra2		= &mmap_rnd_compat_bits_max,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
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
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

