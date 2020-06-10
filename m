From: akpm@linux-foundation.org
Subject: [merged]
 bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:40:19 -0700
Message-ID: <20200610004019.e2FNyDxjW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFJAkU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: bpf:bpf_seq_printf(): handle potentially unsafe format string better
has been removed from the -mm tree.  Its filename was
     bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bpf:bpf_seq_printf(): handle potentially unsafe format string better

User the proper helper for kernel or userspace addresses based on
TASK_SIZE instead of the dangerous strncpy_from_unsafe function.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better
+++ a/kernel/trace/bpf_trace.c
@@ -588,15 +588,17 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
 		}
 
 		if (fmt[i] == 's') {
+			void *unsafe_ptr;
+
 			/* try our best to copy */
 			if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
 				err = -E2BIG;
 				goto out;
 			}
 
-			err = strncpy_from_unsafe_strict(bufs->buf[memcpy_cnt],
-							 (void *) (long) args[fmt_cnt],
-							 MAX_SEQ_PRINTF_STR_LEN);
+			unsafe_ptr = (void *)(long)args[fmt_cnt];
+			err = strncpy_from_kernel_nofault(bufs->buf[memcpy_cnt],
+					unsafe_ptr, MAX_SEQ_PRINTF_STR_LEN);
 			if (err < 0)
 				bufs->buf[memcpy_cnt][0] = '\0';
 			params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-sparc-mm-srmmuc-fix-build.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
