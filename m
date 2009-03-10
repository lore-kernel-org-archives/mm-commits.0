From: akpm@linux-foundation.org
Subject: + vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:57:06 -0700
Message-ID: <200903102257.n2AMv79D015119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZCJXA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 19:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sage@newdream.net, adilger@sun.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, yehuda@newdream.net


The patch titled
     vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix
has been added to the -mm tree.  Its filename is
     vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-checkpatch-fixes.patch

