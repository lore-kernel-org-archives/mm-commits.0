From: akpm@linux-foundation.org
Subject: [merged]
 maccess-allow-architectures-to-provide-kernel-probing-directly.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:40:34 -0700
Message-ID: <20200610004034.HpDjzCfwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFJAkf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: allow architectures to provide kernel probing directly
has been removed from the -mm tree.  Its filename was
     maccess-allow-architectures-to-provide-kernel-probing-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: allow architectures to provide kernel probing directly

Provide alternative versions of probe_kernel_read, probe_kernel_write
and strncpy_from_kernel_unsafe that don't need set_fs magic, but instead
use arch hooks that are modelled after unsafe_{get,put}_user to access
kernel memory in an exception safe way.

Link: http://lkml.kernel.org/r/20200521152301.2587579-19-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

--- a/mm/maccess.c~maccess-allow-architectures-to-provide-kernel-probing-directly
+++ a/mm/maccess.c
@@ -11,6 +11,81 @@ bool __weak probe_kernel_read_allowed(co
 	return true;
 }
 
+#ifdef HAVE_GET_KERNEL_NOFAULT
+
+#define probe_kernel_read_loop(dst, src, len, type, err_label)		\
+	while (len >= sizeof(type)) {					\
+		__get_kernel_nofault(dst, src, type, err_label);		\
+		dst += sizeof(type);					\
+		src += sizeof(type);					\
+		len -= sizeof(type);					\
+	}
+
+long probe_kernel_read(void *dst, const void *src, size_t size)
+{
+	if (!probe_kernel_read_allowed(src, size))
+		return -EFAULT;
+
+	pagefault_disable();
+	probe_kernel_read_loop(dst, src, size, u64, Efault);
+	probe_kernel_read_loop(dst, src, size, u32, Efault);
+	probe_kernel_read_loop(dst, src, size, u16, Efault);
+	probe_kernel_read_loop(dst, src, size, u8, Efault);
+	pagefault_enable();
+	return 0;
+Efault:
+	pagefault_enable();
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
+
+#define probe_kernel_write_loop(dst, src, len, type, err_label)		\
+	while (len >= sizeof(type)) {					\
+		__put_kernel_nofault(dst, src, type, err_label);		\
+		dst += sizeof(type);					\
+		src += sizeof(type);					\
+		len -= sizeof(type);					\
+	}
+
+long probe_kernel_write(void *dst, const void *src, size_t size)
+{
+	pagefault_disable();
+	probe_kernel_write_loop(dst, src, size, u64, Efault);
+	probe_kernel_write_loop(dst, src, size, u32, Efault);
+	probe_kernel_write_loop(dst, src, size, u16, Efault);
+	probe_kernel_write_loop(dst, src, size, u8, Efault);
+	pagefault_enable();
+	return 0;
+Efault:
+	pagefault_enable();
+	return -EFAULT;
+}
+
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
+{
+	const void *src = unsafe_addr;
+
+	if (unlikely(count <= 0))
+		return 0;
+	if (!probe_kernel_read_allowed(unsafe_addr, count))
+		return -EFAULT;
+
+	pagefault_disable();
+	do {
+		__get_kernel_nofault(dst, src, u8, Efault);
+		dst++;
+		src++;
+	} while (dst[-1] && src - unsafe_addr < count);
+	pagefault_enable();
+
+	dst[-1] = '\0';
+	return src - unsafe_addr;
+Efault:
+	pagefault_enable();
+	dst[-1] = '\0';
+	return -EFAULT;
+}
+#else /* HAVE_GET_KERNEL_NOFAULT */
 /**
  * probe_kernel_read(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
@@ -113,6 +188,7 @@ long strncpy_from_kernel_nofault(char *d
 
 	return ret ? -EFAULT : src - unsafe_addr;
 }
+#endif /* HAVE_GET_KERNEL_NOFAULT */
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
