From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:02:01 -0800
Message-ID: <20171116200201.2diWfz8nc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add variant of pagevec_lookup_range_tag() taking number of pages
has been removed from the -mm tree.  Its filename was
     mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: add variant of pagevec_lookup_range_tag() taking number of pages

Currently pagevec_lookup_range_tag() takes number of pages to look up but
most users don't need this.  Create a new function
pagevec_lookup_range_nr_tag() that takes maximum number of pages to lookup
for Ceph which wants this functionality so that we can drop nr_pages
argument from pagevec_lookup_range_tag().

Link: http://lkml.kernel.org/r/20171009151359.31984-13-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    3 +++
 mm/swap.c               |    9 +++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/pagevec.h~mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages
+++ a/include/linux/pagevec.h
@@ -41,6 +41,9 @@ static inline unsigned pagevec_lookup(st
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
 		int tag, unsigned nr_pages);
+unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
+		struct address_space *mapping, pgoff_t *index, pgoff_t end,
+		int tag, unsigned max_pages);
 static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, int tag,
 		unsigned nr_pages)
diff -puN mm/swap.c~mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages mm/swap.c
--- a/mm/swap.c~mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages
+++ a/mm/swap.c
@@ -996,6 +996,15 @@ unsigned pagevec_lookup_range_tag(struct
 }
 EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
+unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
+		struct address_space *mapping, pgoff_t *index, pgoff_t end,
+		int tag, unsigned max_pages)
+{
+	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
+		min_t(unsigned int, max_pages, PAGEVEC_SIZE), pvec->pages);
+	return pagevec_count(pvec);
+}
+EXPORT_SYMBOL(pagevec_lookup_range_nr_tag);
 /*
  * Perform any setup for the swap system
  */
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch

