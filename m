From: akpm@linux-foundation.org
Subject: + mm-add-find_get_entries_tag.patch added to -mm tree
Date: Tue, 22 Dec 2015 14:46:51 -0800
Message-ID: <5679d2db.MvOFHKJqgLbggbQn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbbLVWqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 17:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add find_get_entries_tag()
has been added to the -mm tree.  Its filename is
     mm-add-find_get_entries_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-find_get_entries_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-find_get_entries_tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm: add find_get_entries_tag()

Add find_get_entries_tag() to the family of functions that include
find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
needed for DAX dirty page handling because we need a list of both page
offsets and radix tree entries ('indices' and 'entries' in this function)
that are marked with the PAGECACHE_TAG_TOWRITE tag.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +
 mm/filemap.c            |   68 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff -puN include/linux/pagemap.h~mm-add-find_get_entries_tag include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-add-find_get_entries_tag
+++ a/include/linux/pagemap.h
@@ -361,6 +361,9 @@ unsigned find_get_pages_contig(struct ad
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 			int tag, unsigned int nr_pages, struct page **pages);
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+			int tag, unsigned int nr_entries,
+			struct page **entries, pgoff_t *indices);
 
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
 			pgoff_t index, unsigned flags);
diff -puN mm/filemap.c~mm-add-find_get_entries_tag mm/filemap.c
--- a/mm/filemap.c~mm-add-find_get_entries_tag
+++ a/mm/filemap.c
@@ -1499,6 +1499,74 @@ repeat:
 }
 EXPORT_SYMBOL(find_get_pages_tag);
 
+/**
+ * find_get_entries_tag - find and return entries that match @tag
+ * @mapping:	the address_space to search
+ * @start:	the starting page cache index
+ * @tag:	the tag index
+ * @nr_entries:	the maximum number of entries
+ * @entries:	where the resulting entries are placed
+ * @indices:	the cache indices corresponding to the entries in @entries
+ *
+ * Like find_get_entries, except we only return entries which are tagged with
+ * @tag.
+ */
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+			int tag, unsigned int nr_entries,
+			struct page **entries, pgoff_t *indices)
+{
+	void **slot;
+	unsigned int ret = 0;
+	struct radix_tree_iter iter;
+
+	if (!nr_entries)
+		return 0;
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_tagged(slot, &mapping->page_tree,
+				   &iter, start, tag) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			continue;
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				goto restart;
+			}
+
+			/*
+			 * A shadow entry of a recently evicted page, a swap
+			 * entry from shmem/tmpfs or a DAX entry.  Return it
+			 * without attempting to raise page count.
+			 */
+			goto export;
+		}
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *slot)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+export:
+		indices[ret] = iter.index;
+		entries[ret] = page;
+		if (++ret == nr_entries)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(find_get_entries_tag);
+
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

