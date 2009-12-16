From: akpm@linux-foundation.org
Subject: [merged] autofs4-eliminate-d_unhashed-in-path-walk-checks.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:56 -0800
Message-ID: <200912162033.nBGKXuVs012984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763023AbZLPUeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: eliminate d_unhashed in path walk checks
has been removed from the -mm tree.  Its filename was
     autofs4-eliminate-d_unhashed-in-path-walk-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: eliminate d_unhashed in path walk checks
From: Ian Kent <raven@themaw.net>

We unhash the dentry (in a subsequent patch) in ->d_revalidate() in order
to send mount requests to ->lookup().  But then we can not rely on
d_unhased() to give reliable results because it may be called at any time
by any code path.  The d_unhashed() function is used by __simple_empty()
in the path walking callbacks but autofs mount point dentrys should have
no directories at all so a list_empty() on d_subdirs should be (and is)
sufficient.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-eliminate-d_unhashed-in-path-walk-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-eliminate-d_unhashed-in-path-walk-checks
+++ a/fs/autofs4/root.c
@@ -133,7 +133,7 @@ static int autofs4_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&dcache_lock);
-	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
+	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dcache_lock);
 		return -ENOENT;
 	}
@@ -257,7 +257,7 @@ static void *autofs4_follow_link(struct 
 	 * mount it again.
 	 */
 	if (ino->flags & AUTOFS_INF_PENDING ||
-	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
+	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 
@@ -340,8 +340,7 @@ static int autofs4_revalidate(struct den
 	/* Check for a non-mountpoint directory with no contents */
 	spin_lock(&dcache_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
-	    !d_mountpoint(dentry) && 
-	    __simple_empty(dentry)) {
+	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dcache_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

