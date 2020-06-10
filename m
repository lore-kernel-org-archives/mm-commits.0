From: akpm@linux-foundation.org
Subject: [merged]
 maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:40:08 -0700
Message-ID: <20200610004008.PZV_zhzGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: rename strnlen_unsafe_user to strnlen_user_nofault
has been removed from the -mm tree.  Its filename was
     maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: rename strnlen_unsafe_user to strnlen_user_nofault

This matches the naming of strnlen_user, and also makes it more clear
what the function is supposed to do.

Link: http://lkml.kernel.org/r/20200521152301.2587579-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h     |    2 +-
 kernel/trace/trace_kprobe.c |    2 +-
 mm/maccess.c                |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/uaccess.h~maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault
+++ a/include/linux/uaccess.h
@@ -315,7 +315,7 @@ long strncpy_from_kernel_nofault(char *d
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 		long count);
-extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
+long strnlen_user_nofault(const void __user *unsafe_addr, long count);
 
 /**
  * probe_kernel_address(): safely attempt to read from a location
--- a/kernel/trace/trace_kprobe.c~maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault
+++ a/kernel/trace/trace_kprobe.c
@@ -1221,7 +1221,7 @@ fetch_store_strlen_user(unsigned long ad
 {
 	const void __user *uaddr =  (__force const void __user *)addr;
 
-	return strnlen_unsafe_user(uaddr, MAX_STRING_SIZE);
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
 }
 
 /*
--- a/mm/maccess.c~maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault
+++ a/mm/maccess.c
@@ -260,7 +260,7 @@ long strncpy_from_user_nofault(char *dst
 }
 
 /**
- * strnlen_unsafe_user: - Get the size of a user string INCLUDING final NUL.
+ * strnlen_user_nofault: - Get the size of a user string INCLUDING final NUL.
  * @unsafe_addr: The string to measure.
  * @count: Maximum count (including NUL)
  *
@@ -275,7 +275,7 @@ long strncpy_from_user_nofault(char *dst
  * Unlike strnlen_user, this can be used from IRQ handler etc. because
  * it disables pagefaults.
  */
-long strnlen_unsafe_user(const void __user *unsafe_addr, long count)
+long strnlen_user_nofault(const void __user *unsafe_addr, long count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
