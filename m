Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4045C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIKXaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIKXaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EA6F587
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28B761012
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554E8C433B5;
        Sun, 11 Sep 2022 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939016;
        bh=/QW5Zcao6N4sf5mnmEDic2jqEspiLfn23dHPIyxFgy4=;
        h=Date:To:From:Subject:From;
        b=MoMki86Vb0L3vY7z1wvCXEYDpUqnYRAFCuHltcINNpdN2wxwBo5grgR6rdLLDtD+1
         AULtxasy+yzqXFCoEZedZrH3wbXVSL+evy2VKAelI1BIUhwwOi4CgPBUeewi2aQcdx
         viteTSHAGceWVYKlNhWc60M7tkdz5AF3itpKxbXo=
Date:   Sun, 11 Sep 2022 16:30:15 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tjmercier@google.com, surenb@google.com, sumit.semwal@linaro.org,
        stephen.s.brennan@oracle.com, rdunlap@infradead.org,
        paul.gortmaker@windriver.com, mail@christoph.anton.mitterer.name,
        ilkos@google.com, hch@infradead.org, hannes@cmpxchg.org,
        David.Laight@ACULAB.COM, corbet@lwn.net, christian.koenig@amd.com,
        ccross@google.com, adobriyan@gmail.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] procfs-add-size-to-proc-pid-fdinfo.patch removed from -mm tree
Message-Id: <20220911233016.554E8C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: procfs: add 'size' to /proc/<pid>/fdinfo/
has been removed from the -mm tree.  Its filename was
     procfs-add-size-to-proc-pid-fdinfo.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs: add 'size' to /proc/<pid>/fdinfo/
Date: Thu, 23 Jun 2022 15:06:06 -0700

Patch series "procfs: Add file path and size to /proc/<pid>/fdinfo", v2.

Processes can pin shared memory by keeping a handle to it through a
file descriptor; for instance dmabufs, memfd, and ashmem (in Android).

In the case of a memory leak, to identify the process pinning the
memory, userspace needs to:
  - Iterate the /proc/<pid>/fd/* for each process
  - Do a readlink on each entry to identify the type of memory from
    the file path.
  - stat() each entry to get the size of the memory.

The file permissions on /proc/<pid>/fd/* only allows for the owner
or root to perform the operations above; and so is not suitable for
capturing the system-wide state in a production environment.

This issue was addressed for dmabufs by making /proc/*/fdinfo/*
accessible to a process with PTRACE_MODE_READ_FSCREDS credentials[1]
To allow the same kind of tracking for other types of shared memory,
add the following fields to /proc/<pid>/fdinfo/<fd>:

path - This allows identifying the type of memory based on common
       prefixes: e.g. "/memfd...", "/dmabuf...", "/dev/ashmem..."

       This was not an issued when dmabuf tracking was introduced
       because the exp_name field of dmabuf fdinfo could be used
       to distinguish dmabuf fds from other types.

size - To track the amount of memory that is being pinned.

       dmabufs expose size as an additional field in fdinfo. Remove
       this and make it a common field for all fds.

Access to /proc/<pid>/fdinfo is governed by PTRACE_MODE_READ_FSCREDS
-- the same as for /proc/<pid>/maps which also exposes the path and
size for mapped memory regions.

This allows for a system process with PTRACE_MODE_READ_FSCREDS to
account the pinned per-process memory via fdinfo.


This patch (of 2):

To be able to account the amount of memory a process is keeping pinned by
open file descriptors add a 'size' field to fdinfo output.

dmabufs fds already expose a 'size' field for this reason, remove this and
make it a common field for all fds.  This allows tracking of other types
of memory (e.g.  memfd and ashmem in Android).

[kaleshsingh@google.com: add 'path' to /proc/<pid>/fdinfo/]
  Link: https://lkml.kernel.org/r/20220623220613.3014268-3-kaleshsingh@google.com
[akpm@linux-foundation.org: fix warning]
Link: https://lkml.kernel.org/r/20220623220613.3014268-1-kaleshsingh@google.com
Link: https://lkml.kernel.org/r/20220623220613.3014268-2-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Ioannis Ilkos <ilkos@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: Colin Cross <ccross@google.com>
Cc: Paul Gortmaker<paul.gortmaker@windriver.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   22 ++++++++++++++++++++--
 drivers/dma-buf/dma-buf.c          |    1 -
 fs/libfs.c                         |   13 +++++++++++--
 fs/proc/fd.c                       |   18 ++++++++++++++----
 include/linux/fs.h                 |    1 +
 5 files changed, 46 insertions(+), 9 deletions(-)

--- a/Documentation/filesystems/proc.rst~procfs-add-size-to-proc-pid-fdinfo
+++ a/Documentation/filesystems/proc.rst
@@ -1891,13 +1891,14 @@ if precise results are needed.
 3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
 ---------------------------------------------------------------
 This file provides information associated with an opened file. The regular
-files have at least four fields -- 'pos', 'flags', 'mnt_id' and 'ino'.
+files have at least five fields -- 'pos', 'flags', 'mnt_id', 'ino', and 'size'.
+
 The 'pos' represents the current offset of the opened file in decimal
 form [see lseek(2) for details], 'flags' denotes the octal O_xxx mask the
 file has been created with [see open(2) for details] and 'mnt_id' represents
 mount ID of the file system containing the opened file [see 3.5
 /proc/<pid>/mountinfo for details]. 'ino' represents the inode number of
-the file.
+the file, and 'size' represents the size of the file in bytes.
 
 A typical output is::
 
@@ -1905,11 +1906,15 @@ A typical output is::
 	flags:	0100002
 	mnt_id:	19
 	ino:	63107
+	size:	0
 
 All locks associated with a file descriptor are shown in its fdinfo too::
 
     lock:       1: FLOCK  ADVISORY  WRITE 359 00:13:11691 0 EOF
 
+Files with anonymous inodes have an additional 'path' field which represents
+the anonymous file path.
+
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
 pair provide additional information particular to the objects they represent.
 
@@ -1922,6 +1927,8 @@ Eventfd files
 	flags:	04002
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:[eventfd]
 	eventfd-count:	5a
 
 where 'eventfd-count' is hex value of a counter.
@@ -1935,6 +1942,8 @@ Signalfd files
 	flags:	04002
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:[signalfd]
 	sigmask:	0000000000000200
 
 where 'sigmask' is hex value of the signal mask associated
@@ -1949,6 +1958,8 @@ Epoll files
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:[eventpoll]
 	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
 
 where 'tfd' is a target file descriptor number in decimal form,
@@ -1967,6 +1978,8 @@ For inotify files the format is the foll
 	flags:	02000000
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:inotify
 	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
 
 where 'wd' is a watch descriptor in decimal form, i.e. a target file
@@ -1990,6 +2003,8 @@ For fanotify files the format is::
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:[fanotify]
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
@@ -2015,6 +2030,8 @@ Timerfd files
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
+	path:	anon_inode:[timerfd]
 	clockid: 0
 	ticks: 0
 	settime flags: 01
@@ -2039,6 +2056,7 @@ DMA Buffer files
 	mnt_id:	9
 	ino:	63107
 	size:   32768
+	path:	/dmabuf:
 	count:  2
 	exp_name:  system-heap
 
--- a/drivers/dma-buf/dma-buf.c~procfs-add-size-to-proc-pid-fdinfo
+++ a/drivers/dma-buf/dma-buf.c
@@ -484,7 +484,6 @@ static void dma_buf_show_fdinfo(struct s
 {
 	struct dma_buf *dmabuf = file->private_data;
 
-	seq_printf(m, "size:\t%zu\n", dmabuf->size);
 	/* Don't count the temporary reference taken inside procfs seq_show */
 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
--- a/fs/proc/fd.c~procfs-add-size-to-proc-pid-fdinfo
+++ a/fs/proc/fd.c
@@ -23,6 +23,7 @@ static int seq_show(struct seq_file *m,
 	struct files_struct *files = NULL;
 	int f_flags = 0, ret = -ENOENT;
 	struct file *file = NULL;
+	struct inode *inode = NULL;
 	struct task_struct *task;
 
 	task = get_proc_task(m->private);
@@ -54,10 +55,19 @@ static int seq_show(struct seq_file *m,
 	if (ret)
 		return ret;
 
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
-		   (long long)file->f_pos, f_flags,
-		   real_mount(file->f_path.mnt)->mnt_id,
-		   file_inode(file)->i_ino);
+	inode = file_inode(file);
+
+	seq_printf(m, "pos:\t%lli\n", (long long)file->f_pos);
+	seq_printf(m, "flags:\t0%o\n", f_flags);
+	seq_printf(m, "mnt_id:\t%i\n", real_mount(file->f_path.mnt)->mnt_id);
+	seq_printf(m, "ino:\t%lu\n", inode->i_ino);
+	seq_printf(m, "size:\t%lli\n", (long long)inode->i_size);
+
+	if (is_anon_inode(inode)) {
+		seq_puts(m, "path:\t");
+		seq_file_path(m, file, "\n");
+		seq_putc(m, '\n');
+	}
 
 	/* show_fd_locks() never deferences files so a stale value is safe */
 	show_fd_locks(m, file, files);
--- a/fs/libfs.c~procfs-add-size-to-proc-pid-fdinfo
+++ a/fs/libfs.c
@@ -1217,9 +1217,18 @@ void kfree_link(void *p)
 }
 EXPORT_SYMBOL(kfree_link);
 
+static const struct address_space_operations anon_aops = {
+	.dirty_folio	= noop_dirty_folio,
+};
+
+bool is_anon_inode(struct inode *inode)
+{
+	return inode->i_mapping->a_ops == &anon_aops;
+}
+
 struct inode *alloc_anon_inode(struct super_block *s)
 {
-	static const struct address_space_operations anon_aops = {
+	static const struct address_space_operations aops = {
 		.dirty_folio	= noop_dirty_folio,
 	};
 	struct inode *inode = new_inode_pseudo(s);
@@ -1228,7 +1237,7 @@ struct inode *alloc_anon_inode(struct su
 		return ERR_PTR(-ENOMEM);
 
 	inode->i_ino = get_next_ino();
-	inode->i_mapping->a_ops = &anon_aops;
+	inode->i_mapping->a_ops = &aops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
--- a/include/linux/fs.h~procfs-add-size-to-proc-pid-fdinfo
+++ a/include/linux/fs.h
@@ -3249,6 +3249,7 @@ extern void page_put_link(void *);
 extern int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
+extern bool is_anon_inode(struct inode *inode);
 void generic_fillattr(struct user_namespace *, struct inode *, struct kstat *);
 void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
_

Patches currently in -mm which might be from kaleshsingh@google.com are


