Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA17C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 19:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46A964FDF
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 19:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhCHTwu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 14:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhCHTwu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 14:52:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8642464F11;
        Mon,  8 Mar 2021 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233169;
        bh=XmVtnarb645QuCi1V3V4RvVBQcsv019Cq512tdlWxWY=;
        h=Date:From:To:Subject:From;
        b=jDiulMSLLOadBwLijV4AIJnSKkah8PDgVkqrYQseOXHasgux6b646x/zcQm/75AWu
         mDKdDOYeW67YwHqlwi7fVoNFfZwBY7wxqvSHxbXqy7X0/V+aMmwl3bA9nhE6cw7jRK
         eLFFOwjc2DylX63fZfIp3UGXreGG49qIXMttZPCs=
Date:   Mon, 08 Mar 2021 11:52:47 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, avagin@gmail.com, bernd.edlinger@hotmail.de,
        christian.brauner@ubuntu.com, christian.koenig@amd.com,
        corbet@lwn.net, deller@gmx.de, ebiederm@xmission.com,
        gladkov.alexey@gmail.com, hridya@google.com,
        jamorris@linux.microsoft.com, jannh@google.com, jeffv@google.com,
        kaleshsingh@google.com, keescook@chromium.org,
        mchehab+huawei@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        surenb@google.com, szabolcs.nagy@arm.com, viro@zeniv.linux.org.uk,
        walken@google.com, willy@infradead.org
Subject:  + procfs-allow-reading-fdinfo-with-ptrace_mode_read.patch
 added to -mm tree
Message-ID: <20210308195247.kB9pjTwf7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: allow reading fdinfo with PTRACE_MODE_READ
has been added to the -mm tree.  Its filename is
     procfs-allow-reading-fdinfo-with-ptrace_mode_read.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-allow-reading-fdinfo-with-ptrace_mode_read.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-allow-reading-fdinfo-with-ptrace_mode_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs: allow reading fdinfo with PTRACE_MODE_READ

Android captures per-process system memory state when certain low memory
events (e.g a foreground app kill) occur, to identify potential memory
hoggers.  In order to measure how much memory a process actually consumes,
it is necessary to include the DMA buffer sizes for that process in the
memory accounting.  Since the handle to DMA buffers are raw FDs, it is
important to be able to identify which processes have FD references to a
DMA buffer.

Currently, DMA buffer FDs can be accounted using /proc/<pid>/fd/* and
/proc/<pid>/fdinfo -- both are only readable by the process owner, as
follows:

  1. Do a readlink on each FD.
  2. If the target path begins with "/dmabuf", then the FD is a dmabuf FD.
  3. stat the file to get the dmabuf inode number.
  4. Read/ proc/<pid>/fdinfo/<fd>, to get the DMA buffer size.

Accessing other processes' fdinfo requires root privileges.  This limits
the use of the interface to debugging environments and is not suitable for
production builds.  Granting root privileges even to a system process
increases the attack surface and is highly undesirable.

Since fdinfo doesn't permit reading process memory and manipulating
process state, allow accessing fdinfo under PTRACE_MODE_READ_FSCRED.

Link: https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Suggested-by: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 fs/proc/fd.c   |   15 ++++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c~procfs-allow-reading-fdinfo-with-ptrace_mode_read
+++ a/fs/proc/base.c
@@ -3159,7 +3159,7 @@ static const struct pid_entry tgid_base_
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
-	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("fdinfo",     S_IRUGO|S_IXUGO, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
@@ -3504,7 +3504,7 @@ static const struct inode_operations pro
  */
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("fdinfo",    S_IRUGO|S_IXUGO, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
--- a/fs/proc/fd.c~procfs-allow-reading-fdinfo-with-ptrace_mode_read
+++ a/fs/proc/fd.c
@@ -6,6 +6,7 @@
 #include <linux/fdtable.h>
 #include <linux/namei.h>
 #include <linux/pid.h>
+#include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
@@ -72,6 +73,18 @@ out:
 
 static int seq_fdinfo_open(struct inode *inode, struct file *file)
 {
+	bool allowed = false;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+
+	allowed = ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
+	put_task_struct(task);
+
+	if (!allowed)
+		return -EACCES;
+
 	return single_open(file, seq_show, inode);
 }
 
@@ -308,7 +321,7 @@ static struct dentry *proc_fdinfo_instan
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFREG | S_IRUSR);
+	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFREG | S_IRUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
_

Patches currently in -mm which might be from kaleshsingh@google.com are

procfs-allow-reading-fdinfo-with-ptrace_mode_read.patch
procfs-dmabuf-add-inode-number-to-proc-fdinfo.patch

