From: akpm@linux-foundation.org
Subject: + autofs4-eliminate-d_unhashed-in-path-walk-checks.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:35 -0700
Message-ID: <200910062050.n96KoZN3009801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbZJFUvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: eliminate d_unhashed in path walk checks
has been added to the -mm tree.  Its filename is
     autofs4-eliminate-d_unhashed-in-path-walk-checks.patch

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

vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch
autofs4-use-helper-functions-for-active-list-handling.patch
autofs4-use-helper-functions-for-expiring-list.patch
autofs4-use-helper-function-for-need-mount-check.patch
autofs4-use-autofs_info-for-pending-flag.patch
autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch
autofs4-cleanup-active-and-expire-lookup.patch
autofs4-eliminate-d_unhashed-in-path-walk-checks.patch
autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch
autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch
autofs4-always-use-lookup-for-lookup.patch

