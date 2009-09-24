From: akpm@linux-foundation.org
Subject: [to-be-updated] ext2-convert-to-use-the-new-truncate-convention-fix.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:32:22 -0700
Message-ID: <200909241932.n8OJWMP6026627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbZIXTcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext2: convert to use the new truncate convention fix
has been removed from the -mm tree.  Its filename was
     ext2-convert-to-use-the-new-truncate-convention-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: convert to use the new truncate convention fix
From: Nick Piggin <npiggin@suse.de>

On Fri, Aug 21, 2009 at 04:06:59PM +0200, Jan Kara wrote:
> >   Hi,
> >
> > > I also have commented a possible bug in existing ext2 code, marked with XXX.
> >   Looks good, except:
> >
> > > +int ext2_setsize(struct inode *inode, loff_t newsize)
> >   This could be static.
> >
> > > @@ -1459,8 +1540,15 @@ int ext2_setattr(struct dentry *dentry,
> > >  		if (error)
> > >  			return error;
> > >  	}
> > > -	error = inode_setattr(inode, iattr);
> > > +	if (iattr->ia_valid & ATTR_SIZE) {
> > > +		error = ext2_setsize(inode, iattr->ia_size);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > > +	generic_setattr(inode, iattr);
> >   Here, we should store the error code I suppose...
>   Ah, I was confused. generic_setattr() returns void. But then remove
> the check !error from:
>   if (!error && (iattr->ia_valid & ATTR_MODE))
> which just follows the generic_setattr(). That's what made me think
> generic_setattr() returns something :)

Yep, good suggestion.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/inode.c~ext2-convert-to-use-the-new-truncate-convention-fix fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-convert-to-use-the-new-truncate-convention-fix
+++ a/fs/ext2/inode.c
@@ -1548,7 +1548,7 @@ int ext2_setattr(struct dentry *dentry, 
 			return error;
 	}
 	generic_setattr(inode, iattr);
-	if (!error && (iattr->ia_valid & ATTR_MODE))
+	if (iattr->ia_valid & ATTR_MODE)
 		error = ext2_acl_chmod(inode);
 	mark_inode_dirty(inode);
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

