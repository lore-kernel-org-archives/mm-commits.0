From: akpm@linux-foundation.org
Subject: - cache-pipe-buf-page-address-for-non-highmem-arch.patch removed from -mm tree
Date: Mon, 26 Mar 2007 20:15:59 -0800
Message-ID: <200703270416.l2R4G06R006504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37556 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966AbXC0EQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 00:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     cache pipe buf page address for non-highmem arch
has been removed from the -mm tree.  Its filename was
     cache-pipe-buf-page-address-for-non-highmem-arch.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: cache pipe buf page address for non-highmem arch
From: "Ken Chen" <kenchen@google.com>

It is really sad that we always call kmap and friends for every pipe buffer
page on 64-bit arch that doesn't use HIGHMEM, or on configuration that
doesn't turn on HIGHMEM.

The effect of calling kmap* is visible in the execution profile when pipe
code is being stressed.  It is especially true on amd's x86-64 platform
where kmap() has to traverse through numa node index calculation in order
to convert struct page * to kernel virtual address.  It is fairly pointless
to perform that calculation repeatly on system with no highmem (i.e.,
64-bit arch like x86-64).  This patch caches kernel pipe buffer page's
kernel vaddr to speed up pipe buffer mapping functions.

There is another suboptimal block in pipe_read() where wake_up is called
twice.  I think it was an oversight since in pipe_write(), it looks like it
is doing the right thing.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff -puN fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch fs/pipe.c
--- a/fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch
+++ a/fs/pipe.c
@@ -21,6 +21,21 @@
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 
+#ifdef CONFIG_HIGHMEM
+#define pipe_kmap		kmap
+#define pipe_kmap_atomic	kmap_atomic
+#define pipe_kunmap		kunmap
+#define pipe_kunmap_atomic	kunmap_atomic
+#else	/* CONFIG_HIGHMEM */
+static inline void *pipe_kmap(struct page *page)
+{
+	return (void *) page->private;
+}
+#define pipe_kmap_atomic(page, type)	pipe_kmap(page)
+#define pipe_kunmap(page)		do { } while (0)
+#define pipe_kunmap_atomic(page, type)	do { } while (0)
+#endif
+
 /*
  * We use a start+len construction, which provides full use of the 
  * allocated memory.
@@ -169,10 +184,10 @@ void *generic_pipe_buf_map(struct pipe_i
 {
 	if (atomic) {
 		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
-		return kmap_atomic(buf->page, KM_USER0);
+		return pipe_kmap_atomic(buf->page, KM_USER0);
 	}
 
-	return kmap(buf->page);
+	return pipe_kmap(buf->page);
 }
 
 void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
@@ -180,9 +195,9 @@ void generic_pipe_buf_unmap(struct pipe_
 {
 	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
 		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
-		kunmap_atomic(map_data, KM_USER0);
+		pipe_kunmap_atomic(map_data, KM_USER0);
 	} else
-		kunmap(buf->page);
+		pipe_kunmap(buf->page);
 }
 
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
@@ -316,6 +331,7 @@ redo:
 		if (do_wakeup) {
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
@@ -423,6 +439,8 @@ redo1:
 					ret = ret ? : -ENOMEM;
 					break;
 				}
+				page->private = (unsigned long)
+							page_address(page);
 				pipe->tmp_page = page;
 			}
 			/* Always wake up, even if the copy fails. Otherwise
@@ -438,16 +456,16 @@ redo1:
 			iov_fault_in_pages_read(iov, chars);
 redo2:
 			if (atomic)
-				src = kmap_atomic(page, KM_USER0);
+				src = pipe_kmap_atomic(page, KM_USER0);
 			else
-				src = kmap(page);
+				src = pipe_kmap(page);
 
 			error = pipe_iov_copy_from_user(src, iov, chars,
 							atomic);
 			if (atomic)
-				kunmap_atomic(src, KM_USER0);
+				pipe_kunmap_atomic(src, KM_USER0);
 			else
-				kunmap(page);
+				pipe_kunmap(page);
 
 			if (unlikely(error)) {
 				if (atomic) {
_

Patches currently in -mm which might be from kenchen@google.com are

type-cast-clean-up-for-find_next_zero_bit.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
