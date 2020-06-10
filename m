From: akpm@linux-foundation.org
Subject: [merged]
 maccess-remove-duplicate-kerneldoc-comments.patch removed from -mm tree
Date: Tue, 09 Jun 2020 17:39:56 -0700
Message-ID: <20200610003956.TuKSHRsEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: remove duplicate kerneldoc comments
has been removed from the -mm tree.  Its filename was
     maccess-remove-duplicate-kerneldoc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: remove duplicate kerneldoc comments

Many of the maccess routines have a copy of the kerneldoc comment
in the header.  Remove it as it is not useful and will get out of
sync sooner or later.

Link: http://lkml.kernel.org/r/20200521152301.2587579-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |   38 --------------------------------------
 1 file changed, 38 deletions(-)

--- a/include/linux/uaccess.h~maccess-remove-duplicate-kerneldoc-comments
+++ a/include/linux/uaccess.h
@@ -301,50 +301,12 @@ copy_struct_from_user(void *dst, size_t
 	return 0;
 }
 
-/*
- * probe_kernel_read(): safely attempt to read from a location
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long __probe_kernel_read(void *dst, const void *src, size_t size);
-
-/*
- * probe_user_read(): safely attempt to read from a location in user space
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
-/*
- * probe_kernel_write(): safely attempt to write to a location
- * @dst: address to write to
- * @src: pointer to the data that shall be written
- * @size: size of the data chunk
- *
- * Safely write to address @dst from the buffer at @src.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
