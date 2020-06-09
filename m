From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 83/93] bpf: handle the compat string in
 bpf_trace_copy_string better
Date: Mon, 08 Jun 2020 21:34:33 -0700
Message-ID: <20200609043433.cOkjJVDq-%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgFIEeg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:36 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

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
