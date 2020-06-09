From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 78/93] maccess: rename strncpy_from_unsafe_strict
 to strncpy_from_kernel_nofault
Date: Mon, 08 Jun 2020 21:34:17 -0700
Message-ID: <20200609043417.N5VkB8ywh%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgFIEeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:20 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: maccess: rename strncpy_from_unsafe_strict to strncpy_from_kernel_nofault

This matches the naming of strncpy_from_user_nofault, and also makes it
more clear what the function is supposed to do.

Link: http://lkml.kernel.org/r/20200521152301.2587579-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/maccess.c    |    2 +-
 include/linux/uaccess.h  |    4 ++--
 kernel/trace/bpf_trace.c |    4 ++--
 mm/maccess.c             |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/maccess.c~maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault
+++ a/arch/x86/mm/maccess.c
@@ -34,7 +34,7 @@ long probe_kernel_read_strict(void *dst,
 	return __probe_kernel_read(dst, src, size);
 }
 
-long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
 	if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
 		return -EFAULT;
--- a/include/linux/uaccess.h~maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault
+++ a/include/linux/uaccess.h
@@ -310,8 +310,8 @@ extern long notrace probe_kernel_write(v
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
-				       long count);
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
+		long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 		long count);
--- a/kernel/trace/bpf_trace.c~maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault
+++ a/kernel/trace/bpf_trace.c
@@ -240,7 +240,7 @@ bpf_probe_read_kernel_str_common(void *d
 	 * is returned that can be used for bpf_perf_event_output() et al.
 	 */
 	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-	      strncpy_from_unsafe_strict(dst, unsafe_ptr, size);
+	      strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 out:
 		memset(dst, 0, size);
@@ -415,7 +415,7 @@ fmt_str:
 				break;
 #endif
 			case 'k':
-				strncpy_from_unsafe_strict(buf, unsafe_ptr,
+				strncpy_from_kernel_nofault(buf, unsafe_ptr,
 							   sizeof(buf));
 				break;
 			case 'u':
--- a/mm/maccess.c~maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault
+++ a/mm/maccess.c
@@ -161,7 +161,7 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * Same as strncpy_from_unsafe_strict() except that for architectures with
+ * Same as strncpy_from_kernel_nofault() except that for architectures with
  * not fully separated user and kernel address spaces this function also works
  * for user address tanges.
  *
@@ -172,7 +172,7 @@ long __weak strncpy_from_unsafe(char *ds
     __attribute__((alias("__strncpy_from_unsafe")));
 
 /**
- * strncpy_from_unsafe_strict: - Copy a NUL terminated string from unsafe
+ * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
  *				 address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -189,7 +189,7 @@ long __weak strncpy_from_unsafe(char *ds
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+long __weak strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 				       long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
_
