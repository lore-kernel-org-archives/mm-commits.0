From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-unnecessary-flush_dcache_page.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:39 -0800
Message-ID: <200703020506.l2256dwq000814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbXCBFGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove unnecessary flush_dcache_page()
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-unnecessary-flush_dcache_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: remove unnecessary flush_dcache_page()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Remove unnecessary flush_dcache_page() call. Thanks to Dmitriy
Monakhov for pointing this out.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-remove-unnecessary-flush_dcache_page fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-remove-unnecessary-flush_dcache_page
+++ a/fs/ecryptfs/mmap.c
@@ -238,7 +238,6 @@ int ecryptfs_do_readpage(struct file *fi
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
 	kunmap_atomic(lower_page_data, KM_USER1);
-	flush_dcache_page(lower_page);
 	kunmap_atomic(page_data, KM_USER0);
 	flush_dcache_page(page);
 	rc = 0;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
ecryptfs-check-xattr-operation-support-fix.patch
git-unionfs.patch
ecryptfs-handles-aop_truncated_page-better.patch
