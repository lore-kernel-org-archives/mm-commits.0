From: akpm@linux-foundation.org
Subject: + hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch added to -mm tree
Date: Wed, 24 Apr 2013 14:42:58 -0700
Message-ID: <20130424214258.76B125A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:54461 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3DXVm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 17:42:59 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so14965qea.2
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 14:42:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: remove duplicated message prefix in hfsplus_block_free()
has been added to the -mm tree.  Its filename is
     hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch

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
Subject: hfsplus: remove duplicated message prefix in hfsplus_block_free()

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hfsplus/bitmap.c~hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free
+++ a/fs/hfsplus/bitmap.c
@@ -238,8 +238,7 @@ out:
 	return 0;
 
 kaboom:
-	pr_crit("hfsplus: unable to mark blocks free: error %ld\n",
-			PTR_ERR(page));
+	pr_crit("unable to mark blocks free: error %ld\n", PTR_ERR(page));
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return -EIO;
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
hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch

