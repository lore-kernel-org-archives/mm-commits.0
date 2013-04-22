From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:55 -0700
Message-ID: <20130422200655.7C57C5A4265@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39819 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3DVUG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:57 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so624468ghr.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix potential overflow in hfsplus_file_truncate()
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: fix potential overflow in hfsplus_file_truncate()

Change a u32 to loff_t hfsplus_file_truncate().

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-potential-overflow-in-hfsplus_file_truncate fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-potential-overflow-in-hfsplus_file_truncate
+++ a/fs/hfsplus/extents.c
@@ -533,7 +533,7 @@ void hfsplus_file_truncate(struct inode
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfs-add-error-checking-for-hfs_find_init.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch

