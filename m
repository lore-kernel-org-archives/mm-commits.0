From: akpm@linux-foundation.org
Subject: + ecryptfs-initialize-new-auth_tokens-before-teardown.patch added to -mm tree
Date: Tue, 11 Dec 2007 16:03:55 -0800
Message-ID: <200712120003.lBC03ti5015906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbXLLAFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 19:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: initialize new auth_tokens before teardown
has been added to the -mm tree.  Its filename is
     ecryptfs-initialize-new-auth_tokens-before-teardown.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ext2-change-the-default-behaviour-on-error.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch
