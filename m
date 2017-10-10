From: akpm@linux-foundation.org
Subject: +
 mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
 added to -mm tree
Date: Tue, 10 Oct 2017 14:01:07 -0700
Message-ID: <59dd3513.XTcLE/QvbMGMk5ux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932953AbdJJVBN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add variant of pagevec_lookup_range_tag() taking number of pages
has been added to the -mm tree.  Its filename is
     mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -40,6 +40,9 @@ static inline unsigned pagevec_lookup(st
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
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch

