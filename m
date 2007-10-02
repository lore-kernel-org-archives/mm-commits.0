From: akpm@linux-foundation.org
Subject: - cache-pipe-buf-page-address-for-non-highmem-arch.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:29:31 -0700
Message-ID: <200710022229.l92MTVtq025808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbXJBWav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cache pipe buf page address for non-highmem arch
has been removed from the -mm tree.  Its filename was
     cache-pipe-buf-page-address-for-non-highmem-arch.patch

This patch was dropped because it was unpopular

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

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 6 deletions(-)

diff -puN fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch fs/pipe.c
--- a/fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch
+++ a/fs/pipe.c
@@ -21,6 +21,40 @@
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 
+#ifdef CONFIG_HIGHMEM
+static inline void *pipe_kmap(struct page *page)
+{
+	return kmap(page);
+}
+
+static inline void pipe_kunmap(struct page *page)
+{
+	kunmap(page);
+}
+
+static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic(page, type);
+}
+
+static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
+{
+	kunmap_atomic(addr, type);
+}
+#else	/* CONFIG_HIGHMEM */
+static inline void *pipe_kmap(struct page *page)
+{
+	return (void *)page->private;
+}
+
+static inline void pipe_kunmap(struct page *page)
+{
+}
+
+#define pipe_kmap_atomic(page, type)	pipe_kmap(page)
+#define pipe_kunmap_atomic(page, type)	do { } while (0)
+#endif
+
 /*
  * We use a start+len construction, which provides full use of the 
  * allocated memory.
@@ -207,6 +241,27 @@ void generic_pipe_buf_unmap(struct pipe_
 		kunmap(buf->page);
 }
 
+static void *pipe_buf_map(struct pipe_inode_info *pipe,
+			   struct pipe_buffer *buf, int atomic)
+{
+	if (atomic) {
+		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
+		return pipe_kmap_atomic(buf->page, KM_USER0);
+	}
+
+	return pipe_kmap(buf->page);
+}
+
+static void pipe_buf_unmap(struct pipe_inode_info *pipe,
+			    struct pipe_buffer *buf, void *map_data)
+{
+	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
+		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
+		pipe_kunmap_atomic(map_data, KM_USER0);
+	} else
+		pipe_kunmap(buf->page);
+}
+
 /**
  * generic_pipe_buf_steal - attempt to take ownership of a @pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
@@ -269,8 +324,8 @@ int generic_pipe_buf_confirm(struct pipe
 
 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
+	.map = pipe_buf_map,
+	.unmap = pipe_buf_unmap,
 	.confirm = generic_pipe_buf_confirm,
 	.release = anon_pipe_buf_release,
 	.steal = generic_pipe_buf_steal,
@@ -375,6 +430,7 @@ redo:
 		if (do_wakeup) {
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
@@ -482,6 +538,8 @@ redo1:
 					ret = ret ? : -ENOMEM;
 					break;
 				}
+				page->private = (unsigned long)
+							page_address(page);
 				pipe->tmp_page = page;
 			}
 			/* Always wake up, even if the copy fails. Otherwise
@@ -497,16 +555,16 @@ redo1:
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

hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch
