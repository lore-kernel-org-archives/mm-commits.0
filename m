Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222C8C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIKX2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIKX2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:28:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974802559D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3684C61117
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2E4C433C1;
        Sun, 11 Sep 2022 23:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938929;
        bh=GUzdYsKT64DXgyeql0JjEUCz9NTMFm8ik4DfQjaH0S0=;
        h=Date:To:From:Subject:From;
        b=ZhTMLlX4u3PiVlgLLsIZrJCtSwW5tLZKKEOwxeepCUH9S8Bs65XTbzL2GhUD5PX9m
         iO6S94I1JFUWABZA0tD900V/cFHwpj0n7kL/QlqreFZ6kGNnXQZag2T+ppTPGubn8x
         s5DpJQI4uVCR2GZ9UjvgEEC5N7ScBQgTO1AK+2ds=
Date:   Sun, 11 Sep 2022 16:28:48 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tjmercier@google.com, surenb@google.com, sumit.semwal@linaro.org,
        stephen.s.brennan@oracle.com, rdunlap@infradead.org,
        paul.gortmaker@windriver.com, mail@christoph.anton.mitterer.name,
        ilkos@google.com, hch@infradead.org, hannes@cmpxchg.org,
        David.Laight@ACULAB.COM, corbet@lwn.net, christian.koenig@amd.com,
        ccross@google.com, adobriyan@gmail.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] procfs-add-path-to-proc-pid-fdinfo.patch removed from -mm tree
Message-Id: <20220911232849.8A2E4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: procfs: add 'path' to /proc/<pid>/fdinfo/
has been removed from the -mm tree.  Its filename was
     procfs-add-path-to-proc-pid-fdinfo.patch

This patch was dropped because it was folded into procfs-add-size-to-proc-pid-fdinfo.patch

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs: add 'path' to /proc/<pid>/fdinfo/
Date: Thu, 23 Jun 2022 15:06:07 -0700

In order to identify the type of memory a process has pinned through its
open fds, add the file path to fdinfo output.  This allows identifying
memory types based on common prefixes: e.g.  "/memfd...", "/dmabuf...",
"/dev/ashmem...".

To be cautious, only expose the paths for anonymous inodes, and this also
avoids printing path names with strange characters.

Access to /proc/<pid>/fdinfo is governed by PTRACE_MODE_READ_FSCREDS the
same as /proc/<pid>/maps which also exposes the file path of mappings; so
the security permissions for accessing path is consistent with that of
/proc/<pid>/maps.

Link: https://lkml.kernel.org/r/20220623220613.3014268-3-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Colin Cross <ccross@google.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Ioannis Ilkos <ilkos@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Paul Gortmaker<paul.gortmaker@windriver.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   10 ++++++++++
 fs/libfs.c                         |    9 +++++++++
 fs/proc/fd.c                       |   13 +++++++++++--
 include/linux/fs.h                 |    1 +
 4 files changed, 31 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~procfs-add-path-to-proc-pid-fdinfo
+++ a/Documentation/filesystems/proc.rst
@@ -1912,6 +1912,9 @@ All locks associated with a file descrip
 
     lock:       1: FLOCK  ADVISORY  WRITE 359 00:13:11691 0 EOF
 
+Files with anonymous inodes have an additional 'path' field which represents
+the anonymous file path.
+
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
 pair provide additional information particular to the objects they represent.
 
@@ -1925,6 +1928,7 @@ Eventfd files
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:[eventfd]
 	eventfd-count:	5a
 
 where 'eventfd-count' is hex value of a counter.
@@ -1939,6 +1943,7 @@ Signalfd files
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:[signalfd]
 	sigmask:	0000000000000200
 
 where 'sigmask' is hex value of the signal mask associated
@@ -1954,6 +1959,7 @@ Epoll files
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:[eventpoll]
 	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
 
 where 'tfd' is a target file descriptor number in decimal form,
@@ -1973,6 +1979,7 @@ For inotify files the format is the foll
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:inotify
 	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
 
 where 'wd' is a watch descriptor in decimal form, i.e. a target file
@@ -1997,6 +2004,7 @@ For fanotify files the format is::
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:[fanotify]
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
@@ -2023,6 +2031,7 @@ Timerfd files
 	mnt_id:	9
 	ino:	63107
 	size:   0
+	path:	anon_inode:[timerfd]
 	clockid: 0
 	ticks: 0
 	settime flags: 01
@@ -2047,6 +2056,7 @@ DMA Buffer files
 	mnt_id:	9
 	ino:	63107
 	size:   32768
+	path:	/dmabuf:
 	count:  2
 	exp_name:  system-heap
 
--- a/fs/libfs.c~procfs-add-path-to-proc-pid-fdinfo
+++ a/fs/libfs.c
@@ -1217,6 +1217,15 @@ void kfree_link(void *p)
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
 	static const struct address_space_operations anon_aops = {
--- a/fs/proc/fd.c~procfs-add-path-to-proc-pid-fdinfo
+++ a/fs/proc/fd.c
@@ -23,6 +23,7 @@ static int seq_show(struct seq_file *m,
 	struct files_struct *files = NULL;
 	int f_flags = 0, ret = -ENOENT;
 	struct file *file = NULL;
+	struct inode *inode = NULL;
 	struct task_struct *task;
 
 	task = get_proc_task(m->private);
@@ -54,11 +55,19 @@ static int seq_show(struct seq_file *m,
 	if (ret)
 		return ret;
 
+	inode = file_inode(file);
+
 	seq_printf(m, "pos:\t%lli\n", (long long)file->f_pos);
 	seq_printf(m, "flags:\t0%o\n", f_flags);
 	seq_printf(m, "mnt_id:\t%i\n", real_mount(file->f_path.mnt)->mnt_id);
-	seq_printf(m, "ino:\t%lu\n", file_inode(file)->i_ino);
-	seq_printf(m, "size:\t%lli\n", (long long)file_inode(file)->i_size);
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
--- a/include/linux/fs.h~procfs-add-path-to-proc-pid-fdinfo
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

procfs-add-size-to-proc-pid-fdinfo.patch

