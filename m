From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:32 -0700
Message-ID: <200706260346.l5Q3kWcE017644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbXFZDqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: meelap@umich.edu, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: don't delegate files that have had conflicts
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: don't delegate files that have had conflicts
From: Meelap Shah <meelap@umich.edu>

One more incremental delegation policy improvement: don't give out a
delegation on a file if conflicting access has previously required that a
delegation be revoked on that file.  (In practice we'll forget about the
conflict when the struct nfs4_file is removed on close, so this is of limited
use for now, though it should at least solve a temporary problem with
self-conflicts on write opens from the same client.)

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c        |    4 ++++
 include/linux/nfsd/state.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts
+++ a/fs/nfsd/nfs4state.c
@@ -194,6 +194,8 @@ alloc_init_deleg(struct nfs4_client *clp
 	struct nfs4_callback *cb = &stp->st_stateowner->so_client->cl_callback;
 
 	dprintk("NFSD alloc_init_deleg\n");
+	if (fp->fi_had_conflict)
+		return NULL;
 	if (num_delegations > max_delegations)
 		return NULL;
 	dp = kmem_cache_alloc(deleg_slab, GFP_KERNEL);
@@ -1002,6 +1004,7 @@ alloc_init_file(struct inode *ino)
 		list_add(&fp->fi_hash, &file_hashtbl[hashval]);
 		fp->fi_inode = igrab(ino);
 		fp->fi_id = current_fileid++;
+		fp->fi_had_conflict = false;
 		return fp;
 	}
 	return NULL;
@@ -1328,6 +1331,7 @@ do_recall(void *__dp)
 {
 	struct nfs4_delegation *dp = __dp;
 
+	dp->dl_file->fi_had_conflict = true;
 	nfsd4_cb_recall(dp);
 	return 0;
 }
diff -puN include/linux/nfsd/state.h~knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts include/linux/nfsd/state.h
--- a/include/linux/nfsd/state.h~knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts
+++ a/include/linux/nfsd/state.h
@@ -224,6 +224,7 @@ struct nfs4_file {
 	struct inode		*fi_inode;
 	u32                     fi_id;      /* used with stateowner->so_id 
 					     * for stateid_hashtbl hash */
+	bool			fi_had_conflict;
 };
 
 /*
_

Patches currently in -mm which might be from meelap@umich.edu are

knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
