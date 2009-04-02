From: akpm@linux-foundation.org
Subject: [folded] vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 12:42:40 -0700
Message-ID: <200904021942.n32Jgfg3013303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZDBTsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 15:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, adilger@sun.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix
has been removed from the -mm tree.  Its filename was
     vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch

This patch was dropped because it was folded into vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix
From: Sage Weil <sage@newdream.net>

On Tue, 10 Mar 2009, Miklos Szeredi wrote:

> The patch is wrong in case ->d_revalidate is NULL.
>
> Something like this should fix it up:
>
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2009-03-10 20:03:58.000000000 +0100
> +++ linux-2.6/fs/namei.c	2009-03-10 20:19:29.000000000 +0100
> @@ -501,6 +501,8 @@ static struct dentry * real_lookup(struc
>  			 * The dentry was left behind invalid.  Just
>  			 * do the lookup.
>  			 */
> +		} else {
> +			goto out_unlock;
>  		}
>  	}
>

Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix fs/namei.c
--- a/fs/namei.c~vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix
+++ a/fs/namei.c
@@ -502,6 +502,8 @@ static struct dentry * real_lookup(struc
 			 * The dentry was left behind invalid.  Just
 			 * do the lookup.
 			 */
+		} else {
+			goto out_unlock;
 		}
 	}
 
@@ -514,9 +516,9 @@ static struct dentry * real_lookup(struc
 	result = ERR_PTR(-ENOMEM);
 	if (dentry) {
 		result = dir->i_op->lookup(dir, dentry, nd);
-		if (result) {
+		if (result)
 			dput(dentry);
-		} else
+		else
 			result = dentry;
 	}
 out_unlock:
_

Patches currently in -mm which might be from sage@newdream.net are

vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch

