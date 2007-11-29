From: akpm@linux-foundation.org
Subject: + get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:54:02 -0800
Message-ID: <200711292054.lATKs2PU006930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbXK2Uz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:55:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, ink@jurassic.park.msu.ru, ralf@linux-mips.org, rth@twiddle.net


The patch titled
     get rid of NR_OPEN and introduce a sysctl_nr_open
has been added to the -mm tree.  Its filename is
     get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get rid of NR_OPEN and introduce a sysctl_nr_open
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    8 ++++++++
 Documentation/sysctl/fs.txt        |   10 ++++++++++
 arch/alpha/kernel/osf_sys.c        |    2 +-
 arch/mips/kernel/sysirix.c         |    2 +-
 arch/sparc64/solaris/fs.c          |    2 +-
 arch/sparc64/solaris/timod.c       |    6 ++++--
 fs/file.c                          |    8 +++++---
 include/linux/fs.h                 |    2 +-
 kernel/sys.c                       |    2 +-
 kernel/sysctl.c                    |    8 ++++++++
 10 files changed, 40 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
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
 
diff -puN Documentation/sysctl/fs.txt~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
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
diff -puN arch/alpha/kernel/osf_sys.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/arch/alpha/kernel/osf_sys.c
@@ -430,7 +430,7 @@ sys_getpagesize(void)
 asmlinkage unsigned long
 sys_getdtablesize(void)
 {
-	return NR_OPEN;
+	return sysctl_nr_open;
 }
 
 /*
diff -puN arch/mips/kernel/sysirix.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/arch/mips/kernel/sysirix.c
@@ -356,7 +356,7 @@ asmlinkage int irix_syssgi(struct pt_reg
 			retval = NGROUPS_MAX;
 			goto out;
 		case 5:
-			retval = NR_OPEN;
+			retval = sysctl_nr_open;
 			goto out;
 		case 6:
 			retval = 1;
diff -puN arch/sparc64/solaris/fs.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open arch/sparc64/solaris/fs.c
--- a/arch/sparc64/solaris/fs.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/arch/sparc64/solaris/fs.c
@@ -624,7 +624,7 @@ asmlinkage int solaris_ulimit(int cmd, i
 	case 3: /* UL_GMEMLIM */
 		return current->signal->rlim[RLIMIT_DATA].rlim_cur;
 	case 4: /* UL_GDESLIM */
-		return NR_OPEN;
+		return sysctl_nr_open;
 	}
 	return -EINVAL;
 }
diff -puN arch/sparc64/solaris/timod.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open arch/sparc64/solaris/timod.c
--- a/arch/sparc64/solaris/timod.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/arch/sparc64/solaris/timod.c
@@ -859,7 +859,8 @@ asmlinkage int solaris_getmsg(unsigned i
 
 	SOLD("entry");
 	lock_kernel();
-	if(fd >= NR_OPEN) goto out;
+	if (fd >= sysctl_nr_open)
+		goto out;
 
 	fdt = files_fdtable(current->files);
 	filp = fdt->fd[fd];
@@ -927,7 +928,8 @@ asmlinkage int solaris_putmsg(unsigned i
 
 	SOLD("entry");
 	lock_kernel();
-	if(fd >= NR_OPEN) goto out;
+	if (fd >= sysctl_nr_open)
+		goto out;
 
 	fdt = files_fdtable(current->files);
 	filp = fdt->fd[fd];
diff -puN fs/file.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open fs/file.c
--- a/fs/file.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
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
diff -puN include/linux/fs.h~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open include/linux/fs.h
--- a/include/linux/fs.h~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/include/linux/fs.h
@@ -21,7 +21,7 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+extern int sysctl_nr_open;
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
diff -puN kernel/sys.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open kernel/sys.c
--- a/kernel/sys.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/kernel/sys.c
@@ -1472,7 +1472,7 @@ asmlinkage long sys_setrlimit(unsigned i
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
+	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
diff -puN kernel/sysctl.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open kernel/sysctl.c
--- a/kernel/sysctl.c~get-rid-of-nr_open-and-introduce-a-sysctl_nr_open
+++ a/kernel/sysctl.c
@@ -1152,6 +1152,14 @@ static struct ctl_table fs_table[] = {
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
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
