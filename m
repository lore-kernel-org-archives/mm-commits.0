From: akpm@linux-foundation.org
Subject: + nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:03:56 -0700
Message-ID: <20130422220356.6B0A631C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:57880 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3DVWD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:03:57 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so749085qee.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:03:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com


The patch titled
     Subject: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch

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
Subject: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()

Change test_bit(PG_locked, &page->flags) to PageLocked().

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/page.c~nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page
+++ a/fs/nilfs2/page.c
@@ -407,7 +407,7 @@ void nilfs_clear_dirty_page(struct page
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
 
-	BUG_ON(!test_bit(PG_locked, &page->flags));
+	BUG_ON(!PageLocked(page));
 
 	if (!silent) {
 		nilfs_warning(sb, __func__,
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch
hfs-add-error-checking-for-hfs_find_init.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch

