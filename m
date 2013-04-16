From: akpm@linux-foundation.org
Subject: + hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch added to -mm tree
Date: Tue, 16 Apr 2013 13:16:18 -0700
Message-ID: <20130416201618.7D72A31C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:60073 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781Ab3DPUQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 16:16:19 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so88408ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 13:16:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: fix potential overflow in hfsplus_file_truncate()
has been added to the -mm tree.  Its filename is
     hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch

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

hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch
hfs-add-error-checking-for-hfs_find_init.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch

