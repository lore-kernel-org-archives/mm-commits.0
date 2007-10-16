From: akpm@linux-foundation.org
Subject: - ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:54:45 -0700
Message-ID: <200710160454.l9G4sjfR009706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbXJPEyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Convert mmap functions to use persistent file (fix)
has been removed from the -mm tree.  Its filename was
     ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch

This patch was dropped because it was folded into ecryptfs-convert-mmap-functions-to-use-persistent-file.patch

------------------------------------------------------
Subject: eCryptfs: Convert mmap functions to use persistent file (fix)
From: Michael Halcrow <mhalcrow@us.ibm.com>

On Wed, Sep 19, 2007 at 10:50:57PM -0700, Andrew Morton wrote:
> On Mon, 17 Sep 2007 16:50:16 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +ecryptfs_copy_up_encrypted_with_header(struct page *page,
> > +				       struct ecryptfs_crypt_stat *crypt_stat)
> > +{
...
> > +			flush_dcache_page(page);
> > +			if (rc) {
> > +				ClearPageUptodate(page);
> > +				printk(KERN_ERR "%s: Error reading xattr "
> > +				       "region; rc = [%d]\n", __FUNCTION__, rc);
> > +				goto out;
> > +			}
> > +			SetPageUptodate(page);
>
> I don't know what sort of page `page' refers to here, but normally we only
> manipulate the page uptodate status under lock_page().

This is the page that eCryptfs gets via
ecryptfs_aops->ecryptfs_readpage(), so this should be okay. The
comment should make the fact that the page is locked explicit.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-convert-mmap-functions-to-use-persistent-file-fix fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-convert-mmap-functions-to-use-persistent-file-fix
+++ a/fs/ecryptfs/mmap.c
@@ -270,7 +270,7 @@ static void set_header_info(char *page_v
  * ecryptfs_copy_up_encrypted_with_header
  * @page: Sort of a ``virtual'' representation of the encrypted lower
  *        file. The actual lower file does not have the metadata in
- *        the header.
+ *        the header. This is locked.
  * @crypt_stat: The eCryptfs inode's cryptographic context
  *
  * The ``view'' is the version of the file that userspace winds up
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

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
ecryptfs-fix-error-handling.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch
ecryptfs-fix-data-types.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
ecryptfs-clean-up-page-flag-handling.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
