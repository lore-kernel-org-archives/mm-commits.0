Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0160C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 23:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244087AbhLBXXt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:23:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40384 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbhLBXXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 18:23:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0072B82025
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 23:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2015FC00446;
        Thu,  2 Dec 2021 23:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638487223;
        bh=JNzqD/6GA1arJpUozMDfnf1P0o4XBKf4ifMOqt3V4nc=;
        h=Date:From:To:Subject:From;
        b=bZ/4OhnbS3ELe++6WmJaTeo3zfDiDt+chK0XOasiM+cy7k9V/iDqM5YWlsrJJ7VA0
         +bCt7c9sALgJX9uR8ZrkRt44juhT1QN96w26sakC/D2KIwuauvlIFf/alugYB5p4sD
         AsKy7dO6U9VNy3KWn3h4vieLwkLpweq4fBvuNz+8=
Date:   Thu, 02 Dec 2021 15:20:22 -0800
From:   akpm@linux-foundation.org
To:     ajaygargnsit@gmail.com, andy.lavr@gmail.com, arnd@arndb.de,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 mm-shmem-dont-truncate-page-if-memory-failure-happens.patch added to -mm
 tree
Message-ID: <20211202232022.4eUN1Uw7n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: don't truncate page if memory failure happens
has been added to the -mm tree.  Its filename is
     mm-shmem-dont-truncate-page-if-memory-failure-happens.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2462,6 +2462,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	int ret = 0;
 
 	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
@@ -2472,7 +2473,19 @@ shmem_write_begin(struct file *file, str
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
@@ -2559,6 +2572,12 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3098,7 +3117,8 @@ static const char *shmem_get_link(struct
 		page = find_get_page(inode->i_mapping, 0);
 		if (!page)
 			return ERR_PTR(-ECHILD);
-		if (!PageUptodate(page)) {
+		if (PageHWPoison(page) ||
+		    !PageUptodate(page)) {
 			put_page(page);
 			return ERR_PTR(-ECHILD);
 		}
@@ -3106,6 +3126,13 @@ static const char *shmem_get_link(struct
 		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
+		if (!page)
+		       return ERR_PTR(-ECHILD);
+		if (PageHWPoison(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-ECHILD);
+		}
 		unlock_page(page);
 	}
 	set_delayed_call(done, shmem_put_link, page);
@@ -3756,6 +3783,13 @@ static void shmem_destroy_inodecache(voi
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
@@ -3766,7 +3800,7 @@ const struct address_space_operations sh
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 EXPORT_SYMBOL(shmem_aops);
 
@@ -4174,9 +4208,14 @@ struct page *shmem_read_mapping_page_gfp
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

mm-shmem-dont-truncate-page-if-memory-failure-happens.patch

