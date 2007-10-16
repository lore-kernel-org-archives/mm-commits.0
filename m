From: akpm@linux-foundation.org
Subject: - smb-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:07 -0700
Message-ID: <200710162033.l9GKX7lc014759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935407AbXJPViw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     smbfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     smb-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smbfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/file.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff -puN fs/smbfs/file.c~smb-convert-to-new-aops fs/smbfs/file.c
--- a/fs/smbfs/file.c~smb-convert-to-new-aops
+++ a/fs/smbfs/file.c
@@ -292,29 +292,45 @@ out:
  * If the writer ends up delaying the write, the writer needs to
  * increment the page use counts until he is done with the page.
  */
-static int smb_prepare_write(struct file *file, struct page *page, 
-			     unsigned offset, unsigned to)
-{
+static int smb_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	*pagep = __grab_cache_page(mapping, index);
+	if (!*pagep)
+		return -ENOMEM;
 	return 0;
 }
 
-static int smb_commit_write(struct file *file, struct page *page,
-			    unsigned offset, unsigned to)
+static int smb_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
 	int status;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 
-	status = -EFAULT;
 	lock_kernel();
-	status = smb_updatepage(file, page, offset, to-offset);
+	status = smb_updatepage(file, page, offset, copied);
 	unlock_kernel();
+
+	if (!status) {
+		if (!PageUptodate(page) && copied == PAGE_CACHE_SIZE)
+			SetPageUptodate(page);
+		status = copied;
+	}
+
+	unlock_page(page);
+	page_cache_release(page);
+
 	return status;
 }
 
 const struct address_space_operations smb_file_aops = {
 	.readpage = smb_readpage,
 	.writepage = smb_writepage,
-	.prepare_write = smb_prepare_write,
-	.commit_write = smb_commit_write
+	.write_begin = smb_write_begin,
+	.write_end = smb_write_end,
 };
 
 /* 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
