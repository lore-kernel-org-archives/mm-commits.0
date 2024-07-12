Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4631CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824839; cv=none; b=T4NpmofS0IFsPBEOf6Wbi9RefkyKpow0F6rYKYAUnjIEk0+uiysBA0pX+tFo3cJd6JMRKNre+OwxH5yRe5JrgX2Su+CQGId3tedGXMOnuN8bMBjW8m21qLQMKyPrFQA9kqDxvbnbVAIWLpnkn4aMk96xe0pBUqPsIYiRvkLDcd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824839; c=relaxed/simple;
	bh=SUSwc+1K0dNTwBqV4Zo10wYHWkZmPkQPNfKpEKgtJ6U=;
	h=Date:To:From:Subject:Message-Id; b=cN+ZBNDZVDmFmGuHtCdKJw3jQ5fEMmwiaEEEjfNcmZe6hIQwk8Hy1sOH9UrL+gcsUJ0V16ejQp4YiZ1u9FOxFRPr2zUDpN+3v/6cLTlNm6cCFPKpi/nScit4kt/hGE6LMd8Xo0/xbY9KcvJAckgj8BHM4n9zVHc7eU0qA99sIoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mvtu+bUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mvtu+bUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C619EC4AF07;
	Fri, 12 Jul 2024 22:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824838;
	bh=SUSwc+1K0dNTwBqV4Zo10wYHWkZmPkQPNfKpEKgtJ6U=;
	h=Date:To:From:Subject:From;
	b=Mvtu+bUI5JZQqZAd9gQZIOTxOeKm3jiL2GtBisMnUJGnqlerRLAx/B0vcPRExKMVu
	 sZ5/74oovZWkHn/05mXgn42+HbQqQePJvTXZ9SK1sLMKuZA3WlTpsqlcW4NrCRgA2n
	 GKzJ08X63EZBKyIL30y0wNGFZHOTF7ZN+b6LdZnI=
Date: Fri, 12 Jul 2024 15:53:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch removed from -mm tree
Message-Id: <20240712225358.C619EC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: introduce memfd_pin_folios() for pinning memfd folios
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/gup: introduce memfd_pin_folios() for pinning memfd folios
Date: Sun, 23 Jun 2024 23:36:11 -0700

For drivers that would like to longterm-pin the folios associated with a
memfd, the memfd_pin_folios() API provides an option to not only pin the
folios via FOLL_PIN but also to check and migrate them if they reside in
movable zone or CMA block.  This API currently works with memfds but it
should work with any files that belong to either shmemfs or hugetlbfs. 
Files belonging to other filesystems are rejected for now.

The folios need to be located first before pinning them via FOLL_PIN.  If
they are found in the page cache, they can be immediately pinned. 
Otherwise, they need to be allocated using the filesystem specific APIs
and then pinned.

[akpm@linux-foundation.org: improve the CONFIG_MMU=n situation, per SeongJae]
[vivek.kasireddy@intel.com: return -EINVAL if the end offset is greater than the size of memfd]
  Link: https://lkml.kernel.org/r/IA0PR11MB71850525CBC7D541CAB45DF1F8DB2@IA0PR11MB7185.namprd11.prod.outlook.com
Link: https://lkml.kernel.org/r/20240624063952.1572359-4-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (v2)
Reviewed-by: David Hildenbrand <david@redhat.com> (v3)
Reviewed-by: Christoph Hellwig <hch@lst.de> (v6)
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |    5 +
 include/linux/mm.h    |    3 
 mm/gup.c              |  139 ++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c            |   45 ++++++++++++
 4 files changed, 192 insertions(+)

--- a/include/linux/memfd.h~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios
+++ a/include/linux/memfd.h
@@ -6,11 +6,16 @@
 
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
+struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
 	return -EINVAL;
 }
+static inline struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
--- a/include/linux/mm.h~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios
+++ a/include/linux/mm.h
@@ -2500,6 +2500,9 @@ long get_user_pages_unlocked(unsigned lo
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
+long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
+		      struct folio **folios, unsigned int max_folios,
+		      pgoff_t *offset);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios
+++ a/mm/gup.c
@@ -5,6 +5,7 @@
 #include <linux/spinlock.h>
 
 #include <linux/mm.h>
+#include <linux/memfd.h>
 #include <linux/memremap.h>
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
@@ -17,6 +18,7 @@
 #include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
+#include <linux/pagevec.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 
@@ -3764,3 +3766,140 @@ long pin_user_pages_unlocked(unsigned lo
 				     &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
+
+/**
+ * memfd_pin_folios() - pin folios associated with a memfd
+ * @memfd:      the memfd whose folios are to be pinned
+ * @start:      the first memfd offset
+ * @end:        the last memfd offset (inclusive)
+ * @folios:     array that receives pointers to the folios pinned
+ * @max_folios: maximum number of entries in @folios
+ * @offset:     the offset into the first folio
+ *
+ * Attempt to pin folios associated with a memfd in the contiguous range
+ * [start, end]. Given that a memfd is either backed by shmem or hugetlb,
+ * the folios can either be found in the page cache or need to be allocated
+ * if necessary. Once the folios are located, they are all pinned via
+ * FOLL_PIN and @offset is populatedwith the offset into the first folio.
+ * And, eventually, these pinned folios must be released either using
+ * unpin_folios() or unpin_folio().
+ *
+ * It must be noted that the folios may be pinned for an indefinite amount
+ * of time. And, in most cases, the duration of time they may stay pinned
+ * would be controlled by the userspace. This behavior is effectively the
+ * same as using FOLL_LONGTERM with other GUP APIs.
+ *
+ * Returns number of folios pinned, which could be less than @max_folios
+ * as it depends on the folio sizes that cover the range [start, end].
+ * If no folios were pinned, it returns -errno.
+ */
+long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
+		      struct folio **folios, unsigned int max_folios,
+		      pgoff_t *offset)
+{
+	unsigned int flags, nr_folios, nr_found;
+	unsigned int i, pgshift = PAGE_SHIFT;
+	pgoff_t start_idx, end_idx, next_idx;
+	struct folio *folio = NULL;
+	struct folio_batch fbatch;
+	struct hstate *h;
+	long ret = -EINVAL;
+
+	if (start < 0 || start > end || !max_folios)
+		return -EINVAL;
+
+	if (!memfd)
+		return -EINVAL;
+
+	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+		return -EINVAL;
+
+	if (end >= i_size_read(file_inode(memfd)))
+		return -EINVAL;
+
+	if (is_file_hugepages(memfd)) {
+		h = hstate_file(memfd);
+		pgshift = huge_page_shift(h);
+	}
+
+	flags = memalloc_pin_save();
+	do {
+		nr_folios = 0;
+		start_idx = start >> pgshift;
+		end_idx = end >> pgshift;
+		if (is_file_hugepages(memfd)) {
+			start_idx <<= huge_page_order(h);
+			end_idx <<= huge_page_order(h);
+		}
+
+		folio_batch_init(&fbatch);
+		while (start_idx <= end_idx && nr_folios < max_folios) {
+			/*
+			 * In most cases, we should be able to find the folios
+			 * in the page cache. If we cannot find them for some
+			 * reason, we try to allocate them and add them to the
+			 * page cache.
+			 */
+			nr_found = filemap_get_folios_contig(memfd->f_mapping,
+							     &start_idx,
+							     end_idx,
+							     &fbatch);
+			if (folio) {
+				folio_put(folio);
+				folio = NULL;
+			}
+
+			next_idx = 0;
+			for (i = 0; i < nr_found; i++) {
+				/*
+				 * As there can be multiple entries for a
+				 * given folio in the batch returned by
+				 * filemap_get_folios_contig(), the below
+				 * check is to ensure that we pin and return a
+				 * unique set of folios between start and end.
+				 */
+				if (next_idx &&
+				    next_idx != folio_index(fbatch.folios[i]))
+					continue;
+
+				folio = page_folio(&fbatch.folios[i]->page);
+
+				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+					folio_batch_release(&fbatch);
+					ret = -EINVAL;
+					goto err;
+				}
+
+				if (nr_folios == 0)
+					*offset = offset_in_folio(folio, start);
+
+				folios[nr_folios] = folio;
+				next_idx = folio_next_index(folio);
+				if (++nr_folios == max_folios)
+					break;
+			}
+
+			folio = NULL;
+			folio_batch_release(&fbatch);
+			if (!nr_found) {
+				folio = memfd_alloc_folio(memfd, start_idx);
+				if (IS_ERR(folio)) {
+					ret = PTR_ERR(folio);
+					if (ret != -EEXIST)
+						goto err;
+				}
+			}
+		}
+
+		ret = check_and_migrate_movable_folios(nr_folios, folios);
+	} while (ret == -EAGAIN);
+
+	memalloc_pin_restore(flags);
+	return ret ? ret : nr_folios;
+err:
+	memalloc_pin_restore(flags);
+	unpin_folios(folios, nr_folios);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(memfd_pin_folios);
--- a/mm/memfd.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios
+++ a/mm/memfd.c
@@ -60,6 +60,51 @@ static void memfd_tag_pins(struct xa_sta
 }
 
 /*
+ * This is a helper function used by memfd_pin_user_pages() in GUP (gup.c).
+ * It is mainly called to allocate a folio in a memfd when the caller
+ * (memfd_pin_folios()) cannot find a folio in the page cache at a given
+ * index in the mapping.
+ */
+struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	struct folio *folio;
+	gfp_t gfp_mask;
+	int err;
+
+	if (is_file_hugepages(memfd)) {
+		/*
+		 * The folio would most likely be accessed by a DMA driver,
+		 * therefore, we have zone memory constraints where we can
+		 * alloc from. Also, the folio will be pinned for an indefinite
+		 * amount of time, so it is not expected to be migrated away.
+		 */
+		gfp_mask = htlb_alloc_mask(hstate_file(memfd));
+		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
+
+		folio = alloc_hugetlb_folio_nodemask(hstate_file(memfd),
+						     numa_node_id(),
+						     NULL,
+						     gfp_mask,
+						     false);
+		if (folio && folio_try_get(folio)) {
+			err = hugetlb_add_to_page_cache(folio,
+							memfd->f_mapping,
+							idx);
+			if (err) {
+				folio_put(folio);
+				free_huge_folio(folio);
+				return ERR_PTR(err);
+			}
+			return folio;
+		}
+		return ERR_PTR(-ENOMEM);
+	}
+#endif
+	return shmem_read_folio(memfd->f_mapping, idx);
+}
+
+/*
  * Setting SEAL_WRITE requires us to verify there's no pending writer. However,
  * via get_user_pages(), drivers might have some pending I/O without any active
  * user-space mappings (eg., direct-IO, AIO). Therefore, we look at all folios
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


