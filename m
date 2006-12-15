From: akpm@osdl.org
Subject: + fsstack-remove-inode-copy.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:31:58 -0800
Message-ID: <200612152231.kBFMVwCx003275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbWLOWfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, jsipek@cs.sunysb.edu


The patch titled
     fsstack: Remove inode copy
has been added to the -mm tree.  Its filename is
     fsstack-remove-inode-copy.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsstack: Remove inode copy
From: Michael Halcrow <mhalcrow@us.ibm.com>

Trevor found a file size problem in eCryptfs in recent kernels, and he
tracked it down to an fsstack change.

This was the eCryptfs copy_attr_all:

> -void ecryptfs_copy_attr_all(struct inode *dest, const struct inode *src)
> -{
> -       dest->i_mode = src->i_mode;
> -       dest->i_nlink = src->i_nlink;
> -       dest->i_uid = src->i_uid;
> -       dest->i_gid = src->i_gid;
> -       dest->i_rdev = src->i_rdev;
> -       dest->i_atime = src->i_atime;
> -       dest->i_mtime = src->i_mtime;
> -       dest->i_ctime = src->i_ctime;
> -       dest->i_blkbits = src->i_blkbits;
> -       dest->i_flags = src->i_flags;
> -}

This is the fsstack copy_attr_all:

> +void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
> +                               int (*get_nlinks)(struct inode *))
> +{
> +       if (!get_nlinks)
> +               dest->i_nlink = src->i_nlink;
> +       else
> +               dest->i_nlink = (*get_nlinks)(dest);
> +
> +       dest->i_mode = src->i_mode;
> +       dest->i_uid = src->i_uid;
> +       dest->i_gid = src->i_gid;
> +       dest->i_rdev = src->i_rdev;
> +       dest->i_atime = src->i_atime;
> +       dest->i_mtime = src->i_mtime;
> +       dest->i_ctime = src->i_ctime;
> +       dest->i_blkbits = src->i_blkbits;
> +       dest->i_flags = src->i_flags;
> +
> +       fsstack_copy_inode_size(dest, src);
> +}

The addition of copy_inode_size breaks eCryptfs, since eCryptfs needs to
interpolate the file sizes (eCryptfs has extra space in the lower file for
the header).  The setting of the upper inode size occurs elsewhere in
eCryptfs, and the new copy_attr_all now undoes what eCryptfs was doing
right beforehand.

I see three ways of going forward from here.  (1) Something like this patch
needs to go in (assuming it jives with Unionfs), (2) we need to make a
change to the fsstack API for more fine-grained control over copying
attributes (e.g., by also including a callback function for calculating the
right file size, which will require some more work on both eCryptfs and
Unionfs), or (3) the fsstack patch on eCryptfs (commit
0cc72dc7f050188d8d7344b1dd688cbc68d3cd30 made on Fri Dec 8 02:36:31 2006
-0800) needs to be yanked in 2.6.20.

I think the simplest solution, from eCryptfs' perspective, is to just
remove the inode size copy.


Remove inode size copy in general fsstack attr copy code. Stacked
filesystems may need to interpolate the inode size, since the file
size in the lower file may be different than the file size in the
stacked layer.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/stack.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN fs/stack.c~fsstack-remove-inode-copy fs/stack.c
--- a/fs/stack.c~fsstack-remove-inode-copy
+++ a/fs/stack.c
@@ -34,7 +34,5 @@ void fsstack_copy_attr_all(struct inode 
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
-
-	fsstack_copy_inode_size(dest, src);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

fsstack-remove-inode-copy.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch

