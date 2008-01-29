From: akpm@linux-foundation.org
Subject: + mount-options-add-documentation.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:21:56 -0800
Message-ID: <200801292321.m0TNLvxU009648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbYA2XWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mount options: add documentation
has been added to the -mm tree.  Its filename is
     mount-options-add-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: add documentation
From: Miklos Szeredi <mszeredi@suse.cz>

This series addresses the problem of showing mount options in
/proc/mounts.

Several filesystems which use mount options, have not implemented a
.show_options superblock operation.  Several others have implemented
this callback, but have not kept it fully up to date with the parsed
options.

Q: Why do we need correct option showing in /proc/mounts?
A: We want /proc/mounts to fully replace /etc/mtab.  The reasons for
   this are:
    - unprivileged mounters won't be able to update /etc/mtab
    - /etc/mtab doesn't work with private mount namespaces
    - /etc/mtab can become out-of-sync with reality

Q: Can't this be done, so that filesystems need not bother with
   implementing a .show_mounts callback, and keeping it up to date?
A: Only in some cases.  Certain filesystems allow modification of a
   subset of options in their remount_fs method.  It is not possible
   to take this into account without knowing exactly how the
   filesystem handles options.

For the simple case (no remount or remount resets all options) the
patchset introduces two helpers:

  generic_show_options()
  save_mount_options()

These can also be used to emulate the old /etc/mtab behavior, until
proper support is added.  Even if this is not 100% correct, it's still
better than showing no options at all.

The following patches fix up most in-tree filesystems, some have been
compile tested only, some have been reviewed and acked by the
maintainer.

Table displaying status of all in-kernel filesystems:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
legend:

  none - fs has options, but doesn't define ->show_options()
  some - fs defines ->show_options(), but some only options are shown
  good - fs shows all options
  noopt - fs does not have options
  patch - a patch will be posted
  merged - a patch has been merged by subsystem maintainer

9p          good
adfs        patch
affs        patch
afs         patch
autofs      patch
autofs4     patch
befs        patch
bfs         noopt
cifs        some
coda        noopt
configfs    noopt
cramfs      noopt
debugfs     noopt
devpts      patch
ecryptfs    good
efs         noopt
ext2        patch
ext3        good
ext4        merged
fat         patch
freevxfs    noopt
fuse        patch
fusectl	    noopt
gfs2        good
gfs2meta    noopt
hfs         good
hfsplus     good
hostfs      patch
hpfs        patch
hppfs       noopt
hugetlbfs   patch
isofs       patch
jffs2       noopt
jfs         merged
minix       noopt
msdos       ->fat
ncpfs       patch
nfs         some
nfsd        noopt
ntfs        good
ocfs2       good
ocfs2/dlmfs noopt
openpromfs  noopt
proc        noopt
qnx4        noopt
ramfs       noopt
reiserfs    patch
romfs       noopt
smbfs       good
sysfs       noopt
sysv        noopt
udf         patch
ufs         good
vfat        ->fat
xfs         good

mm/shmem.c                                    patch
drivers/oprofile/oprofilefs.c                 noopt
drivers/infiniband/hw/ipath/ipath_fs.c        noopt
drivers/misc/ibmasm/ibmasmfs.c                noopt
drivers/usb/core (usbfs)                      merged
drivers/usb/gadget (gadgetfs)                 noopt
drivers/isdn/capi/capifs.c                    patch
kernel/cpuset.c                               noopt
fs/binfmt_misc.c                              noopt
net/sunrpc/rpc_pipe.c                         noopt
arch/powerpc/platforms/cell/spufs             patch
arch/s390/hypfs                               good
ipc/mqueue.c                                  noopt
security (securityfs)                         noopt
security/selinux/selinuxfs.c                  noopt
kernel/cgroup.c                               good
security/smack/smackfs.c                      noopt

in -mm:

reiser4     some
unionfs     good
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This patch:

Document the rules for handling mount options in the .show_options
super operation.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   50 ++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~mount-options-add-documentation Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mount-options-add-documentation
+++ a/Documentation/filesystems/vfs.txt
@@ -151,7 +151,7 @@ The get_sb() method has the following ar
   const char *dev_name: the device name we are mounting.
 
   void *data: arbitrary mount options, usually comes as an ASCII
-	string
+	string (see "Mount Options" section)
 
   struct vfsmount *mnt: a vfs-internal representation of a mount point
 
@@ -182,7 +182,7 @@ A fill_super() method implementation has
   	must initialize this properly.
 
   void *data: arbitrary mount options, usually comes as an ASCII
-	string
+	string (see "Mount Options" section)
 
   int silent: whether or not to be silent on error
 
@@ -291,7 +291,8 @@ or bottom half).
 
   umount_begin: called when the VFS is unmounting a filesystem.
 
-  show_options: called by the VFS to show mount options for /proc/<pid>/mounts.
+  show_options: called by the VFS to show mount options for
+	/proc/<pid>/mounts.  (see "Mount Options" section)
 
   quota_read: called by the VFS to read from filesystem quota file.
 
@@ -969,6 +970,49 @@ manipulate dentries:
 For further information on dentry locking, please refer to the document
 Documentation/filesystems/dentry-locking.txt.
 
+Mount Options
+=============
+
+Parsing options
+---------------
+
+On mount and remount the filesystem is passed a string containing a
+comma separated list of mount options.  The options can have either of
+these forms:
+
+  option
+  option=value
+
+The <linux/parser.h> header defines an API that helps parse these
+options.  There are plenty of examples on how to use it in existing
+filesystems.
+
+Showing options
+---------------
+
+If a filesystem accepts mount options, it must define show_options()
+to show all the currently active options.  The rules are:
+
+  - options MUST be shown which are not default or their values differ
+    from the default
+
+  - options MAY be shown which are enabled by default or have their
+    default value
+
+Options used only internally between a mount helper and the kernel
+(such as file descriptors), or which only have an effect during the
+mounting (such as ones controlling the creation of a journal) are exempt
+from the above rules.
+
+The underlying reason for the above rules is to make sure, that a
+mount can be accurately replicated (e.g. umounting and mounting again)
+based on the information found in /proc/mounts.
+
+A simple method of saving options at mount/remount time and showing
+them is provided with the save_mount_options() and
+generic_show_options() helper functions.  Please note, that using
+these may have drawbacks.  For more info see header comments for these
+functions in fs/namespace.c.
 
 Resources
 =========
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
