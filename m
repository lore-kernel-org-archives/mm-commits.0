From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 49/54] exec: only build read_code when needed
Date: Sun, 07 Jun 2020 21:42:40 -0700
Message-ID: <20200608044240.ldWDPSJ67%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEml (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:41 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Christoph Hellwig <hch@lst.de>
Subject: exec: only build read_code when needed

Only build read_code when binary formats that use it are built into the
kernel.

Link: http://lkml.kernel.org/r/20200515143646.3857579-26-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/exec.c~exec-only-build-read_code-when-needed
+++ a/fs/exec.c
@@ -1053,6 +1053,8 @@ out:
 }
 EXPORT_SYMBOL_GPL(kernel_read_file_from_fd);
 
+#if defined(CONFIG_HAVE_AOUT) || defined(CONFIG_BINFMT_FLAT) || \
+    defined(CONFIG_BINFMT_ELF_FDPIC)
 ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
 {
 	ssize_t res = vfs_read(file, (void __user *)addr, len, &pos);
@@ -1061,6 +1063,7 @@ ssize_t read_code(struct file *file, uns
 	return res;
 }
 EXPORT_SYMBOL(read_code);
+#endif
 
 /*
  * Maps the mm_struct mm into the current task struct.
_
