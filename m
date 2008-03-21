From: akpm@linux-foundation.org
Subject: - romfs-fix-up-an-error-in-iget-removal.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:25 -0700
Message-ID: <200803212029.m2LKTPfA008866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758992AbYCUUaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, adam@yggdrasil.com, mm-commits@vger.kernel.org


The patch titled
     ROMFS: Fix up an error in iget removal
has been removed from the -mm tree.  Its filename was
     romfs-fix-up-an-error-in-iget-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ROMFS: Fix up an error in iget removal
From: David Howells <dhowells@redhat.com>

Fix up an error in iget removal in which romfs_lookup() making a successful
call to romfs_iget() continues through the negative/error handling (previously
the successful case jumped around the negative/error handling case):

 (1) inode is initialised to NULL at the top of the function, eliminating the
     need for specific negative-inode handling.  This means the positive
     success handling now flows straight through.

 (2) Rename the labels to be clearer about what they mean.

Also make romfs_lookup()'s result variable of type long so as to avoid
32-bit/64-bit conversions with PTR_ERR() and friends.

Based upon a report and patch from Adam Richter.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Adam J. Richter" <adam@yggdrasil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN fs/romfs/inode.c~romfs-fix-up-an-error-in-iget-removal fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-fix-up-an-error-in-iget-removal
+++ a/fs/romfs/inode.c
@@ -340,8 +340,9 @@ static struct dentry *
 romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	unsigned long offset, maxoff;
-	int fslen, res;
-	struct inode *inode;
+	long res;
+	int fslen;
+	struct inode *inode = NULL;
 	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
 	struct romfs_inode ri;
 	const char *name;		/* got from dentry */
@@ -351,7 +352,7 @@ romfs_lookup(struct inode *dir, struct d
 	offset = dir->i_ino & ROMFH_MASK;
 	lock_kernel();
 	if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-		goto out;
+		goto error;
 
 	maxoff = romfs_maxsize(dir->i_sb);
 	offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
@@ -364,9 +365,9 @@ romfs_lookup(struct inode *dir, struct d
 
 	for(;;) {
 		if (!offset || offset >= maxoff)
-			goto out0;
+			goto success; /* negative success */
 		if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-			goto out;
+			goto error;
 
 		/* try to match the first 16 bytes of name */
 		fslen = romfs_strnlen(dir, offset+ROMFH_SIZE, ROMFH_SIZE);
@@ -397,23 +398,14 @@ romfs_lookup(struct inode *dir, struct d
 	inode = romfs_iget(dir->i_sb, offset);
 	if (IS_ERR(inode)) {
 		res = PTR_ERR(inode);
-		goto out;
+		goto error;
 	}
 
-	/*
-	 * it's a bit funky, _lookup needs to return an error code
-	 * (negative) or a NULL, both as a dentry.  ENOENT should not
-	 * be returned, instead we need to create a negative dentry by
-	 * d_add(dentry, NULL); and return 0 as no error.
-	 * (Although as I see, it only matters on writable file
-	 * systems).
-	 */
-
-out0:	inode = NULL;
+success:
+	d_add(dentry, inode);
 	res = 0;
-	d_add (dentry, inode);
-
-out:	unlock_kernel();
+error:
+	unlock_kernel();
 	return ERR_PTR(res);
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

