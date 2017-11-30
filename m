From: akpm@linux-foundation.org
Subject: [merged]
 autofs-revert-take-more-care-to-not-update-last_used-on-path-walk.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:20 -0800
Message-ID: <20171130201920._cSNm4zN3%akpm__27334.3933084563$1512073166$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbdK3UTV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oholy@redhat.com, raven@themaw.net, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, walters@redhat.com


The patch titled
     Subject: autofs: revert "autofs: take more care to not update last_used on path walk"
has been removed from the -mm tree.  Its filename was
     autofs-revert-take-more-care-to-not-update-last_used-on-path-walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: revert "autofs: take more care to not update last_used on path walk"

While 092a53452b ("autofs: take more care to not update last_used on path
walk") helped (partially) resolve a problem where automounts were not
expiring due to aggressive accesses from user space it has a side effect
for very large environments.

This change helps with the expire problem by making the expire more
aggressive but, for very large environments, that means more mount
requests from clients.  When there are a lot of clients that can mean
fairly significant server load increases.

It turns out I put the last_used in this position to solve this very
problem and failed to update my own thinking of the autofs expire policy. 
So the patch being reverted introduces a regression which should be fixed.

Link: http://lkml.kernel.org/r/151174729420.6162.1832622523537052460.stgit@pluto.themaw.net
Fixes: 092a53452b ("autofs: take more care to not update last_used on path walk")
Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: NeilBrown <neilb@suse.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@vger.kernel.org>	[4.11+]
Cc: Colin Walters <walters@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ondrej Holy <oholy@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN fs/autofs4/root.c~autofs-revert-take-more-care-to-not-update-last_used-on-path-walk fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-revert-take-more-care-to-not-update-last_used-on-path-walk
+++ a/fs/autofs4/root.c
@@ -281,8 +281,8 @@ static int autofs4_mount_wait(const stru
 		pr_debug("waiting for mount name=%pd\n", path->dentry);
 		status = autofs4_wait(sbi, path, NFY_MOUNT);
 		pr_debug("mount wait done status=%d\n", status);
-		ino->last_used = jiffies;
 	}
+	ino->last_used = jiffies;
 	return status;
 }
 
@@ -321,21 +321,16 @@ static struct dentry *autofs4_mountpoint
 	 */
 	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
 		struct dentry *parent = dentry->d_parent;
+		struct autofs_info *ino;
 		struct dentry *new;
 
 		new = d_lookup(parent, &dentry->d_name);
 		if (!new)
 			return NULL;
-		if (new == dentry)
-			dput(new);
-		else {
-			struct autofs_info *ino;
