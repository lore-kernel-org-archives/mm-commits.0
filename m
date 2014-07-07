From: akpm@linux-foundation.org
Subject: [merged] fs-seq_file-fallback-to-vmalloc-allocation.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:32 -0700
Message-ID: <53bae2d4.DwKaq08jCpUUj3/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56375 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGGSLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:33 -0400
Received: by mail-vc0-f201.google.com with SMTP id ij19so657215vcb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, andrea@betterlinux.com, brueckner@linux.vnet.ibm.com, hch@infradead.org, raven@themaw.net, rientjes@google.com, stable@vger.kernel.org, stefan.bader@canonical.com, thorsten.diehl@de.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file: fallback to vmalloc allocation
has been removed from the -mm tree.  Its filename was
     fs-seq_file-fallback-to-vmalloc-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: fs/seq_file: fallback to vmalloc allocation

There are a couple of seq_files which use the single_open() interface. 
This interface requires that the whole output must fit into a single
buffer.

E.g.  for /proc/stat allocation failures have been observed because an
order-4 memory allocation failed due to memory fragmentation.  In such
situations reading /proc/stat is not possible anymore.

Therefore change the seq_file code to fallback to vmalloc allocations
which will usually result in a couple of order-0 allocations and hence
also work if memory is fragmented.

For reference a call trace where reading from /proc/stat failed:

[62129.701569] sadc: page allocation failure: order:4, mode:0x1040d0
[62129.701573] CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
[...]
[62129.701586] Call Trace:
[62129.701588] ([<0000000000111fbe>] show_trace+0xe6/0x130)
[62129.701591] [<0000000000112074>] show_stack+0x6c/0xe8
[62129.701593] [<000000000020d356>] warn_alloc_failed+0xd6/0x138
[62129.701596] [<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
[62129.701598] [<000000000021168e>] __get_free_pages+0x2e/0x58
[62129.701599] [<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
[62129.701602] [<00000000002f3ffa>] stat_open+0x5a/0xd8
[62129.701604] [<00000000002e9aaa>] proc_reg_open+0x8a/0x140
[62129.701606] [<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
[62129.701608] [<000000000027411e>] finish_open+0x46/0x60
[62129.701610] [<000000000028675a>] do_last+0x382/0x10d0
[62129.701612] [<0000000000287570>] path_openat+0xc8/0x4f8
[62129.701614] [<0000000000288bde>] do_filp_open+0x46/0xa8
[62129.701616] [<000000000027541c>] do_sys_open+0x114/0x1f0
[62129.701618] [<00000000005b1c1c>] sysc_tracego+0x14/0x1a

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Thorsten Diehl <thorsten.diehl@de.ibm.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-allocation fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-allocation
+++ a/fs/seq_file.c
@@ -8,8 +8,10 @@
 #include <linux/fs.h>
 #include <linux/export.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -30,6 +32,16 @@ static void seq_set_overflow(struct seq_
 	m->count = m->size;
 }
 
+static void *seq_buf_alloc(unsigned long size)
+{
+	void *buf;
+
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf && size > PAGE_SIZE)
+		buf = vmalloc(size);
+	return buf;
+}
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -96,7 +108,7 @@ static int traverse(struct seq_file *m,
 		return 0;
 	}
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			return -ENOMEM;
 	}
@@ -135,9 +147,9 @@ static int traverse(struct seq_file *m,
 
 Eoverflow:
 	m->op->stop(m, p);
-	kfree(m->buf);
+	kvfree(m->buf);
 	m->count = 0;
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	m->buf = seq_buf_alloc(m->size <<= 1);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
 
@@ -192,7 +204,7 @@ ssize_t seq_read(struct file *file, char
 
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			goto Enomem;
 	}
@@ -232,9 +244,9 @@ ssize_t seq_read(struct file *file, char
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kfree(m->buf);
+		kvfree(m->buf);
 		m->count = 0;
-		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size <<= 1);
 		if (!m->buf)
 			goto Enomem;
 		m->version = 0;
@@ -350,7 +362,7 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	kfree(m->buf);
+	kvfree(m->buf);
 	kfree(m);
 	return 0;
 }
@@ -605,13 +617,13 @@ EXPORT_SYMBOL(single_open);
 int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
 		void *data, size_t size)
 {
-	char *buf = kmalloc(size, GFP_KERNEL);
+	char *buf = seq_buf_alloc(size);
 	int ret;
 	if (!buf)
 		return -ENOMEM;
 	ret = single_open(file, show, data);
 	if (ret) {
-		kfree(buf);
+		kvfree(buf);
 		return ret;
 	}
 	((struct seq_file *)file->private_data)->buf = buf;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
linux-next.patch

