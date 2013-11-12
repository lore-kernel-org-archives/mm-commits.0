From: akpm@linux-foundation.org
Subject: [folded-merged]
 hfsplus-implement-attributes-file-creation-functionality-v2.patch removed
 from -mm tree
Date: Tue, 12 Nov 2013 14:44:49 -0800
Message-ID: <5282af61.lkzn9Ndsnyo+6kd5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3KLWou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [folded-merged] hfsplus-implement-attributes-file-creation-functionality-v2.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:44:49 -0800


The patch titled
     Subject: hfsplus-implement-attributes-file-creation-functionality-v2
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-attributes-file-creation-functionality-v2.patch

This patch was dropped because it was folded into hfsplus-implement-attributes-file-creation-functionality.patch

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus-implement-attributes-file-creation-functionality-v2

* SETOFFSET macro was removed (Andrew Morton).
* Record offsets logic was reworked in hfsplus_init_header_node() (Al Viro).
* AttributesFile's header node's bitmap is initialized by memset() (Al Viro).
* Logic of checking attributes tree state before AttributesFile
  creation was reworked for HFSPLUS_CREATING_ATTR_TREE case (Andrew Morton).
* Setting error code was added after read_mapping_page()
  call in hfsplus_create_attributes_file() method (Andrew Morton).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-implement-attributes-file-creation-functionality-v2 fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-implement-attributes-file-creation-functionality-v2
+++ a/fs/hfsplus/xattr.c
@@ -217,9 +217,21 @@ check_attr_tree_state_again:
 			goto check_attr_tree_state_again;
 		break;
 	case HFSPLUS_CREATING_ATTR_TREE:
-		schedule_timeout_uninterruptible(HZ);
-		goto check_attr_tree_state_again;
-		break;
+		/*
+		 * This state means that another thread is in process
+		 * of AttributesFile creation. Theoretically, it is
+		 * possible to be here. But really __setxattr() method
+		 * first of all calls hfs_find_init() for lookup in
+		 * B-tree of CatalogFile. This method locks mutex of
+		 * CatalogFile's B-tree. As a result, if some thread
+		 * is inside AttributedFile creation operation then
+		 * another threads will be waiting unlocking of
+		 * CatalogFile's B-tree's mutex. However, if code will
+		 * change then we will return error code (-EAGAIN) from
+		 * here. Really, it means that first try to set of xattr
+		 * fails with error but second attempt will have success.
+		 */
+		return -EAGAIN;
 	case HFSPLUS_VALID_ATTR_TREE:
 		return 0;
 	case HFSPLUS_FAILED_ATTR_TREE:
@@ -281,8 +293,10 @@ check_attr_tree_state_again:
 		void *kaddr;
 
 		page = read_mapping_page(mapping, index, NULL);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			err = PTR_ERR(page);
 			goto failed_header_node_init;
+		}
 
 		kaddr = kmap_atomic(page);
 		memcpy(kaddr, buf + written,
_

Patches currently in -mm which might be from slava@dubeyko.com are

fs-hfs-btreeh-remove-duplicate-defines.patch
hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-file-creation-functionality.patch

