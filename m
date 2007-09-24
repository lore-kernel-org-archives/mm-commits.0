From: akpm@linux-foundation.org
Subject: + ecryptfs-update-metadata-read-write-functions-cleanup.patch added to -mm tree
Date: Mon, 24 Sep 2007 15:57:59 -0700
Message-ID: <200709242257.l8OMvxMY021935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754AbXIXW6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 18:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: Update metadata read/write functions (cleanup)
has been added to the -mm tree.  Its filename is
     ecryptfs-update-metadata-read-write-functions-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: Update metadata read/write functions (cleanup)
From: Michael Halcrow <mhalcrow@us.ibm.com>

On Wed, Sep 19, 2007 at 10:48:17PM -0700, Andrew Morton wrote:
> On Mon, 17 Sep 2007 16:48:44 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
>
> checkpatch missed the assignment-in-an-if here.

Fix an assignment-in-an-if.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-update-metadata-read-write-functions-cleanup fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-update-metadata-read-write-functions-cleanup
+++ a/fs/ecryptfs/crypto.c
@@ -1455,8 +1455,9 @@ ecryptfs_write_metadata_to_contents(stru
 	int header_pages;
 	int rc;
 
-	if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
-				       0, PAGE_CACHE_SIZE))) {
+	rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
+				  0, PAGE_CACHE_SIZE);
+	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to write header "
 		       "information to lower file; rc = [%d]\n", __FUNCTION__,
 		       rc);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-update-metadata-read-write-functions-cleanup.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch
ecryptfs-fix-data-types.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
