From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 097/127] exec: open code copy_string_kernel
Date: Thu, 04 Jun 2020 16:51:18 -0700
Message-ID: <20200604235118.7QWRd3RgW%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgFDXvT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:51:19 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Christoph Hellwig <hch@lst.de>
Subject: exec: open code copy_string_kernel

Currently copy_string_kernel is just a wrapper around copy_strings that
simplifies the calling conventions and uses set_fs to allow passing a
kernel pointer.  But due to the fact the we only need to handle a single
kernel argument pointer, the logic can be sigificantly simplified while
getting rid of the set_fs.

Link: http://lkml.kernel.org/r/20200501104105.2621149-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

--- a/fs/exec.c~exec-open-code-copy_string_kernel
+++ a/fs/exec.c
@@ -592,17 +592,42 @@ out:
  */
 int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 {
-	int r;
-	mm_segment_t oldfs = get_fs();
-	struct user_arg_ptr argv = {
-		.ptr.native = (const char __user *const  __user *)&arg,
-	};
-
-	set_fs(KERNEL_DS);
-	r = copy_strings(1, argv, bprm);
-	set_fs(oldfs);
+	int len = strnlen(arg, MAX_ARG_STRLEN) + 1 /* terminating NUL */;
+	unsigned long pos = bprm->p;
 
-	return r;
+	if (len == 0)
+		return -EFAULT;
+	if (!valid_arg_len(bprm, len))
+		return -E2BIG;
+
+	/* We're going to work our way backwards. */
+	arg += len;
+	bprm->p -= len;
+	if (IS_ENABLED(CONFIG_MMU) && bprm->p < bprm->argmin)
+		return -E2BIG;
+
+	while (len > 0) {
+		unsigned int bytes_to_copy = min_t(unsigned int, len,
+				min_not_zero(offset_in_page(pos), PAGE_SIZE));
+		struct page *page;
+		char *kaddr;
+
+		pos -= bytes_to_copy;
+		arg -= bytes_to_copy;
+		len -= bytes_to_copy;
+
+		page = get_arg_page(bprm, pos, 1);
+		if (!page)
+			return -E2BIG;
+		kaddr = kmap_atomic(page);
+		flush_arg_page(bprm, pos & PAGE_MASK, page);
+		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
+		flush_kernel_dcache_page(page);
+		kunmap_atomic(kaddr);
+		put_arg_page(page);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(copy_string_kernel);
 
_
