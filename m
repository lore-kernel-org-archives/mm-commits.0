From: akpm@linux-foundation.org
Subject: + vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:40:37 -0700
Message-ID: <200909302040.n8UKeb5L012979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbZI3Ulb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sage@newdream.net, adilger@sun.com, hch@infradead.org, raven@themaw.net, viro@zeniv.linux.org.uk, yehuda@newdream.net


The patch titled
     vfs: make real_lookup do dentry revalidation with i_mutex held
has been added to the -mm tree.  Its filename is
     vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch

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
Subject: vfs: make real_lookup do dentry revalidation with i_mutex held
From: Sage Weil <sage@newdream.net>

real_lookup() is called by do_lookup() if dentry revalidation fails.  If
the cache is re-populated while waiting for i_mutex, it may find that a
d_lookup() subsequently succeeds (see the "Uhhuh!  Nasty case" comment).

Previously, real_lookup() would drop i_mutex and do_revalidate() again. 
If revalidate failed _again_, however, it would give up with -ENOENT.  The
problem here that network file systems may be invalidating dentries via
server callbacks, e.g.  due to concurrent access from another client, and
-ENOENT is frequently the wrong answer.

This problem has been seen with both Lustre and Ceph.  It seems possible
to hit this case with NFS as well if the cache lifetime is very short.

Instead, we should do_revalidate() while i_mutex is still held.  If
revalidation fails, we can move on to a ->lookup() and ensure a correct
result without worrying about any subsequent races.

Note that do_revalidate() is called with i_mutex held elsewhere.  For
example, do_filp_open(), lookup_create(), do_unlinkat(), do_rmdir(), and
possibly others all take the directory i_mutex, and then

-> lookup_hash
        -> __lookup_hash
                -> cached_lookup
                        -> do_revalidate

so this does not introduce any new locking rules for d_revalidate
implementations.

Yes, the goto is ugly.  A cleanup patch follows.

Cc: Ian Kent <raven@themaw.net>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held fs/namei.c
--- a/fs/namei.c~vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held
+++ a/fs/namei.c
@@ -497,6 +497,7 @@ static struct dentry * real_lookup(struc
 	if (!result) {
 		struct dentry *dentry;
 
+do_the_lookup:
 		/* Don't create child dentry for a dead directory. */
 		result = ERR_PTR(-ENOENT);
 		if (IS_DEADDIR(dir))
@@ -520,12 +521,12 @@ out_unlock:
 	 * Uhhuh! Nasty case: the cache was re-populated while
 	 * we waited on the semaphore. Need to revalidate.
 	 */
-	mutex_unlock(&dir->i_mutex);
 	if (result->d_op && result->d_op->d_revalidate) {
 		result = do_revalidate(result, nd);
 		if (!result)
-			result = ERR_PTR(-ENOENT);
+			goto do_the_lookup;
 	}
+	mutex_unlock(&dir->i_mutex);
 	return result;
 }
 
_

Patches currently in -mm which might be from sage@newdream.net are

vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

