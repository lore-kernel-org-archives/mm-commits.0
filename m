From: akpm@linux-foundation.org
Subject: [merged]
 maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:40:04 -0700
Message-ID: <20200610004004.cBdECnbzH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAkG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: rename strncpy_from_unsafe_user to strncpy_from_user_nofault
has been removed from the -mm tree.  Its filename was
     maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: rename strncpy_from_unsafe_user to strncpy_from_user_nofault

This matches the naming of strncpy_from_user, and also makes it more
clear what the function is supposed to do.

Link: http://lkml.kernel.org/r/20200521152301.2587579-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h     |    4 ++--
 kernel/trace/bpf_trace.c    |    4 ++--
 kernel/trace/trace_kprobe.c |    2 +-
 mm/maccess.c                |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/uaccess.h~maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault
+++ a/include/linux/uaccess.h
@@ -313,8 +313,8 @@ extern long strncpy_from_unsafe(char *ds
 extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
 				       long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
-				     long count);
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
+		long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
 /**
--- a/kernel/trace/bpf_trace.c~maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault
+++ a/kernel/trace/bpf_trace.c
@@ -159,7 +159,7 @@ const struct bpf_func_proto bpf_probe_re
 BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
 	   const void __user *, unsafe_ptr)
 {
-	int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+	int ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
 
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
@@ -419,7 +419,7 @@ fmt_str:
 							   sizeof(buf));
 				break;
 			case 'u':
-				strncpy_from_unsafe_user(buf,
+				strncpy_from_user_nofault(buf,
 					(__force void __user *)unsafe_ptr,
 							 sizeof(buf));
 				break;
--- a/kernel/trace/trace_kprobe.c~maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault
+++ a/kernel/trace/trace_kprobe.c
@@ -1268,7 +1268,7 @@ fetch_store_string_user(unsigned long ad
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_unsafe_user(__dest, uaddr, maxlen);
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
--- a/mm/maccess.c~maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault
+++ a/mm/maccess.c
@@ -217,7 +217,7 @@ long __strncpy_from_unsafe(char *dst, co
 }
 
 /**
- * strncpy_from_unsafe_user: - Copy a NUL terminated string from unsafe user
+ * strncpy_from_user_nofault: - Copy a NUL terminated string from unsafe user
  *				address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -234,7 +234,7 @@ long __strncpy_from_unsafe(char *dst, co
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 			      long count)
 {
 	mm_segment_t old_fs = get_fs();
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
