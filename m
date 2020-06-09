From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 85/93] bpf: rework the compat kernel probe
 handling
Date: Mon, 08 Jun 2020 21:34:40 -0700
Message-ID: <20200609043440.wRw9CfaOr%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgFIEem (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:42 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: bpf: rework the compat kernel probe handling

Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
helpers, rework the compat probes to check if an address is a kernel or
userspace one, and then use the low-level kernel or user probe helper
shared by the proper kernel and user probe helpers.  This slightly
changes behavior as the compat probe on a user address doesn't check
the lockdown flags, just as the pure user probes do.

Link: http://lkml.kernel.org/r/20200521152301.2587579-14-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |  109 ++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 42 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-rework-the-compat-kernel-probe-handling
+++ a/kernel/trace/bpf_trace.c
@@ -136,17 +136,23 @@ static const struct bpf_func_proto bpf_o
 };
 #endif
 
-BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
-	   const void __user *, unsafe_ptr)
+static __always_inline int
+bpf_probe_read_user_common(void *dst, u32 size, const void __user *unsafe_ptr)
 {
-	int ret = probe_user_read(dst, unsafe_ptr, size);
+	int ret;
 
+	ret = probe_user_read(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
-
 	return ret;
 }
 
+BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
+	   const void __user *, unsafe_ptr)
+{
+	return bpf_probe_read_user_common(dst, size, unsafe_ptr);
+}
+
 const struct bpf_func_proto bpf_probe_read_user_proto = {
 	.func		= bpf_probe_read_user,
 	.gpl_only	= true,
@@ -156,17 +162,24 @@ const struct bpf_func_proto bpf_probe_re
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
-	   const void __user *, unsafe_ptr)
+static __always_inline int
+bpf_probe_read_user_str_common(void *dst, u32 size,
+			       const void __user *unsafe_ptr)
 {
-	int ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
+	int ret;
 
+	ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
-
 	return ret;
 }
 
+BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
+	   const void __user *, unsafe_ptr)
+{
+	return bpf_probe_read_user_str_common(dst, size, unsafe_ptr);
+}
+
 const struct bpf_func_proto bpf_probe_read_user_str_proto = {
 	.func		= bpf_probe_read_user_str,
 	.gpl_only	= true,
@@ -177,25 +190,25 @@ const struct bpf_func_proto bpf_probe_re
 };
 
 static __always_inline int
-bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr,
-			     const bool compat)
+bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
 {
 	int ret = security_locked_down(LOCKDOWN_BPF_READ);
 
 	if (unlikely(ret < 0))
-		goto out;
-	ret = compat ? probe_kernel_read(dst, unsafe_ptr, size) :
-	      probe_kernel_read_strict(dst, unsafe_ptr, size);
+		goto fail;
+	ret = probe_kernel_read_strict(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
-out:
-		memset(dst, 0, size);
+		goto fail;
+	return ret;
+fail:
+	memset(dst, 0, size);
 	return ret;
 }
 
 BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
 	   const void *, unsafe_ptr)
 {
-	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
+	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr);
 }
 
 const struct bpf_func_proto bpf_probe_read_kernel_proto = {
@@ -207,50 +220,37 @@ const struct bpf_func_proto bpf_probe_re
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
-	   const void *, unsafe_ptr)
-{
-	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
-}
-
-static const struct bpf_func_proto bpf_probe_read_compat_proto = {
-	.func		= bpf_probe_read_compat,
-	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
-	.arg3_type	= ARG_ANYTHING,
-};
-
 static __always_inline int
-bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
-				 const bool compat)
+bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
 {
 	int ret = security_locked_down(LOCKDOWN_BPF_READ);
 
 	if (unlikely(ret < 0))
-		goto out;
+		goto fail;
+
 	/*
-	 * The strncpy_from_unsafe_*() call will likely not fill the entire
-	 * buffer, but that's okay in this circumstance as we're probing
+	 * The strncpy_from_kernel_nofault() call will likely not fill the
+	 * entire buffer, but that's okay in this circumstance as we're probing
 	 * arbitrary memory anyway similar to bpf_probe_read_*() and might
 	 * as well probe the stack. Thus, memory is explicitly cleared
 	 * only in error case, so that improper users ignoring return
 	 * code altogether don't copy garbage; otherwise length of string
 	 * is returned that can be used for bpf_perf_event_output() et al.
 	 */
-	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-	      strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
+	ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
-out:
-		memset(dst, 0, size);
+		goto fail;
+
+	return 0;
+fail:
+	memset(dst, 0, size);
 	return ret;
 }
 
 BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
 	   const void *, unsafe_ptr)
 {
-	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
+	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr);
 }
 
 const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
@@ -262,10 +262,34 @@ const struct bpf_func_proto bpf_probe_re
 	.arg3_type	= ARG_ANYTHING,
 };
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
+	   const void *, unsafe_ptr)
+{
+	if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+		return bpf_probe_read_user_common(dst, size,
+				(__force void __user *)unsafe_ptr);
+	}
+	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr);
+}
+
+static const struct bpf_func_proto bpf_probe_read_compat_proto = {
+	.func		= bpf_probe_read_compat,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
 	   const void *, unsafe_ptr)
 {
-	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
+	if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+		return bpf_probe_read_user_str_common(dst, size,
+				(__force void __user *)unsafe_ptr);
+	}
+	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr);
 }
 
 static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
@@ -276,6 +300,7 @@ static const struct bpf_func_proto bpf_p
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
 };
+#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
 BPF_CALL_3(bpf_probe_write_user, void __user *, unsafe_ptr, const void *, src,
 	   u32, size)
_
