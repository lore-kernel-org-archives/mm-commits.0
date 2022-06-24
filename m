Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C225C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiFXTeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiFXTeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:34:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93C7A1A9
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E826621F7
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CEAC34114;
        Fri, 24 Jun 2022 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656099252;
        bh=0Fo5A+ZDfUFZACVMcy1ZZuEjeVzDI21v/9j2vpzXFLA=;
        h=Date:To:From:Subject:From;
        b=Ik9PX20+9UiCJUmOPsuZ6wIIVOtPlJORcLgNjizKd28QWu/JGlni5VRFvxs6FrllZ
         M4S+/QorfcjsmhUPZACr3xfN4gRXK40ELKgkmSJ9hMVUsgFy7yC1Sm1//Pn5VdWh5J
         uPFdEE62g+Mn0Hu4bjVxChH03TjnlUcH3ra18jBw=
Date:   Fri, 24 Jun 2022 12:34:12 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tjmercier@google.com, surenb@google.com, sumit.semwal@linaro.org,
        stephen.s.brennan@oracle.com, rdunlap@infradead.org,
        paul.gortmaker@windriver.com, mail@christoph.anton.mitterer.name,
        ilkos@google.com, hch@infradead.org, hannes@cmpxchg.org,
        David.Laight@ACULAB.COM, corbet@lwn.net, christian.koenig@amd.com,
        ccross@google.com, adobriyan@gmail.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-add-size-to-proc-pid-fdinfo.patch added to mm-unstable branch
Message-Id: <20220624193412.C7CEAC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add 'size' to /proc/<pid>/fdinfo/
has been added to the -mm mm-unstable branch.  Its filename is
     procfs-add-size-to-proc-pid-fdinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-add-size-to-proc-pid-fdinfo.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 Documentation/filesystems/proc.rst |   12 ++++++++++--
 drivers/dma-buf/dma-buf.c          |    1 -
 fs/proc/fd.c                       |    9 +++++----
 3 files changed, 15 insertions(+), 7 deletions(-)

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
 
@@ -1905,6 +1906,7 @@ A typical output is::
 	flags:	0100002
 	mnt_id:	19
 	ino:	63107
+	size:	0
 
 All locks associated with a file descriptor are shown in its fdinfo too::
 
@@ -1922,6 +1924,7 @@ Eventfd files
 	flags:	04002
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	eventfd-count:	5a
 
 where 'eventfd-count' is hex value of a counter.
@@ -1935,6 +1938,7 @@ Signalfd files
 	flags:	04002
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	sigmask:	0000000000000200
 
 where 'sigmask' is hex value of the signal mask associated
@@ -1949,6 +1953,7 @@ Epoll files
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
 
 where 'tfd' is a target file descriptor number in decimal form,
@@ -1967,6 +1972,7 @@ For inotify files the format is the foll
 	flags:	02000000
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
 
 where 'wd' is a watch descriptor in decimal form, i.e. a target file
@@ -1990,6 +1996,7 @@ For fanotify files the format is::
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
@@ -2015,6 +2022,7 @@ Timerfd files
 	flags:	02
 	mnt_id:	9
 	ino:	63107
+	size:   0
 	clockid: 0
 	ticks: 0
 	settime flags: 01
--- a/drivers/dma-buf/dma-buf.c~procfs-add-size-to-proc-pid-fdinfo
+++ a/drivers/dma-buf/dma-buf.c
@@ -378,7 +378,6 @@ static void dma_buf_show_fdinfo(struct s
 {
 	struct dma_buf *dmabuf = file->private_data;
 
-	seq_printf(m, "size:\t%zu\n", dmabuf->size);
 	/* Don't count the temporary reference taken inside procfs seq_show */
 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
--- a/fs/proc/fd.c~procfs-add-size-to-proc-pid-fdinfo
+++ a/fs/proc/fd.c
@@ -54,10 +54,11 @@ static int seq_show(struct seq_file *m,
 	if (ret)
 		return ret;
 
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
-		   (long long)file->f_pos, f_flags,
-		   real_mount(file->f_path.mnt)->mnt_id,
-		   file_inode(file)->i_ino);
+	seq_printf(m, "pos:\t%lli\n", (long long)file->f_pos);
+	seq_printf(m, "flags:\t0%o\n", f_flags);
+	seq_printf(m, "mnt_id:\t%i\n", real_mount(file->f_path.mnt)->mnt_id);
+	seq_printf(m, "ino:\t%lu\n", file_inode(file)->i_ino);
+	seq_printf(m, "size:\t%lli\n", (long long)file_inode(file)->i_size);
 
 	/* show_fd_locks() never deferences files so a stale value is safe */
 	show_fd_locks(m, file, files);
_

Patches currently in -mm which might be from kaleshsingh@google.com are

procfs-add-size-to-proc-pid-fdinfo.patch
procfs-add-path-to-proc-pid-fdinfo.patch

