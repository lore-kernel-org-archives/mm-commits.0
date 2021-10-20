Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7018C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B9A600EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJTWTS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWTI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B7B611CB;
        Wed, 20 Oct 2021 22:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634768214;
        bh=EVXlEx2wIZNb8SUfDNV/VqeL5YorCZJdNIpNrkz1bgM=;
        h=Date:From:To:Subject:From;
        b=faPH4wn22Axl1DtyZetoeAD7ipR69TSPEUM2/tUSLl0jTvBFY5FoKxyG4HjcX3LPq
         AUZuXQTCQiqgWIQWKOH8m3HP9Qq3X+owtFZ7utAOPj9v4onp0+SJknoZ3jJNMZ7yFC
         BjvTIYCuVFeO5eamIJS/GZp6+pd2U51iGEUoacGs=
Date:   Wed, 20 Oct 2021 15:16:53 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  +
 mm-shmem-dont-truncate-page-if-memory-failure-happens.patch added to -mm
 tree
Message-ID: <20211020221653.2pf1bWAXy%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20211020210755.23964-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++++++-
 mm/shmem.c          |   38 +++++++++++++++++++++++++++++++++++---
 mm/userfaultfd.c    |    5 +++++
 3 files changed, 49 insertions(+), 4 deletions(-)

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
 
@@ -896,6 +898,12 @@ static int me_pagecache_clean(struct pag
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
@@ -904,7 +912,7 @@ static int me_pagecache_clean(struct pag
 out:
 	unlock_page(p);
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
 	return ret;
--- a/mm/shmem.c~mm-shmem-dont-truncate-page-if-memory-failure-happens
+++ a/mm/shmem.c
@@ -2454,6 +2454,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	int ret = 0;
 
 	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
@@ -2464,7 +2465,15 @@ shmem_write_begin(struct file *file, str
 			return -EPERM;
 	}
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE);
+
+	if (*pagep && PageHWPoison(*pagep)) {
+		unlock_page(*pagep);
+		put_page(*pagep);
+		ret = -EIO;
+	}
+
+	return ret;
 }
 
 static int
@@ -2551,6 +2560,12 @@ static ssize_t shmem_file_read_iter(stru
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
@@ -3112,7 +3127,8 @@ static const char *shmem_get_link(struct
 		page = find_get_page(inode->i_mapping, 0);
 		if (!page)
 			return ERR_PTR(-ECHILD);
-		if (!PageUptodate(page)) {
+		if (PageHWPoison(page) ||
+		    !PageUptodate(page)) {
 			put_page(page);
 			return ERR_PTR(-ECHILD);
 		}
@@ -3120,6 +3136,11 @@ static const char *shmem_get_link(struct
 		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
+		if (page && PageHWPoison(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-ECHILD);
+		}
 		unlock_page(page);
 	}
 	set_delayed_call(done, shmem_put_link, page);
@@ -3770,6 +3791,13 @@ static void shmem_destroy_inodecache(voi
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
@@ -3780,7 +3808,7 @@ const struct address_space_operations sh
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 EXPORT_SYMBOL(shmem_aops);
 
@@ -4191,6 +4219,10 @@ struct page *shmem_read_mapping_page_gfp
 		page = ERR_PTR(error);
 	else
 		unlock_page(page);
+
+	if (PageHWPoison(page))
+		page = ERR_PTR(-EIO);
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

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

