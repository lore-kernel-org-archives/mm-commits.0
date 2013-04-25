From: akpm@linux-foundation.org
Subject: + nilfs2-remove-unneeded-test-in-nilfs_writepage.patch added to -mm tree
Date: Thu, 25 Apr 2013 13:46:25 -0700
Message-ID: <20130425204625.7D83F31C1BD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41352 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab3DYUq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 16:46:26 -0400
Received: by mail-qe0-f74.google.com with SMTP id 6so135466qeb.1
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 13:46:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, dan.carpenter@oracle.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: remove unneeded test in nilfs_writepage()
has been added to the -mm tree.  Its filename is
     nilfs2-remove-unneeded-test-in-nilfs_writepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: remove unneeded test in nilfs_writepage()

page->mapping->host cannot be NULL in nilfs_writepage(), so remove the
unneeded test.

The fixes the sparse warning: "fs/nilfs2/inode.c:211 nilfs_writepage()
error: we previously assumed 'inode' could be null (see line 195)".

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/inode.c~nilfs2-remove-unneeded-test-in-nilfs_writepage fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-remove-unneeded-test-in-nilfs_writepage
+++ a/fs/nilfs2/inode.c
@@ -192,7 +192,7 @@ static int nilfs_writepage(struct page *
 	struct inode *inode = page->mapping->host;
 	int err;
 
-	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch
nilfs2-remove-unneeded-test-in-nilfs_writepage.patch
hfs-add-error-checking-for-hfs_find_init.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch
hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch

