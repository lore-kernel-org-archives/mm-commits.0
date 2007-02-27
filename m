From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unnecessary-flush_dcache_page.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:33:55 -0800
Message-ID: <200702272033.l1RKXxmx027528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXB0UeD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dmonakhov@openvz.org


The patch titled
     eCryptfs: remove unnecessary flush_dcache_page()
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unnecessary-flush_dcache_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-resolve-lower-page-unlocking-problem.patch
ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
git-unionfs.patch
ecryptfs-handles-aop_truncated_page-better.patch
