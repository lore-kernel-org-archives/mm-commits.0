From: akpm@linux-foundation.org
Subject: [merged] afs-stop-readlink-on-afs-crashing-because-file-not-passed-to-afs_readpage.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:18:37 -0700
Message-ID: <200908312118.n7VLIbEN018328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbZHaVUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, anton@samba.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     afs: stop readlink() on AFS crashing because file not passed to afs_readpage()
has been removed from the -mm tree.  Its filename was
     afs-stop-readlink-on-afs-crashing-because-file-not-passed-to-afs_readpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: stop readlink() on AFS crashing because file not passed to afs_readpage()
From: David Howells <dhowells@redhat.com>

kAFS crashes when asked to read a symbolic link because page_getlink()
passes a NULL file pointer to read_mapping_page(), but afs_readpage()
expects a file pointer from which to extract a key.

Modify afs_readpage() to request the appropriate key from the calling
process's keyrings if a file struct is not supplied with one attached.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/afs/file.c~afs-stop-readlink-on-afs-crashing-because-file-not-passed-to-afs_readpage fs/afs/file.c
--- a/fs/afs/file.c~afs-stop-readlink-on-afs-crashing-because-file-not-passed-to-afs_readpage
+++ a/fs/afs/file.c
@@ -134,9 +134,16 @@ static int afs_readpage(struct file *fil
 
 	inode = page->mapping->host;
 
-	ASSERT(file != NULL);
-	key = file->private_data;
-	ASSERT(key != NULL);
+	if (file) {
+		key = file->private_data;
+		ASSERT(key != NULL);
+	} else {
+		key = afs_request_key(AFS_FS_S(inode->i_sb)->volume->cell);
+		if (IS_ERR(key)) {
+			ret = PTR_ERR(key);
+			goto error_nokey;
+		}
+	}
 
 	_enter("{%x},{%lu},{%lu}", key_serial(key), inode->i_ino, page->index);
 
@@ -207,12 +214,17 @@ static int afs_readpage(struct file *fil
 		unlock_page(page);
 	}
 
+	if (!file)
+		key_put(key);
 	_leave(" = 0");
 	return 0;
 
 error:
 	SetPageError(page);
 	unlock_page(page);
+	if (!file)
+		key_put(key);
+error_nokey:
 	_leave(" = %d", ret);
 	return ret;
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
mm-count-only-reclaimable-lru-pages-v2.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
mm-includecheck-fix-for-mm-nommuc.patch
frv-duplicate-output_buffer-of-e03.patch
frv-convert-to-asm-generic-hardirqh.patch
misc-remove-redundant-start_kernel-prototypes.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
mutex-subsystem-synchro-test-module.patch

