From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-opend-files-reiserfs-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:00:20 -0700
Message-ID: <200710162000.l9GK0KES013123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbXJPUAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.riffard@free.fr, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix BUG in reiserfs_delete_xattrs
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-opend-files-reiserfs-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: fix BUG in reiserfs_delete_xattrs
=46rom: Laurent Riffard <laurent.riffard@free.fr>

Le 12.10.2007 06:31, Andrew Morton a =E9crit :
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/=
2.6.23-mm1/

/home is mounted with the following options:
   /dev/mapper/vglinux1-lvhome on /home type reiserfs (rw,noatime,nodir=
atime,user_xattr)

I guess that beagled (the Beagle desktop search daemon) has populated u=
ser
xattrs on almost all files. Now, when I delete a file, two BUGs occur
and the system hangs. Here is the stack for the first BUG (the second
one is very similar):

[partially hand copied stack]
_fput
fput
reiserfs_delete_xattrs
reiserfs_delete_inode
generic_delete_inode
generic_drop_inode
iput
do_unlinkat
sys_unlink
sys_enter_past_esp

I reported a similar BUG in 2.6.22-rc8-mm2 (see
http://lkml.org/lkml/2007/9/27/235). Dave Hansen sent a patch for it, I
tested it and it was OK for 2.6.22-rc8-mm2.

I tried this patch on 2.6.23-mm1, and it fixed the BUGs here too.

----

The bug is caused by reiserfs creating a special 'struct file' with a
NULL vfsmount.

/* Opens a file pointer to the attribute associated with inode */
static struct file *open_xa_file(const struct inode *inode, const char
*name,
                                 int flags)
{
=2E..
        fp =3D dentry_open(xafile, NULL, O_RDWR);
        /* dentry_open dputs the dentry if it fails */

As Christoph just said, this is somewhat of a bandaid.  But, it
shouldn't hurt anything.

Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-fil=
es-reiserfs-fix fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-files-r=
eiserfs-fix
+++ a/fs/file_table.c
@@ -236,7 +236,7 @@ void fastcall __fput(struct file *file)
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
+		if (!special_file(inode->i_mode) && mnt)
 			mnt_drop_write(mnt);
 	}
 	put_pid(file->f_owner.pid);
_

Patches currently in -mm which might be from laurent.riffard@free.fr ar=
e

origin.patch
r-o-bind-mounts-elevate-write-count-opend-files-reiserfs-fix.patch
reiser4-drop-size-argument-from-bio_endio-and-bi_end_io.patch
