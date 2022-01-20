Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBCBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347632AbiATVYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244034AbiATVYu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC07DC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C27B81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC97C340E0;
        Thu, 20 Jan 2022 21:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713887;
        bh=wWDvLmwpVtYWqlQFY4wydCbIHr9g9C8Dl8Rs2NXGHzE=;
        h=Date:From:To:Subject:From;
        b=abIHS5Gh371ZwNjUk8IM0sRhWLLsfsWAr/mNOy8+XxMT1dzIxFdM2PMuGgQcCciVR
         1+xgmFRAaZkQb7RIW2KWxUiDvPEA6N4gu8MH3D43ZV8cWirk4bZ0l8d2n1oXw6prb7
         5wvKHrx4BmSa6+kNen/4efyg4SR4ihylSdWrQ0Gc=
Date:   Thu, 20 Jan 2022 13:24:46 -0800
From:   akpm@linux-foundation.org
To:     ajaygargnsit@gmail.com, andy.lavr@gmail.com, arnd@arndb.de,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 mm-shmem-dont-truncate-page-if-memory-failure-happens.patch removed from
 -mm tree
Message-ID: <20220120212446.tmJV3H5-c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: don't truncate page if memory failure happens
has been removed from the -mm tree.  Its filename was
     mm-shmem-dont-truncate-page-if-memory-failure-happens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: shmem: don't truncate page if memory failure happens

The current behavior of memory failure is to truncate the page cache
regardless of dirty or clean.  If the page is dirty the later access will
get the obsolete data from disk without any notification to the users. 
This may cause silent data loss.  It is even worse for shmem since shmem
is in-memory filesystem, truncating page cache means discarding data
blocks.  The later read would return all zero.

The right approach is to keep the corrupted page in page cache, any later
access would return error for syscalls or SIGBUS for page fault, until the
file is truncated, hole punched or removed.  The regular storage backed
filesystems would be more complicated so this patch is focused on shmem. 
This also unblock the support for soft offlining shmem THP.

[akpm@linux-foundation.org: coding style fixes]
[arnd@arndb.de: fix uninitialized variable use in me_pagecache_clean()]
  Link: https://lkml.kernel.org/r/20211022064748.4173718-1-arnd@kernel.org
[Fix invalid pointer dereference in shmem_read_mapping_page_gfp() with a
 slight different implementation from what Ajay Garg <ajaygargnsit@gmail.com>
 and Muchun Song <songmuchun@bytedance.com> proposed and reworked the
 error handling of shmem_write_begin() suggested by Linus]
  Link: https://lore.kernel.org/linux-mm/20211111084617.6746-1-ajaygargnsit@gmail.com/
Link: https://lkml.kernel.org/r/20211020210755.23964-6-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20211116193247.21102-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ajay Garg <ajaygargnsit@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 +++++++++--
 mm/shmem.c          |   51 +++++++++++++++++++++++++++++++++++++-----
 mm/userfaultfd.c    |    5 ++++
 3 files changed, 61 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-shmem-dont-truncate-page-if-memory-failure-happens
+++ a/mm/memory-failure.c
@@ -58,6 +58,7 @@
 #include <linux/ratelimit.h>
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
+#include <linux/shmem_fs.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -867,6 +868,7 @@ static int me_pagecache_clean(struct pag
 {
 	int ret;
 	struct address_space *mapping;
+	bool extra_pins;
 
 	delete_from_lru_cache(p);
 
@@ -896,17 +898,23 @@ static int me_pagecache_clean(struct pag
 	}
 
 	/*
+	 * The shmem page is kept in page cache instead of truncating
+	 * so is expected to have an extra refcount after error-handling.
+	 */
+	extra_pins = shmem_mapping(mapping);
+
+	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_page(p, page_to_pfn(p), mapping);
+	if (has_extra_refcount(ps, p, extra_pins))
+		ret = MF_FAILED;
+
 out:
 	unlock_page(p);
 
-	if (has_extra_refcount(ps, p, false))
-		ret = MF_FAILED;
-
 	return ret;
 }
 
--- a/mm/shmem.c~mm-shmem-dont-truncate-page-if-memory-failure-happens
+++ a/mm/shmem.c
@@ -2457,6 +2457,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	int ret = 0;
 
 	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
@@ -2467,7 +2468,19 @@ shmem_write_begin(struct file *file, str
 			return -EPERM;
 	}
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE);
+
+	if (ret)
+		return ret;
+
+	if (PageHWPoison(*pagep)) {
+		unlock_page(*pagep);
+		put_page(*pagep);
+		*pagep = NULL;
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int
@@ -2554,6 +2567,12 @@ static ssize_t shmem_file_read_iter(stru
 			if (sgp == SGP_CACHE)
 				set_page_dirty(page);
 			unlock_page(page);
+
+			if (PageHWPoison(page)) {
+				put_page(page);
+				error = -EIO;
+				break;
+			}
 		}
 
 		/*
@@ -3093,7 +3112,8 @@ static const char *shmem_get_link(struct
 		page = find_get_page(inode->i_mapping, 0);
 		if (!page)
 			return ERR_PTR(-ECHILD);
-		if (!PageUptodate(page)) {
+		if (PageHWPoison(page) ||
+		    !PageUptodate(page)) {
 			put_page(page);
 			return ERR_PTR(-ECHILD);
 		}
@@ -3101,6 +3121,13 @@ static const char *shmem_get_link(struct
 		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
+		if (!page)
+			return ERR_PTR(-ECHILD);
+		if (PageHWPoison(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-ECHILD);
+		}
 		unlock_page(page);
 	}
 	set_delayed_call(done, shmem_put_link, page);
@@ -3751,6 +3778,13 @@ static void shmem_destroy_inodecache(voi
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
+/* Keep the page in page cache instead of truncating it */
+static int shmem_error_remove_page(struct address_space *mapping,
+				   struct page *page)
+{
+	return 0;
+}
+
 const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
@@ -3761,7 +3795,7 @@ const struct address_space_operations sh
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 EXPORT_SYMBOL(shmem_aops);
 
@@ -4169,9 +4203,14 @@ struct page *shmem_read_mapping_page_gfp
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
-		page = ERR_PTR(error);
-	else
-		unlock_page(page);
+		return ERR_PTR(error);
+
+	unlock_page(page);
+	if (PageHWPoison(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+
 	return page;
 #else
 	/*
--- a/mm/userfaultfd.c~mm-shmem-dont-truncate-page-if-memory-failure-happens
+++ a/mm/userfaultfd.c
@@ -232,6 +232,11 @@ static int mcontinue_atomic_pte(struct m
 		goto out;
 	}
 
+	if (PageHWPoison(page)) {
+		ret = -EIO;
+		goto out_release;
+	}
+
 	ret = mfill_atomic_install_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
 				       page, false, wp_copy);
 	if (ret)
_

Patches currently in -mm which might be from shy828301@gmail.com are


