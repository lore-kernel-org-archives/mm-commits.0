From: akpm@linux-foundation.org
Subject: [obsolete]
 bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 11:31:29 -0700
Message-ID: <20200602183129.e0ZOOn4br%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgFBSba (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 14:31:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix
has been removed from the -mm tree.  Its filename was
     bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix

use strncpy_from_kernel_nofault(), per Christoph

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix
+++ a/kernel/trace/bpf_trace.c
@@ -597,13 +597,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
 			}
 
 			unsafe_ptr = (void *)(long)args[fmt_cnt];
-			if ((unsigned long)unsafe_ptr < TASK_SIZE) {
-				err = strncpy_from_user_nofault(
-					bufs->buf[memcpy_cnt], unsafe_ptr,
-					MAX_SEQ_PRINTF_STR_LEN);
-			} else {
-				err = -EFAULT;
-			}
+			err = strncpy_from_kernel_nofault(bufs->buf[memcpy_cnt],
+					unsafe_ptr, MAX_SEQ_PRINTF_STR_LEN);
 			if (err < 0)
 				bufs->buf[memcpy_cnt][0] = '\0';
 			params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
