From: akpm@linux-foundation.org
Subject: - autofs4-fix-execution-order-race-in-mount-request-code.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:12 -0700
Message-ID: <200805021943.m42JhC6L011268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758493AbYEBTv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix execution order race in mount request code
has been removed from the -mm tree.  Its filename was
     autofs4-fix-execution-order-race-in-mount-request-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix execution order race in mount request code
From: Jeff Moyer <jmoyer@redhat.com>

Jeff Moyer has identified a race in due to an execution order dependency
in the autofs4 function root.c:try_to_fill_dentry().

Jeff's description of this race is:

"P1 does a lookup of /mount/submount/foo.  Since the VFS can't find an entry
for "foo" under /mount/submount, it calls into the autofs4 kernel module to
allocate a new dentry, D1.  The kernel creates a new waitq for this lookup and
calls the daemon to perform the mount.

The daemon performs a mkdir of the "foo" directory under /mount/submount,
which ends up creating a *new* dentry, D2.

Then, P2 does a lookup of /mount/submount/foo.  The VFS path walking logic
finds a dentry in the dcache, D2, and calls the revalidate function with this.
 In the autofs4 revalidate code, we then trigger a mount, since the dentry is
an empty directory that isn't a mountpoint, and so set DCACHE_AUTOFS_PENDING
and call into the wait code to trigger the mount.

The wait code finds our existing waitq entry (since it is keyed off of the
directory name) and adds itself to the list of waiters.

After the daemon finishes the mount, it calls back into the kernel to release
the waiters.  When this happens, P1 is woken up and goes about clearing the
DCACHE_AUTOFS_PENDING flag, but it does this in D1!  So, given that P1 in our
case is a program that will immediately try to access a file under
/mount/submount/foo, we end up finding the dentry D2 which still has the
pending flag set, and we set out to wait for a mount *again*!

So, one way to address this is to re-do the lookup at the end of
try_to_fill_dentry, and to clear the pending flag on the hashed dentry.  This
seems a sane approach to me."

And Jeff's patch does this.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/autofs4/root.c~autofs4-fix-execution-order-race-in-mount-request-code fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-execution-order-race-in-mount-request-code
+++ a/fs/autofs4/root.c
@@ -242,6 +242,7 @@ static int try_to_fill_dentry(struct den
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct dentry *new;
 	int status = 0;
 
 	/* Block on any pending expiry here; invalidate the dentry
@@ -318,6 +319,27 @@ static int try_to_fill_dentry(struct den
 	spin_lock(&dentry->d_lock);
 	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 	spin_unlock(&dentry->d_lock);
+
+	/*
+	 * The dentry that is passed in from lookup may not be the one
+	 * we end up using, as mkdir can create a new one.  If this
+	 * happens, and another process tries the lookup at the same time,
+	 * it will set the PENDING flag on this new dentry, but add itself
+	 * to our waitq.  Then, if after the lookup succeeds, the first
+	 * process that requested the mount performs another lookup of the
+	 * same directory, it will show up as still pending!  So, we need
+	 * to redo the lookup here and clear pending on that dentry.
+	 */
+	if (d_unhashed(dentry)) {
+		new = d_lookup(dentry->d_parent, &dentry->d_name);
+		if (new) {
+			spin_lock(&new->d_lock);
+			new->d_flags &= ~DCACHE_AUTOFS_PENDING;
+			spin_unlock(&new->d_lock);
+			dput(new);
+		}
+	}
+
 	return status;
 }
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch

