From: akpm@linux-foundation.org
Subject: - ecryptfs-collapse-flag-set-into-one-statement.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:29 -0700
Message-ID: <200710162040.l9GKeT9w015694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965905AbXJPU6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: collapse flag set into one statement
has been removed from the -mm tree.  Its filename was
     ecryptfs-collapse-flag-set-into-one-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: collapse flag set into one statement
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +     crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
> > +     crypt_stat->flags |= ECRYPTFS_KEY_VALID;
>
> Maybe the compiler can optimise those two statements, but we'd
> normally provide it with some manual help.

This patch provides the compiler with some manual help for
optimizing the setting of some flags.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-collapse-flag-set-into-one-statement fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-collapse-flag-set-into-one-statement
+++ a/fs/ecryptfs/crypto.c
@@ -1029,8 +1029,7 @@ int ecryptfs_new_file_context(struct den
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
-	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
+	crypt_stat->flags |= (ECRYPTFS_ENCRYPTED | ECRYPTFS_KEY_VALID);
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
 						      mount_crypt_stat);
 	rc = ecryptfs_copy_mount_wide_sigs_to_inode_sigs(crypt_stat,
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
