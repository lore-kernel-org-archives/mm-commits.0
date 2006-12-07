From: akpm@osdl.org
Subject: - reiserfs-add-missing-d-cache-flushing.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:16 -0800
Message-ID: <200612072305.kB7N5GJJ030135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163887AbWLGXFS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: add missing D-cache flushing
has been removed from the -mm tree.  Its filename was
     reiserfs-add-missing-d-cache-flushing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: add missing D-cache flushing
From: Alexey Dobriyan <adobriyan@openvz.org>

Looks like, reiserfs_prepare_file_region_for_write() doesn't contain
several flush_dcache_page() calls.

Found with help from Dmitriy Monakhov <dmonakhov@openvz.org>

[akpm@osdl.org: small speedup]
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/reiserfs/file.c~reiserfs-add-missing-d-cache-flushing fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiserfs-add-missing-d-cache-flushing
+++ a/fs/reiserfs/file.c
@@ -1045,6 +1045,7 @@ static int reiserfs_prepare_file_region_
 			char *kaddr = kmap_atomic(prepared_pages[0], KM_USER0);
 			memset(kaddr, 0, from);
 			kunmap_atomic(kaddr, KM_USER0);
+			flush_dcache_page(prepared_pages[0]);
 		}
 		if (to != PAGE_CACHE_SIZE) {	/* Last page needs to be partially zeroed */
 			char *kaddr =
@@ -1052,6 +1053,7 @@ static int reiserfs_prepare_file_region_
 					KM_USER0);
 			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
 			kunmap_atomic(kaddr, KM_USER0);
+			flush_dcache_page(prepared_pages[num_pages - 1]);
 		}
 
 		/* Since all blocks are new - use already calculated value */
@@ -1185,6 +1187,7 @@ static int reiserfs_prepare_file_region_
 					memset(kaddr + block_start, 0,
 					       from - block_start);
 					kunmap_atomic(kaddr, KM_USER0);
+					flush_dcache_page(prepared_pages[0]);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1222,6 +1225,7 @@ static int reiserfs_prepare_file_region_
 							KM_USER0);
 					memset(kaddr + to, 0, block_end - to);
 					kunmap_atomic(kaddr, KM_USER0);
+					flush_dcache_page(prepared_pages[num_pages - 1]);
 					set_buffer_uptodate(bh);
 				}
 			}
_

Patches currently in -mm which might be from adobriyan@openvz.org are

origin.patch

