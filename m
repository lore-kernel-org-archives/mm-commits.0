From: akpm@linux-foundation.org
Subject: + ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch added to -mm tree
Date: Thu, 07 Feb 2013 14:16:26 -0800
Message-ID: <20130207221627.286941E40F3@corp2gmr1-2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:65078 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655Ab3BGWQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 17:16:29 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm6so7006wib.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 14:16:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: ocfs2: add freeze protection to ocfs2_file_splice_write()
has been added to the -mm tree.  Its filename is
     ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: add freeze protection to ocfs2_file_splice_write()

ocfs2_file_splice_write() was missed when adding freeze protection to all
write paths. Fix that.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-add-freeze-protection-to-ocfs2_file_splice_write fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-add-freeze-protection-to-ocfs2_file_splice_write
+++ a/fs/ocfs2/file.c
@@ -2467,6 +2467,9 @@ static ssize_t ocfs2_file_splice_write(s
 			out->f_path.dentry->d_name.len,
 			out->f_path.dentry->d_name.name, len);
 
+	if (!sb_start_file_write(out))
+		return -EAGAIN;
+
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
 
@@ -2505,6 +2508,7 @@ static ssize_t ocfs2_file_splice_write(s
 
 		balance_dirty_pages_ratelimited(mapping);
 	}
+	sb_end_write(inode->i_sb);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
fs-change-return-values-from-eacces-to-eperm.patch
bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

