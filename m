From: akpm@linux-foundation.org
Subject: + proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 15:23:58 -0700
Message-ID: <20200420222358.UnGR_xC7y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWYC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, akpm@linux-foundation.org, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: rename struct proc_fs_info to proc_fs_opts
has been added to the -mm tree.  Its filename is
     proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: proc: rename struct proc_fs_info to proc_fs_opts

Preface:
--------

This is patch set v12 to modernize procfs and make it able to support
multiple private instances per the same pid namespace.

Procfs modernization:
---------------------

Historically procfs was always tied to pid namespaces, during pid
namespace creation we internally create a procfs mount for it.  However,
this has the effect that all new procfs mounts are just a mirror of the
internal one, any change, any mount option update, any new future
introduction will propagate to all other procfs mounts that are in the
same pid namespace.

This may have solved several use cases in that time.  However today we
face new requirements, and making procfs able to support new private
instances inside same pid namespace seems a major point.  If we want to to
introduce new features and security mechanisms we have to make sure first
that we do not break existing usecases.  Supporting private procfs
instances will allow to support new features and behaviour without
propagating it to all other procfs mounts.

Today procfs is more of a burden especially to some Embedded, IoT,
sandbox, container use cases.  In user space we are over-mounting null or
inaccessible files on top to hide files and information.  If we want to
hide pids we have to create PID namespaces otherwise mount options
propagate to all other proc mounts, changing a mount option value in one
mount will propagate to all other proc mounts.  If we want to introduce
new features, then they will propagate to all other mounts too, resulting
either maybe new useful functionality or maybe breaking stuff.  We have
also to note that userspace should not workaround procfs, the kernel
should just provide a sane simple interface.

In this regard several developers and maintainers pointed out that there
are problems with procfs and it has to be modernized:

"Here's another one: split up and modernize /proc." by Andy Lutomirski [1]

Discussion about kernel pointer leaks:

"And yes, as Kees and Daniel mentioned, it's definitely not just dmesg. 
In fact, the primary things tend to be /proc and /sys, not dmesg itself."
By Linus Torvalds [2]

Lot of other areas in the kernel and filesystems have been updated to be
able to support private instances, devpts is one major example [3].

Which will be used for:

1) Embedded systems and IoT: usually we have one supervisor for apps,
   we have some lightweight sandbox support, however if we create pid
   namespaces we have to manage all the processes inside too, where our
   goal is to be able to run a bunch of apps each one inside its own mount
   namespace, maybe use network namespaces for vlans setups, but right now
   we only want mount namespaces, without all the other complexity.  We
   want procfs to behave more like a real file system, and block access to
   inodes that belong to other users.  The 'hidepid=' will not work since
   it is a shared mount option.

2) Containers, sandboxes and Private instances of file systems - devpts
   case Historically, lot of file systems inside Linux kernel view when
   instantiated were just a mirror of an already created and mounted
   filesystem.  This was the case of devpts filesystem, it seems at that
   time the requirements were to optimize things and reuse the same
   memory, etc.  This design used to work but not anymore with today's
   containers, IoT, hostile environments and all the privacy challenges
   that Linux faces.

   In that regard, devpts was updated so that each new mounts is a total
   independent file system by the following patches:

   "devpts: Make each mount of devpts an independent filesystem" by
   Eric W.  Biederman [3] [4]

3) Linux Security Modules have multiple ptrace paths inside some
   subsystems, however inside procfs, the implementation does not
   guarantee that the ptrace() check which triggers the
   security_ptrace_check() hook will always run.  We have the 'hidepid'
   mount option that can be used to force the ptrace_may_access() check
   inside has_pid_permissions() to run.  The problem is that 'hidepid' is
   per pid namespace and not attached to the mount point, any remount or
   modification of 'hidepid' will propagate to all other procfs mounts.

   This also does not allow to support Yama LSM easily in desktop and
   user sessions.  Yama ptrace scope which restricts ptrace and some other
   syscalls to be allowed only on inferiors, can be updated to have a
   per-task context, where the context will be inherited during fork(),
   clone() and preserved across execve().  If we support multiple private
   procfs instances, then we may force the ptrace_may_access() on
   /proc/<pids>/ to always run inside that new procfs instances.  This
   will allow to specifiy on user sessions if we should populate procfs
   with pids that the user can ptrace or not.

   By using Yama ptrace scope, some restricted users will only be able
   to see inferiors inside /proc, they won't even be able to see their
   other processes.  Some software like Chromium, Firefox's crash handler,
   Wine and others are already using Yama to restrict which processes can
   be ptracable.  With this change this will give the possibility to
   restrict /proc/<pids>/ but more importantly this will give desktop
   users a generic and usuable way to specifiy which users should see all
   processes and which user can not.

   Side notes:

   * This covers the lack of seccomp where it is not able to parse
     arguments, it is easy to install a seccomp filter on direct syscalls
     that operate on pids, however /proc/<pid>/ is a Linux ABI using
     filesystem syscalls.  With this change all LSMs should be able to
     analyze open/read/write/close...  on /proc/<pid>/

