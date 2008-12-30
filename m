From: akpm@linux-foundation.org
Subject: + reiser4-adjust-to-the-new-aops-fixup.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:11:44 -0800
Message-ID: <200812302311.mBUNBiQW020374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbYL3XMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: adjust to the new aops fixup
has been added to the -mm tree.  Its filename is
     reiser4-adjust-to-the-new-aops-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch

