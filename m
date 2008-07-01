From: akpm@linux-foundation.org
Subject: + autofs4-use-lookup-intent-flags-to-trigger-mounts.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:05:35 -0700
Message-ID: <200807010705.m6175Zs7014114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbYGAHFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     From: Ian Kent <raven@themaw.net>
has been added to the -mm tree.  Its filename is
     autofs4-use-lookup-intent-flags-to-trigger-mounts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Ian Kent <raven@themaw.net>


When an open(2) call is made on an autofs mount point directory that
already exists and the O_DIRECTORY flag is not used the needed mount
callback to the daemon is not done. This leads to the path walk
continuing resulting in a callback to the daemon with an incorrect
key. open(2) is called without O_DIRECTORY by the "find" utility but
this should be handled properly anyway.

This happens because autofs needs to use the lookup flags to decide
when to callback to the daemon to perform a mount to prevent mount
storms. For example, an autofs indirect mount map that has the "browse"
option will have the mount point directories are pre-created and the
stat(2) call made by a color ls against each directory will cause all
these directories to be mounted. It is unfortunate we need to resort
to this but mount maps can be quite large. Additionally, if a user
manually umounts an autofs indirect mount the directory isn't removed
which also leads to this situation.

To resolve this autofs needs to use the lookup intent flags to enable
it to make this decision. This patch adds this check and triggers a
call back if any of the lookup intent flags are set as all these calls
warrant a mount attempt be requested.

I know that external VFS code which uses the lookup flags is something
that the VFS would like to eliminate but I have no choice as I can't
see any other way to do this. A VFS dentry or inode operation callback
which returns the lookup "type" (requires a definition) would be
sufficient. But this change is needed now and I'm not aware of the form
that coming VFS changes will take so I'm not willing to propose anything
along these lines.

If anyone can provide an alternate method I would be happy to use it.

Signed-off-by: Ian Kent <raven@themaw.net>

---

index 236eb9b..7f3ebf1 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-use-lookup-intent-flags-to-trigger-mounts fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-lookup-intent-flags-to-trigger-mounts
+++ a/fs/autofs4/root.c
@@ -31,6 +31,9 @@ static int autofs4_root_readdir(struct f
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
+#define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
+#define TRIGGER_INTENTS (LOOKUP_OPEN | LOOKUP_ACCESS | LOOKUP_CREATE)
+
 const struct file_operations autofs4_root_operations = {
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
@@ -291,7 +294,7 @@ static int try_to_fill_dentry(struct den
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY) ||
+	} else if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -336,7 +339,7 @@ static void *autofs4_follow_link(struct 
 		nd->flags);
 
 	/* If it's our master or we shouldn't trigger a mount we're done */
-	lookup_type = nd->flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY);
+	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (oz_mode || !lookup_type)
 		goto done;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-pending-mount-race.patch