4) This will allow to implement new features either in kernel or
   userspace without having to worry about procfs.  In containers,
   sandboxes, etc we have workarounds to hide some /proc inodes, this
   should be supported natively without doing extra complex work, the
   kernel should be able to support sane options that work with today and
   future Linux use cases.

5) Creation of new superblock with all procfs options for each procfs
   mount will fix the ignoring of mount options.  The problem is that the
   second mount of procfs in the same pid namespace ignores the mount
   options.  The mount options are ignored without error until procfs is
   remounted.

Before:

# grep ^proc /proc/mounts
proc /proc proc rw,relatime,hidepid=2 0 0

# strace -e mount mount -o hidepid=1 -t proc proc /tmp/proc
mount("proc", "/tmp/proc", "proc", 0, "hidepid=1") = 0
+++ exited with 0 +++

# grep ^proc /proc/mounts
proc /proc proc rw,relatime,hidepid=2 0 0
proc /tmp/proc proc rw,relatime,hidepid=2 0 0

# mount -o remount,hidepid=1 -t proc proc /tmp/proc

# grep ^proc /proc/mounts
proc /proc proc rw,relatime,hidepid=1 0 0
proc /tmp/proc proc rw,relatime,hidepid=1 0 0

After:

# grep ^proc /proc/mounts
proc /proc proc rw,relatime,hidepid=ptraceable 0 0

# mount -o hidepid=invisible -t proc proc /tmp/proc

# grep ^proc /proc/mounts
proc /proc proc rw,relatime,hidepid=ptraceable 0 0
proc /tmp/proc proc rw,relatime,hidepid=invisible 0 0


Introduced changes:
-------------------

Each mount of procfs creates a separate procfs instance with its own mount
options.

This series adds few new mount options:

* New 'hidepid=ptraceable' or 'hidepid=4' mount option to show only
  ptraceable processes in the procfs.  This allows to support lightweight
  sandboxes in Embedded Linux, also solves the case for LSM where now with
  this mount option, we make sure that they have a ptrace path in procfs.

* 'subset=pid' that allows to hide non-pid inodes from procfs.  It can
  be used in containers and sandboxes, as these are already trying to hide
  and block access to procfs inodes anyway.


References:
-----------
[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-January/004215.html
[2] http://www.openwall.com/lists/kernel-hardening/2017/10/05/5
[3] https://lwn.net/Articles/689539/
[4] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14
[5] https://lkml.org/lkml/2017/5/2/407
[6] https://lkml.org/lkml/2017/5/3/357
[7] https://lkml.org/lkml/2018/5/11/505


This patch (of 7):

Rename struct proc_fs_info to proc_fs_opts.

Link: http://lkml.kernel.org/r/20200419141057.621356-2-gladkov.alexey@gmail.com
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc_namespace.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/proc_namespace.c~proc-rename-struct-proc_fs_info-to-proc_fs_opts
+++ a/fs/proc_namespace.c
@@ -37,23 +37,23 @@ static __poll_t mounts_poll(struct file
 	return res;
 }
 
-struct proc_fs_info {
+struct proc_fs_opts {
 	int flag;
 	const char *str;
 };
 
 static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
-	static const struct proc_fs_info fs_info[] = {
+	static const struct proc_fs_opts fs_opts[] = {
 		{ SB_SYNCHRONOUS, ",sync" },
 		{ SB_DIRSYNC, ",dirsync" },
 		{ SB_MANDLOCK, ",mand" },
 		{ SB_LAZYTIME, ",lazytime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = fs_opts; fs_infop->flag; fs_infop++) {
 		if (sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
@@ -63,7 +63,7 @@ static int show_sb_opts(struct seq_file
 
 static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 {
-	static const struct proc_fs_info mnt_info[] = {
+	static const struct proc_fs_opts mnt_opts[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -72,9 +72,9 @@ static void show_mnt_opts(struct seq_fil
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = mnt_opts; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are

proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch
proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option.patch
proc-add-option-to-mount-only-a-pids-subset.patch
docs-proc-add-documentation-for-hidepid=4-and-subset=pid-options-and-new-mount-behavior.patch
proc-use-human-readable-values-for-hidepid.patch
proc-use-named-enums-for-better-readability.patch
