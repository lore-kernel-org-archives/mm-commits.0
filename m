From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:45 -0700
Message-ID: <20130507174845.8E05131C302@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:62932 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3EGRsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:47 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so85199ggl.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix warnings in fs/hfsplus/bfind.c
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: fix warnings in fs/hfsplus/bfind.c

fs/hfsplus/bfind.c: In function 'hfs_find_1st_rec_by_cnid':
(1) include/uapi/linux/swab.h:60:2: warning: 'search_cnid' may be used uninitialized in this function [-Wmaybe-uninitialized]
(2) include/uapi/linux/swab.h:60:2: warning: 'cur_cnid' may be used uninitialized in this function [-Wmaybe-uninitialized]

[akpm@linux-foundation.org: make the workaround more explicit]
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid
+++ a/fs/hfsplus/bfind.c
@@ -56,7 +56,8 @@ int hfs_find_1st_rec_by_cnid(struct hfs_
 				int *end,
 				int *cur_rec)
 {
-	__be32 cur_cnid, search_cnid;
+	__be32 cur_cnid;
+	__be32 search_cnid;
 
 	if (bnode->tree->cnid == HFSPLUS_EXT_CNID) {
 		cur_cnid = fd->key->ext.cnid;
@@ -67,8 +68,11 @@ int hfs_find_1st_rec_by_cnid(struct hfs_
 	} else if (bnode->tree->cnid == HFSPLUS_ATTR_CNID) {
 		cur_cnid = fd->key->attr.cnid;
 		search_cnid = fd->search_key->attr.cnid;
-	} else
+	} else {
+		cur_cnid = 0;	/* used-uninitialized warning */
+		search_cnid = 0;
 		BUG();
+	}
 
 	if (cur_cnid == search_cnid) {
 		(*end) = (*cur_rec);
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

