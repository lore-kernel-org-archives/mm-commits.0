From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 86/93] tracing/kprobes: handle mixed
 kernel/userspace probes better
Date: Mon, 08 Jun 2020 21:34:44 -0700
Message-ID: <20200609043444.8qanU5wfk%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEeq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:46 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, svens@linux.ibm.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: tracing/kprobes: handle mixed kernel/userspace probes better

Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
helpers, rework probes to try a user probe based on the address if the
architecture has a common address space for kernel and userspace.

[svens@linux.ibm.com:use strncpy_from_kernel_nofault() in fetch_store_string()]
  Link: http://lkml.kernel.org/r/20200606181903.49384-1-svens@linux.ibm.com
Link: http://lkml.kernel.org/r/20200521152301.2587579-15-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_kprobe.c |   72 ++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 29 deletions(-)

--- a/kernel/trace/trace_kprobe.c~tracing-kprobes-handle-mixed-kernel-userspace-probes-better
+++ a/kernel/trace/trace_kprobe.c
@@ -1202,35 +1202,41 @@ static const struct file_operations kpro
 
 /* Return the length of string -- including null terminal byte */
 static nokprobe_inline int
+fetch_store_strlen_user(unsigned long addr)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+}
+
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
 fetch_store_strlen(unsigned long addr)
 {
 	int ret, len = 0;
 	u8 c;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if (addr < TASK_SIZE)
+		return fetch_store_strlen_user(addr);
+#endif
+
 	do {
-		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
+		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
 	return (ret < 0) ? ret : len;
 }
 
-/* Return the length of string -- including null terminal byte */
-static nokprobe_inline int
-fetch_store_strlen_user(unsigned long addr)
-{
-	const void __user *uaddr =  (__force const void __user *)addr;
-
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
-}
-
 /*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
- * length and relative data location.
+ * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
+ * with max length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string(unsigned long addr, void *dest, void *base)
+fetch_store_string_user(unsigned long addr, void *dest, void *base)
 {
+	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
@@ -1240,11 +1246,7 @@ fetch_store_string(unsigned long addr, v
 
 	__dest = get_loc_data(dest, base);
 
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
@@ -1252,23 +1254,31 @@ fetch_store_string(unsigned long addr, v
 }
 
 /*
- * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
- * with max length and relative data location.
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
+ * length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string_user(unsigned long addr, void *dest, void *base)
+fetch_store_string(unsigned long addr, void *dest, void *base)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)addr < TASK_SIZE)
+		return fetch_store_string_user(addr, dest, base);
+#endif
+
 	if (unlikely(!maxlen))
 		return -ENOMEM;
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
@@ -1276,12 +1286,6 @@ fetch_store_string_user(unsigned long ad
 }
 
 static nokprobe_inline int
-probe_mem_read(void *dest, void *src, size_t size)
-{
-	return probe_kernel_read(dest, src, size);
-}
