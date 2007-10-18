From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-opend-files-r-o-bind-mounts-fix-bug-in-reiserfs_delete_xattrs.patch added to -mm tree
Date: Wed, 17 Oct 2007 18:41:44 -0700
Message-ID: <200710180141.l9I1fiA7018573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbXJRBmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 21:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laurent.riffard@free.fr, haveblue@us.ibm.com, hch@infradead.org


The patch titled
     r-o-bind-mounts: fix BUG in reiserfs_delete_xattrs
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-opend-files-r-o-bind-mounts-fi=
x-bug-in-reiserfs_delete_xattrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: r-o-bind-mounts: fix BUG in reiserfs_delete_xattrs
=46rom: Laurent Riffard <laurent.riffard@free.fr>

Le 15.10.2007 20:31, Jeff Mahoney a =E9crit :
> Christoph Hellwig wrote:
>> On Mon, Oct 15, 2007 at 12:34:58AM +0200, Laurent Riffard wrote:
>>> reiserfs_delete_xattrs
>>> reiserfs_delete_inode
>>> generic_delete_inode
>>> generic_drop_inode
>>> iput
>>> do_unlinkat
>>> sys_unlink
>>> sys_enter_past_esp
>>>
>>> I reported a similar BUG in 2.6.22-rc8-mm2 (see
>>> http://lkml.org/lkml/2007/9/27/235). Dave Hansen sent a patch for i=
t, I
>>> tested it and it was OK for 2.6.22-rc8-mm2.
>>>
>>> I tried this patch on 2.6.23-mm1, and it fixed the BUGs here too.
>> The delete path is a similar case as the one Dave fixed, also cause =
by
>> a NULL vfsmount passed to dentry_open, but through a different code-=
path.
>>
>> Untested fix for this problem below:
>
> Here's a patch I worked up the other night that kills off struct file
> completely from the xattr code. I've tested it locally.

Sorry Jeff, your patch does not apply on 2.6.23-mm1. The 'struct file'
removal from reiserfs_xattr_ function is already in -mm
(make-reiserfs-stop-using-struct-file-for-internal.patch).

The Dave's patch I was refering to is this one:

=3D=3D=3D=3D BEGIN =3D=3D=3D=3D=3D
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
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-fil=
es-r-o-bind-mounts-fix-bug-in-reiserfs_delete_xattrs fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-files-r=
-o-bind-mounts-fix-bug-in-reiserfs_delete_xattrs
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
r-o-bind-mounts-elevate-write-count-opend-files-r-o-bind-mounts-fix-bug=
-in-reiserfs_delete_xattrs.patch
reiser4-drop-size-argument-from-bio_endio-and-bi_end_io.patch
