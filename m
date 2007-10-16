From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-unnecessary-bug_on.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:27 -0700
Message-ID: <200710162040.l9GKeRCh015691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965868AbXJPVAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:00:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove unnecessary BUG_ON
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-unnecessary-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: remove unnecessary BUG_ON
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +     mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
> > +     BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
> > +     mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
>
> That's odd-looking.  If it was a bug for num_global_auth_toks to be
> zero, and if that mutex protects num_global_auth_toks then as soon
> as the lock gets dropped, another thread can make
> num_global_auth_toks zero, hence the bug is present.  Perhaps?

That was serving as an internal sanity check that should not have made
it into the final patch set in the first place. This patch removes it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-unnecessary-bug_on fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-unnecessary-bug_on
+++ a/fs/ecryptfs/crypto.c
@@ -1029,9 +1029,6 @@ int ecryptfs_new_file_context(struct den
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
-	BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
-	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
 	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
