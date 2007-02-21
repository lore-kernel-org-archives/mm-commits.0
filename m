From: akpm@linux-foundation.org
Subject: - autofs4-check-for-directory-re-create-in-lookup.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:16 -0800
Message-ID: <200702211046.l1LAkG92006454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbXBUKq1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: check for directory re-create in lookup
has been removed from the -mm tree.  Its filename was
     autofs4-check-for-directory-re-create-in-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs4: check for directory re-create in lookup
From: Ian Kent <raven@themaw.net>

This problem was identified and fixed some time ago by Jeff Moyer but it fell
through the cracks somehow.

It is possible that a user space application could remove and re-create a
directory during a request.  To avoid returning a failure from lookup
incorrectly when our current dentry is unhashed we need to check if another
positive, hashed dentry matching this one exists and if so return it instead
of a fail.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-check-for-directory-re-create-in-lookup fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-check-for-directory-re-create-in-lookup
+++ a/fs/autofs4/root.c
@@ -655,14 +655,29 @@ static struct dentry *autofs4_lookup(str
 
 	/*
 	 * If this dentry is unhashed, then we shouldn't honour this
-	 * lookup even if the dentry is positive.  Returning ENOENT here
-	 * doesn't do the right thing for all system calls, but it should
-	 * be OK for the operations we permit from an autofs.
+	 * lookup.  Returning ENOENT here doesn't do the right thing
+	 * for all system calls, but it should be OK for the operations
+	 * we permit from an autofs.
 	 */
 	if (dentry->d_inode && d_unhashed(dentry)) {
+		/*
+		 * A user space application can (and has done in the past)
+		 * remove and re-create this directory during the callback.
+		 * This can leave us with an unhashed dentry, but a
+		 * successful mount!  So we need to perform another
+		 * cached lookup in case the dentry now exists.
+		 */
+		struct dentry *parent = dentry->d_parent;
+		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		if (new != NULL)
+			dentry = new;
+		else
+			dentry = ERR_PTR(-ENOENT);
+
 		if (unhashed)
 			dput(unhashed);
-		return ERR_PTR(-ENOENT);
+
+		return dentry;
 	}
 
 	if (unhashed)
_

Patches currently in -mm which might be from raven@themaw.net are
