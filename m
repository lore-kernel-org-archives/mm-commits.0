From: akpm@linux-foundation.org
Subject: - ecryptfs-initialize-new-auth_tokens-before-teardown.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:35:54 -0800
Message-ID: <200712202335.lBKNZstM018755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbXLTXgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: initialize new auth_tokens before teardown
has been removed from the -mm tree.  Its filename was
     ecryptfs-initialize-new-auth_tokens-before-teardown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: initialize new auth_tokens before teardown
From: Eric Sandeen <sandeen@redhat.com>

ecryptfs_destroy_mount_crypt_stat() checks whether each
auth_tok->global_auth_tok_key is nonzero and if so puts that key.  However,
in some early mount error paths nothing has initialized the pointer, and we
try to key_put() garbage.  Running the bad cipher tests in the testsuite
exposes this, and it's happy with the following change.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-initialize-new-auth_tokens-before-teardown fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-initialize-new-auth_tokens-before-teardown
+++ a/fs/ecryptfs/keystore.c
@@ -1860,7 +1860,7 @@ ecryptfs_add_global_auth_tok(struct ecry
 	struct ecryptfs_global_auth_tok *new_auth_tok;
 	int rc = 0;
 
-	new_auth_tok = kmem_cache_alloc(ecryptfs_global_auth_tok_cache,
+	new_auth_tok = kmem_cache_zalloc(ecryptfs_global_auth_tok_cache,
 					GFP_KERNEL);
 	if (!new_auth_tok) {
 		rc = -ENOMEM;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext3-change-the-default-behaviour-on-error.patch
