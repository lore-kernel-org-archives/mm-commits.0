Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9902AC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJRBsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiJRBsB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3649D754BD
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C789C61338
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0DDC433D6;
        Tue, 18 Oct 2022 01:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666057679;
        bh=qf3nxSlUHVwaC0cVsV/m9AoCAUvbAQTbRgM3BtME5uc=;
        h=Date:To:From:Subject:From;
        b=DX1La+DWsBJubh1uq60Z8JMhBPPERuhqyeVa78TgDRpg3EtUe4Vh80jb/pcjxSPor
         hS6yt6p0Rueavy+1gJ0GT2NPH5Nd8Udc2pUXMsB4SSTY7ETzclNI/SAxXXYero4v21
         wqO+1tcPIoLmo/+DdMRKkt21upFAIXP7/161MhRw=
Date:   Mon, 17 Oct 2022 18:47:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        hannes@cmpxchg.org, david@redhat.com, David.Laight@ACULAB.COM,
        corbet@lwn.net, adobriyan@gmail.com, ivan@cloudflare.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch added to mm-nonmm-unstable branch
Message-Id: <20221018014759.2E0DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: report open files as size in stat() for /proc/pid/fd
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ivan Babrou <ivan@cloudflare.com>
Subject: proc: report open files as size in stat() for /proc/pid/fd
Date: Thu, 22 Sep 2022 15:40:26 -0700

Many monitoring tools include open file count as a metric.  Currently the
only way to get this number is to enumerate the files in /proc/pid/fd.

The problem with the current approach is that it does many things people
generally don't care about when they need one number for a metric.  In our
tests for cadvisor, which reports open file counts per cgroup, we observed
that reading the number of open files is slow.  Out of 35.23% of CPU time
spent in `proc_readfd_common`, we see 29.43% spent in `proc_fill_cache`,
which is responsible for filling dentry info.  Some of this extra time is
spinlock contention, but it's a contention for the lock we don't want to
take to begin with.

We considered putting the number of open files in /proc/pid/status. 
Unfortunately, counting the number of fds involves iterating the
open_files bitmap, which has a linear complexity in proportion with the
number of open files (bitmap slots really, but it's close).  We don't want
to make /proc/pid/status any slower, so instead we put this info in
/proc/pid/fd as a size member of the stat syscall result.  Previously the
reported number was zero, so there's very little risk of breaking
anything, while still providing a somewhat logical way to count the open
files with a fallback if it's zero.

RFC for this patch included iterating open fds under RCU.  Thanks to Frank
Hofmann for the suggestion to use the bitmap instead.

Previously:

```
$ sudo stat /proc/1/fd | head -n2
  File: /proc/1/fd
  Size: 0         	Blocks: 0          IO Block: 1024   directory
```

With this patch:

```
$ sudo stat /proc/1/fd | head -n2
  File: /proc/1/fd
  Size: 65        	Blocks: 0          IO Block: 1024   directory
```

Correctness check:

```
$ sudo ls /proc/1/fd | wc -l
65
```

I added the docs for /proc/<pid>/fd while I'm at it.

Link: https://lkml.kernel.org/r/20220922224027.59266-1-ivan@cloudflare.com
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   17 ++++++++++
 fs/proc/fd.c                       |   44 +++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

--- a/Documentation/filesystems/proc.rst~proc-report-open-files-as-size-in-stat-for-proc-pid-fd
+++ a/Documentation/filesystems/proc.rst
@@ -47,6 +47,7 @@ fixes/update part 1.1  Stefani Seibold <
   3.10  /proc/<pid>/timerslack_ns - Task timerslack value
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
+  3.13  /proc/<pid>/fd - List of symlinks to open files
 
   4	Configuring procfs
   4.1	Mount options
@@ -2149,6 +2150,22 @@ AVX512_elapsed_ms
   the task is unlikely an AVX512 user, but depends on the workload and the
   scheduling scenario, it also could be a false negative mentioned above.
 
+3.13 /proc/<pid>/fd - List of symlinks to open files
+-------------------------------------------------------
+This directory contains symbolic links which represent open files
+the process is maintaining.  Example output::
+
+  lr-x------ 1 root root 64 Sep 20 17:53 0 -> /dev/null
+  l-wx------ 1 root root 64 Sep 20 17:53 1 -> /dev/null
+  lrwx------ 1 root root 64 Sep 20 17:53 10 -> 'socket:[12539]'
+  lrwx------ 1 root root 64 Sep 20 17:53 11 -> 'socket:[12540]'
+  lrwx------ 1 root root 64 Sep 20 17:53 12 -> 'socket:[12542]'
+
+The number of open files for the process is stored in 'size' member
+of stat() output for /proc/<pid>/fd for fast access.
+-------------------------------------------------------
+
+
 Chapter 4: Configuring procfs
 =============================
 
--- a/fs/proc/fd.c~proc-report-open-files-as-size-in-stat-for-proc-pid-fd
+++ a/fs/proc/fd.c
@@ -279,6 +279,34 @@ out:
 	return 0;
 }
 
+static int proc_readfd_count(struct inode *inode)
+{
+	struct task_struct *p = get_proc_task(inode);
+	struct fdtable *fdt;
+	unsigned int i, size, open_fds = 0;
+
+	if (!p)
+		return -ENOENT;
+
+	task_lock(p);
+	if (p->files) {
+		rcu_read_lock();
+
+		fdt = files_fdtable(p->files);
+		size = fdt->max_fds;
+
+		for (i = size / BITS_PER_LONG; i > 0;)
+			open_fds += hweight64(fdt->open_fds[--i]);
+
+		rcu_read_unlock();
+	}
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return open_fds;
+}
+
 static int proc_readfd(struct file *file, struct dir_context *ctx)
 {
 	return proc_readfd_common(file, ctx, proc_fd_instantiate);
@@ -319,9 +347,25 @@ int proc_fd_permission(struct user_names
 	return rv;
 }
 
+static int proc_fd_getattr(struct user_namespace *mnt_userns,
+			const struct path *path, struct kstat *stat,
+			u32 request_mask, unsigned int query_flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+
+	generic_fillattr(&init_user_ns, inode, stat);
+
+	/* If it's a directory, put the number of open fds there */
+	if (S_ISDIR(inode->i_mode))
+		stat->size = proc_readfd_count(inode);
+
+	return 0;
+}
+
 const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
+	.getattr	= proc_fd_getattr,
 	.setattr	= proc_setattr,
 };
 
_

Patches currently in -mm which might be from ivan@cloudflare.com are

proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

