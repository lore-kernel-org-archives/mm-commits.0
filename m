Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A011A134C7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1Kekb5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF84C433C7;
	Fri, 29 Dec 2023 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880015;
	bh=hobPwMBKzBlvbwgl/AKQkck7sprWT1MCgLNixHW4Qfk=;
	h=Date:To:From:Subject:From;
	b=Z1Kekb5Wus+SJVtGzuL5b74dJn6pK6O5WZpbQ13wW5oJbDAOxh6NR+llA1qw2ZVc/
	 wiOpY9a5r8FyRsrKCRjX6BdXD5hWDtpuxF4S7K//e2/K87aL9c9RfHUEdEhYjsy1+1
	 JIEgP0NBd9VF/wZ89Gv1PUcHwcLjuvJxaRzgK+xA=
Date: Fri, 29 Dec 2023 12:00:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_swap_info.patch removed from -mm tree
Message-Id: <20231229200015.6BF84C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_swap_info()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_swap_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_swap_info()
Date: Wed, 13 Dec 2023 21:58:40 +0000

It's more efficient to get the swap_info_struct by calling
swp_swap_info() directly.

Link: https://lkml.kernel.org/r/20231213215842.671461-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +--
 mm/swap.h            |    2 +-
 mm/swapfile.c        |    8 +-------
 3 files changed, 3 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-remove-page_swap_info
+++ a/include/linux/swap.h
@@ -487,8 +487,7 @@ extern sector_t swapdev_block(int, pgoff
 extern int __swap_count(swp_entry_t entry);
 extern int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-extern struct swap_info_struct *page_swap_info(struct page *);
-extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
+struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
--- a/mm/swapfile.c~mm-remove-page_swap_info
+++ a/mm/swapfile.c
@@ -3369,18 +3369,12 @@ struct swap_info_struct *swp_swap_info(s
 	return swap_type_to_swap_info(swp_type(entry));
 }
 
-struct swap_info_struct *page_swap_info(struct page *page)
-{
-	swp_entry_t entry = page_swap_entry(page);
-	return swp_swap_info(entry);
-}
-
 /*
  * out-of-line methods to avoid include hell.
  */
 struct address_space *swapcache_mapping(struct folio *folio)
 {
-	return page_swap_info(&folio->page)->swap_file->f_mapping;
+	return swp_swap_info(folio->swap)->swap_file->f_mapping;
 }
 EXPORT_SYMBOL_GPL(swapcache_mapping);
 
--- a/mm/swap.h~mm-remove-page_swap_info
+++ a/mm/swap.h
@@ -60,7 +60,7 @@ struct page *swapin_readahead(swp_entry_
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return page_swap_info(&folio->page)->flags;
+	return swp_swap_info(folio->swap)->flags;
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

