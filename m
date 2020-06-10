From: akpm@linux-foundation.org
Subject: [merged]
 bpf-handle-the-compat-string-in-bpf_trace_copy_string-better.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:40:16 -0700
Message-ID: <20200610004016.RmyW-m2Fm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFJAkR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: bpf: handle the compat string in bpf_trace_copy_string better
has been removed from the -mm tree.  Its filename was
     bpf-handle-the-compat-string-in-bpf_trace_copy_string-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: bpf: handle the compat string in bpf_trace_copy_string better

User the proper helper for kernel or userspace addresses based on
TASK_SIZE instead of the dangerous strncpy_from_unsafe function.

Link: http://lkml.kernel.org/r/20200521152301.2587579-13-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-handle-the-compat-string-in-bpf_trace_copy_string-better
+++ a/kernel/trace/bpf_trace.c
@@ -334,8 +334,11 @@ static void bpf_trace_copy_string(char *
 	switch (fmt_ptype) {
 	case 's':
 #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
-		break;
+		if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+			strncpy_from_user_nofault(buf, user_ptr, bufsz);
+			break;
+		}
+		fallthrough;
 #endif
 	case 'k':
 		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
