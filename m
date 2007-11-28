From: akpm@linux-foundation.org
Subject: - remove-nr_open-and-introduce-a-sysctl_nr_open.patch removed from -mm tree
Date: Tue, 27 Nov 2007 20:39:51 -0800
Message-ID: <200711280447.lAS4l7al016278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbXK1Eru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 23:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     remove NR_OPEN and introduce a sysctl_nr_open
has been removed from the -mm tree.  Its filename was
     remove-nr_open-and-introduce-a-sysctl_nr_open.patch

This patch was dropped because the author forgot to grep for NR_OPEN

------------------------------------------------------
Subject: remove NR_OPEN and introduce a sysctl_nr_open
From: Eric Dumazet <dada1@cosmosbay.com>

NR_OPEN (historically set to 1024*1024) actually forbids processes to open
more than 1024*1024 handles.

Unfortunatly some production servers hit the not so 'ridiculously high
value' of 1024*1024 file descriptors per process.

Changing NR_OPEN is not considered safe because of vmalloc space potential
exhaust.

This patch introduces a new sysctl (/proc/sys/fs/nr_open) wich defaults to
1024*1024, so that admins can decide to change this limit if their workload
needs it.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    8 ++++++++
 Documentation/sysctl/fs.txt        |   10 ++++++++++
 fs/file.c                          |    8 +++++---
 include/linux/fs.h                 |    2 +-
 kernel/sys.c                       |    2 +-
 kernel/sysctl.c                    |    8 ++++++++
 6 files changed, 33 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/proc.txt~remove-nr_open-and-introduce-a-sysctl_nr_open Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/Documentation/filesystems/proc.txt
@@ -989,6 +989,14 @@ nr_inodes
 Denotes the  number  of  inodes the system has allocated. This number will
 grow and shrink dynamically.
 
+nr_open
+-------
+
+Denotes the maximum number of file-handles a process can
+allocate. Default value is 1024*1024 (1048576) which should be
+enough for most machines. Actual limit depends on RLIMIT_NOFILE
+resource limit.
+
 nr_free_inodes
 --------------
 
diff -puN Documentation/sysctl/fs.txt~remove-nr_open-and-introduce-a-sysctl_nr_open Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/Documentation/sysctl/fs.txt
@@ -23,6 +23,7 @@ Currently, these files are in /proc/sys/
 - inode-max
 - inode-nr
 - inode-state
+- nr_open
 - overflowuid
 - overflowgid
 - suid_dumpable
@@ -91,6 +92,15 @@ usage of file handles and you don't need
 
 ==============================================================
 
+nr_open:
+
+This denotes the maximum number of file-handles a process can
+allocate. Default value is 1024*1024 (1048576) which should be
+enough for most machines. Actual limit depends on RLIMIT_NOFILE
+resource limit.
+
+==============================================================
+
 inode-max, inode-nr & inode-state:
 
 As with file handles, the kernel allocates the inode structures
diff -puN fs/file.c~remove-nr_open-and-introduce-a-sysctl_nr_open fs/file.c
--- a/fs/file.c~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/fs/file.c
@@ -24,6 +24,8 @@ struct fdtable_defer {
 	struct fdtable *next;
 };
 
+int sysctl_nr_open __read_mostly = 1024*1024;
+
 /*
  * We use this list to defer free fdtables that have vmalloced
  * sets/arrays. By keeping a per-cpu list, we avoid having to embed
@@ -147,8 +149,8 @@ static struct fdtable * alloc_fdtable(un
 	nr /= (1024 / sizeof(struct file *));
 	nr = roundup_pow_of_two(nr + 1);
 	nr *= (1024 / sizeof(struct file *));
-	if (nr > NR_OPEN)
-		nr = NR_OPEN;
+	if (nr > sysctl_nr_open)
+		nr = sysctl_nr_open;
 
 	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
 	if (!fdt)
@@ -233,7 +235,7 @@ int expand_files(struct files_struct *fi
 	if (nr < fdt->max_fds)
 		return 0;
 	/* Can we expand? */
-	if (nr >= NR_OPEN)
+	if (nr >= sysctl_nr_open)
 		return -EMFILE;
 
 	/* All good, so we try */
diff -puN include/linux/fs.h~remove-nr_open-and-introduce-a-sysctl_nr_open include/linux/fs.h
--- a/include/linux/fs.h~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/include/linux/fs.h
@@ -21,7 +21,7 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+extern int sysctl_nr_open;
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
diff -puN kernel/sys.c~remove-nr_open-and-introduce-a-sysctl_nr_open kernel/sys.c
--- a/kernel/sys.c~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/kernel/sys.c
@@ -1472,7 +1472,7 @@ asmlinkage long sys_setrlimit(unsigned i
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
+	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
diff -puN kernel/sysctl.c~remove-nr_open-and-introduce-a-sysctl_nr_open kernel/sysctl.c
--- a/kernel/sysctl.c~remove-nr_open-and-introduce-a-sysctl_nr_open
+++ a/kernel/sysctl.c
@@ -1127,6 +1127,14 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= FS_DENTRY,
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
git-net.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
remove-nr_open-and-introduce-a-sysctl_nr_open.patch
