From: akpm@linux-foundation.org
Subject: [folded] reiser4-adjust-to-the-new-aops-fixup.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:28 -0800
Message-ID: <201002032019.o13KJSxd016654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757867Ab0BCUTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: adjust to the new aops fixup
has been removed from the -mm tree.  Its filename was
     reiser4-adjust-to-the-new-aops-fixup.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: adjust to the new aops fixup
From: Edward Shishkin <edward.shishkin@gmail.com>

Make sure that reiser4_write_begin() is not called for interruptible
copies.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file_conversion.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-adjust-to-the-new-aops-fixup fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-adjust-to-the-new-aops-fixup
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -682,6 +682,12 @@ int reiser4_write_begin_careful(struct f
 	reiser4_context *ctx;
 	struct inode * inode = file->f_dentry->d_inode;
 
+	/**
+	 * reiser4_write_end() can not cope with
+	 * short writes for now
+	 */
+	BUG_ON(!(flags & AOP_FLAG_UNINTERRUPTIBLE));
+
 	index = pos >> PAGE_CACHE_SHIFT;
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + len;
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

