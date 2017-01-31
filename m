From: akpm@linux-foundation.org
Subject: +
 autofs-take-more-care-to-not-update-last_used-on-path-walk.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 15:48:06 -0800
Message-ID: <58912236.FavLnP2RH+EYgp0q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdAaX5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, tkusumi@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: take more care to not update last_used on path walk
has been added to the -mm tree.  Its filename is
     autofs-take-more-care-to-not-update-last_used-on-path-walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-take-more-care-to-not-update-last_used-on-path-walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-take-more-care-to-not-update-last_used-on-path-walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: take more care to not update last_used on path walk

GUI environments seem to be becoming more agressive at scanning
filesystems, to the point where autofs cannot expire mounts at all.

This is one key reason the update of the autofs dentry info last_used
field is done in the expire system when the dentry is seen to be in use.

But somewhere along the way instances of the update has crept back into
the autofs path walk functions which, with the more aggressive file access
patterns, is preventing expiration.

Changing the update in the path walk functions allows autofs to at least
make progress in spite of frequent immediate re-mounts from file accesses.

Link: http://lkml.kernel.org/r/148577167169.9801.1377050092212016834.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/root.c~autofs-take-more-care-to-not-update-last_used-on-path-walk fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-take-more-care-to-not-update-last_used-on-path-walk
+++ a/fs/autofs4/root.c
@@ -281,8 +281,8 @@ static int autofs4_mount_wait(const stru
 		pr_debug("waiting for mount name=%pd\n", path->dentry);
 		status = autofs4_wait(sbi, path, NFY_MOUNT);
 		pr_debug("mount wait done status=%d\n", status);
+		ino->last_used = jiffies;
 	}
-	ino->last_used = jiffies;
 	return status;
 }
 
@@ -321,16 +321,21 @@ static struct dentry *autofs4_mountpoint
 	 */
 	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
 		struct dentry *parent = dentry->d_parent;
-		struct autofs_info *ino;
 		struct dentry *new;
 
 		new = d_lookup(parent, &dentry->d_name);
 		if (!new)
 			return NULL;
-		ino = autofs4_dentry_ino(new);
-		ino->last_used = jiffies;
-		dput(path->dentry);
-		path->dentry = new;
+		if (new == dentry)
+			dput(new);
+		else {
+			struct autofs_info *ino;
+
+			ino = autofs4_dentry_ino(new);
+			ino->last_used = jiffies;
+			dput(path->dentry);
+			path->dentry = new;
+		}
 	}
 	return path->dentry;
 }
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-take-more-care-to-not-update-last_used-on-path-walk.patch

