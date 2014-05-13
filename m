From: akpm@linux-foundation.org
Subject: +
 mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch added to -mm tree
Date: Tue, 13 May 2014 15:41:15 -0700
Message-ID: <53729f8b.pVwQLhvy/wxYe3Ei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaEMWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 18:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: + mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch added to -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 15:41:15 -0700


The patch titled
     Subject: mm: non-atomically mark page accessed during page cache allocation where possible
has been added to the -mm tree.  Its filename is
     mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: non-atomically mark page accessed during page cache allocation where possible

aops->write_begin may allocate a new page and make it visible only to have
mark_page_accessed called almost immediately after.  Once the page is
visible the atomic operations are necessary which is noticable overhead
when writing to an in-memory filesystem like tmpfs but should also be
noticable with fast storage.  The objective of the patch is to initialse
the accessed information with non-atomic operations before the page is
visible.

The bulk of filesystems directly or indirectly use
grab_cache_page_write_begin or find_or_create_page for the initial
allocation of a page cache page.  This patch adds an init_page_accessed()
helper which behaves like the first call to mark_page_accessed() but may
called before the page is visible and can be done non-atomically.

The primary APIs of concern in this care are the following and are used
by most filesystems.

	find_get_page
	find_lock_page
	find_or_create_page
	grab_cache_page_nowait
	grab_cache_page_write_begin

All of them are very similar in detail to the patch creates a core helper
pagecache_get_page() which takes a flags parameter that affects its
behavior such as whether the page should be marked accessed or not.  Then
old API is preserved but is basically a thin wrapper around this core
function.

Each of the filesystems are then updated to avoid calling
mark_page_accessed when it is known that the VM interfaces have already
done the job.  There is a slight snag in that the timing of the
mark_page_accessed() has now changed so in rare cases it's possible a page
gets to the end of the LRU as PageReferenced where as previously it might
have been repromoted.  This is expected to be rare but it's worth the
filesystem people thinking about it in case they see a problem with the
timing change.  It is also the case that some filesystems may be marking
pages accessed that previously did not but it makes sense that filesystems
have consistent behaviour in this regard.

The test case used to evaulate this is a simple dd of a large file done
multiple times with the file deleted on each iterations.  The size of the
file is 1/10th physical memory to avoid dirty page balancing.  In the
async case it will be possible that the workload completes without even
hitting the disk and will have variable results but highlight the impact
of mark_page_accessed for async IO.  The sync results are expected to be
more stable.  The exception is tmpfs where the normal case is for the "IO"
to not hit the disk.

The test machine was single socket and UMA to avoid any scheduling or NUMA
artifacts.  Throughput and wall times are presented for sync IO, only wall
times are shown for async as the granularity reported by dd and the
variability is unsuitable for comparison.  As async results were variable
do to writback timings, I'm only reporting the maximum figures.  The sync
results were stable enough to make the mean and stddev uninteresting.

The performance results are reported based on a run with no profiling. 
Profile data is based on a separate run with oprofile running.

async dd
                                    3.15.0-rc3            3.15.0-rc3
                                       vanilla           accessed-v2
ext3    Max      elapsed     13.9900 (  0.00%)     11.5900 ( 17.16%)
tmpfs	Max      elapsed      0.5100 (  0.00%)      0.4900 (  3.92%)
btrfs   Max      elapsed     12.8100 (  0.00%)     12.7800 (  0.23%)
ext4	Max      elapsed     18.6000 (  0.00%)     13.3400 ( 28.28%)
xfs	Max      elapsed     12.5600 (  0.00%)      2.0900 ( 83.36%)

The XFS figure is a bit strange as it managed to avoid a worst case by
sheer luck but the average figures looked reasonable.

        samples percentage
ext3       86107    0.9783  vmlinux-3.15.0-rc4-vanilla        mark_page_accessed
ext3       23833    0.2710  vmlinux-3.15.0-rc4-accessed-v3r25 mark_page_accessed
ext3        5036    0.0573  vmlinux-3.15.0-rc4-accessed-v3r25 init_page_accessed
ext4       64566    0.8961  vmlinux-3.15.0-rc4-vanilla        mark_page_accessed
ext4        5322    0.0713  vmlinux-3.15.0-rc4-accessed-v3r25 mark_page_accessed
ext4        2869    0.0384  vmlinux-3.15.0-rc4-accessed-v3r25 init_page_accessed
xfs        62126    1.7675  vmlinux-3.15.0-rc4-vanilla        mark_page_accessed
xfs         1904    0.0554  vmlinux-3.15.0-rc4-accessed-v3r25 init_page_accessed
xfs          103    0.0030  vmlinux-3.15.0-rc4-accessed-v3r25 mark_page_accessed
btrfs      10655    0.1338  vmlinux-3.15.0-rc4-vanilla        mark_page_accessed
btrfs       2020    0.0273  vmlinux-3.15.0-rc4-accessed-v3r25 init_page_accessed
btrfs        587    0.0079  vmlinux-3.15.0-rc4-accessed-v3r25 mark_page_accessed
tmpfs      59562    3.2628  vmlinux-3.15.0-rc4-vanilla        mark_page_accessed
tmpfs       1210    0.0696  vmlinux-3.15.0-rc4-accessed-v3r25 init_page_accessed
tmpfs         94    0.0054  vmlinux-3.15.0-rc4-accessed-v3r25 mark_page_accessed

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c       |   11 +
 fs/btrfs/file.c            |    5 
 fs/buffer.c                |    7 -
 fs/ext4/mballoc.c          |   14 +-
 fs/f2fs/checkpoint.c       |    3 
 fs/f2fs/node.c             |    2 
 fs/fuse/file.c             |    2 
 fs/gfs2/aops.c             |    1 
 fs/gfs2/meta_io.c          |    4 
 fs/ntfs/attrib.c           |    1 
 fs/ntfs/file.c             |    1 
 include/linux/page-flags.h |    1 
 include/linux/pagemap.h    |  107 +++++++++++++++++-
 include/linux/swap.h       |    1 
 mm/filemap.c               |  202 ++++++++++++-----------------------
 mm/shmem.c                 |    6 -
 16 files changed, 206 insertions(+), 162 deletions(-)

diff -puN fs/btrfs/extent_io.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/btrfs/extent_io.c
@@ -4510,7 +4510,8 @@ static void check_buffer_tree_ref(struct
 	spin_unlock(&eb->refs_lock);
 }
 
-static void mark_extent_buffer_accessed(struct extent_buffer *eb)
+static void mark_extent_buffer_accessed(struct extent_buffer *eb,
+		struct page *accessed)
 {
 	unsigned long num_pages, i;
 
@@ -4519,7 +4520,8 @@ static void mark_extent_buffer_accessed(
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
-		mark_page_accessed(p);
+		if (p != accessed)
+			mark_page_accessed(p);
 	}
 }
 
@@ -4533,7 +4535,7 @@ struct extent_buffer *find_extent_buffer
 			       start >> PAGE_CACHE_SHIFT);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
 		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
+		mark_extent_buffer_accessed(eb, NULL);
 		return eb;
 	}
 	rcu_read_unlock();
@@ -4581,7 +4583,7 @@ struct extent_buffer *alloc_extent_buffe
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				page_cache_release(p);
-				mark_extent_buffer_accessed(exists);
+				mark_extent_buffer_accessed(exists, p);
 				goto free_eb;
 			}
 
@@ -4596,7 +4598,6 @@ struct extent_buffer *alloc_extent_buffe
 		attach_extent_buffer_page(eb, p);
 		spin_unlock(&mapping->private_lock);
 		WARN_ON(PageDirty(p));
-		mark_page_accessed(p);
 		eb->pages[i] = p;
 		if (!PageUptodate(p))
 			uptodate = 0;
diff -puN fs/btrfs/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/btrfs/file.c
--- a/fs/btrfs/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/btrfs/file.c
@@ -470,11 +470,12 @@ static void btrfs_drop_pages(struct page
 	for (i = 0; i < num_pages; i++) {
 		/* page checked is some magic around finding pages that
 		 * have been modified without going through btrfs_set_page_dirty
-		 * clear it here
+		 * clear it here. There should be no need to mark the pages
+		 * accessed as prepare_pages should have marked them accessed
+		 * in prepare_pages via find_or_create_page()
 		 */
 		ClearPageChecked(pages[i]);
 		unlock_page(pages[i]);
-		mark_page_accessed(pages[i]);
 		page_cache_release(pages[i]);
 	}
 }
diff -puN fs/buffer.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/buffer.c
--- a/fs/buffer.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/buffer.c
@@ -227,7 +227,7 @@ __find_get_block_slow(struct block_devic
 	int all_mapped = 1;
 
 	index = block >> (PAGE_CACHE_SHIFT - bd_inode->i_blkbits);
-	page = find_get_page(bd_mapping, index);
+	page = find_get_page_flags(bd_mapping, index, FGP_ACCESSED);
 	if (!page)
 		goto out;
 
@@ -1366,12 +1366,13 @@ __find_get_block(struct block_device *bd
 	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
 
 	if (bh == NULL) {
+		/* __find_get_block_slow will mark the page accessed */
 		bh = __find_get_block_slow(bdev, block);
 		if (bh)
 			bh_lru_install(bh);
-	}
-	if (bh)
+	} else
 		touch_buffer(bh);
+
 	return bh;
 }
 EXPORT_SYMBOL(__find_get_block);
diff -puN fs/ext4/mballoc.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/ext4/mballoc.c
@@ -1044,6 +1044,8 @@ int ext4_mb_init_group(struct super_bloc
 	 * allocating. If we are looking at the buddy cache we would
 	 * have taken a reference using ext4_mb_load_buddy and that
 	 * would have pinned buddy page to page cache.
+	 * The call to ext4_mb_get_buddy_page_lock will mark the
+	 * page accessed.
 	 */
 	ret = ext4_mb_get_buddy_page_lock(sb, group, &e4b);
 	if (ret || !EXT4_MB_GRP_NEED_INIT(this_grp)) {
@@ -1062,7 +1064,6 @@ int ext4_mb_init_group(struct super_bloc
 		ret = -EIO;
 		goto err;
 	}
-	mark_page_accessed(page);
 
 	if (e4b.bd_buddy_page == NULL) {
 		/*
@@ -1082,7 +1083,6 @@ int ext4_mb_init_group(struct super_bloc
 		ret = -EIO;
 		goto err;
 	}
-	mark_page_accessed(page);
 err:
 	ext4_mb_put_buddy_page_lock(&e4b);
 	return ret;
@@ -1141,7 +1141,7 @@ ext4_mb_load_buddy(struct super_block *s
 
 	/* we could use find_or_create_page(), but it locks page
 	 * what we'd like to avoid in fast path ... */
-	page = find_get_page(inode->i_mapping, pnum);
+	page = find_get_page_flags(inode->i_mapping, pnum, FGP_ACCESSED);
 	if (page == NULL || !PageUptodate(page)) {
 		if (page)
 			/*
@@ -1176,15 +1176,16 @@ ext4_mb_load_buddy(struct super_block *s
 		ret = -EIO;
 		goto err;
 	}
+
+	/* Pages marked accessed already */
 	e4b->bd_bitmap_page = page;
 	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
-	mark_page_accessed(page);
 
 	block++;
 	pnum = block / blocks_per_page;
 	poff = block % blocks_per_page;
 
-	page = find_get_page(inode->i_mapping, pnum);
+	page = find_get_page_flags(inode->i_mapping, pnum, FGP_ACCESSED);
 	if (page == NULL || !PageUptodate(page)) {
 		if (page)
 			page_cache_release(page);
@@ -1209,9 +1210,10 @@ ext4_mb_load_buddy(struct super_block *s
 		ret = -EIO;
 		goto err;
 	}
+
+	/* Pages marked accessed already */
 	e4b->bd_buddy_page = page;
 	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
-	mark_page_accessed(page);
 
 	BUG_ON(e4b->bd_bitmap_page == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
diff -puN fs/f2fs/checkpoint.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/f2fs/checkpoint.c
@@ -69,7 +69,6 @@ repeat:
 		goto repeat;
 	}
 out:
-	mark_page_accessed(page);
 	return page;
 }
 
@@ -137,13 +136,11 @@ int ra_meta_pages(struct f2fs_sb_info *s
 		if (!page)
 			continue;
 		if (PageUptodate(page)) {
-			mark_page_accessed(page);
 			f2fs_put_page(page, 1);
 			continue;
 		}
 
 		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
-		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
 	}
 out:
diff -puN fs/f2fs/node.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/f2fs/node.c
@@ -967,7 +967,6 @@ repeat:
 		goto repeat;
 	}
 got_it:
-	mark_page_accessed(page);
 	return page;
 }
 
@@ -1022,7 +1021,6 @@ page_hit:
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-	mark_page_accessed(page);
 	return page;
 }
 
diff -puN fs/fuse/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/fuse/file.c
--- a/fs/fuse/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/fuse/file.c
@@ -1089,8 +1089,6 @@ static ssize_t fuse_fill_write_pages(str
 		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
 		flush_dcache_page(page);
 
-		mark_page_accessed(page);
-
 		if (!tmp) {
 			unlock_page(page);
 			page_cache_release(page);
diff -puN fs/gfs2/aops.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/gfs2/aops.c
--- a/fs/gfs2/aops.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/gfs2/aops.c
@@ -577,7 +577,6 @@ int gfs2_internal_read(struct gfs2_inode
 		p = kmap_atomic(page);
 		memcpy(buf + copied, p + offset, amt);
 		kunmap_atomic(p);
-		mark_page_accessed(page);
 		page_cache_release(page);
 		copied += amt;
 		index++;
diff -puN fs/gfs2/meta_io.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/gfs2/meta_io.c
--- a/fs/gfs2/meta_io.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/gfs2/meta_io.c
@@ -136,7 +136,8 @@ struct buffer_head *gfs2_getbuf(struct g
 			yield();
 		}
 	} else {
-		page = find_lock_page(mapping, index);
+		page = find_get_page_flags(mapping, index,
+						FGP_LOCK|FGP_ACCESSED);
 		if (!page)
 			return NULL;
 	}
@@ -153,7 +154,6 @@ struct buffer_head *gfs2_getbuf(struct g
 		map_bh(bh, sdp->sd_vfs, blkno);
 
 	unlock_page(page);
-	mark_page_accessed(page);
 	page_cache_release(page);
 
 	return bh;
diff -puN fs/ntfs/attrib.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/ntfs/attrib.c
--- a/fs/ntfs/attrib.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/ntfs/attrib.c
@@ -1748,7 +1748,6 @@ int ntfs_attr_make_non_resident(ntfs_ino
 	if (page) {
 		set_page_dirty(page);
 		unlock_page(page);
-		mark_page_accessed(page);
 		page_cache_release(page);
 	}
 	ntfs_debug("Done.");
diff -puN fs/ntfs/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/fs/ntfs/file.c
@@ -2060,7 +2060,6 @@ static ssize_t ntfs_file_buffered_write(
 		}
 		do {
 			unlock_page(pages[--do_pages]);
-			mark_page_accessed(pages[do_pages]);
 			page_cache_release(pages[do_pages]);
 		} while (do_pages);
 		if (unlikely(status))
diff -puN include/linux/page-flags.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/include/linux/page-flags.h
@@ -198,6 +198,7 @@ struct page;	/* forward declaration */
 TESTPAGEFLAG(Locked, locked)
 PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
+	__SETPAGEFLAG(Referenced, referenced)
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
diff -puN include/linux/pagemap.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/include/linux/pagemap.h
@@ -259,12 +259,109 @@ pgoff_t page_cache_next_hole(struct addr
 pgoff_t page_cache_prev_hole(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
 
+#define FGP_ACCESSED		0x00000001
+#define FGP_LOCK		0x00000002
+#define FGP_CREAT		0x00000004
+#define FGP_WRITE		0x00000008
+#define FGP_NOFS		0x00000010
+#define FGP_NOWAIT		0x00000020
+
+struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
+		int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask);
+
+/**
+ * find_get_page - find and get a page reference
+ * @mapping: the address_space to search
+ * @offset: the page index
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned with an increased refcount.
+ *
+ * Otherwise, %NULL is returned.
+ */
+static inline struct page *find_get_page(struct address_space *mapping,
+					pgoff_t offset)
+{
+	return pagecache_get_page(mapping, offset, 0, 0, 0);
+}
+
+static inline struct page *find_get_page_flags(struct address_space *mapping,
+					pgoff_t offset, int fgp_flags)
+{
+	return pagecache_get_page(mapping, offset, fgp_flags, 0, 0);
+}
+
+/**
+ * find_lock_page - locate, pin and lock a pagecache page
+ * pagecache_get_page - find and get a page reference
+ * @mapping: the address_space to search
+ * @offset: the page index
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned locked and with an increased
+ * refcount.
+ *
+ * Otherwise, %NULL is returned.
+ *
+ * find_lock_page() may sleep.
+ */
+static inline struct page *find_lock_page(struct address_space *mapping,
+					pgoff_t offset)
+{
+	return pagecache_get_page(mapping, offset, FGP_LOCK, 0, 0);
+}
+
+/**
+ * find_or_create_page - locate or add a pagecache page
+ * @mapping: the page's address_space
+ * @index: the page's index into the mapping
+ * @gfp_mask: page allocation mode
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned locked and with an increased
+ * refcount.
+ *
+ * If the page is not present, a new page is allocated using @gfp_mask
+ * and added to the page cache and the VM's LRU list.  The page is
+ * returned locked and with an increased refcount.
+ *
+ * On memory exhaustion, %NULL is returned.
+ *
+ * find_or_create_page() may sleep, even if @gfp_flags specifies an
+ * atomic allocation!
+ */
+static inline struct page *find_or_create_page(struct address_space *mapping,
+					pgoff_t offset, gfp_t gfp_mask)
+{
+	return pagecache_get_page(mapping, offset,
+					FGP_LOCK|FGP_ACCESSED|FGP_CREAT,
+					gfp_mask, gfp_mask & GFP_RECLAIM_MASK);
+}
+
+/**
+ * grab_cache_page_nowait - returns locked page at given index in given cache
+ * @mapping: target address_space
+ * @index: the page index
+ *
+ * Same as grab_cache_page(), but do not wait if the page is unavailable.
+ * This is intended for speculative data generators, where the data can
+ * be regenerated if the page couldn't be grabbed.  This routine should
+ * be safe to call while holding the lock for another page.
+ *
+ * Clear __GFP_FS when allocating the page to avoid recursion into the fs
+ * and deadlock against the caller's locked page.
+ */
+static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
+				pgoff_t index)
+{
+	return pagecache_get_page(mapping, index,
+			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			mapping_gfp_mask(mapping),
+			GFP_NOFS);
+}
+
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
-struct page *find_get_page(struct address_space *mapping, pgoff_t offset);
 struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
-struct page *find_lock_page(struct address_space *mapping, pgoff_t offset);
-struct page *find_or_create_page(struct address_space *mapping, pgoff_t index,
-				 gfp_t gfp_mask);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
@@ -287,8 +384,6 @@ static inline struct page *grab_cache_pa
 	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
 }
 
-extern struct page * grab_cache_page_nowait(struct address_space *mapping,
-				pgoff_t index);
 extern struct page * read_cache_page(struct address_space *mapping,
 				pgoff_t index, filler_t *filler, void *data);
 extern struct page * read_cache_page_gfp(struct address_space *mapping,
diff -puN include/linux/swap.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible include/linux/swap.h
--- a/include/linux/swap.h~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/include/linux/swap.h
@@ -311,6 +311,7 @@ extern void lru_add_page_tail(struct pag
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
+extern void init_page_accessed(struct page *page);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
diff -puN mm/filemap.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible mm/filemap.c
--- a/mm/filemap.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/mm/filemap.c
@@ -982,26 +982,6 @@ out:
 EXPORT_SYMBOL(find_get_entry);
 
 /**
- * find_get_page - find and get a page reference
- * @mapping: the address_space to search
- * @offset: the page index
- *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned with an increased refcount.
- *
- * Otherwise, %NULL is returned.
- */
-struct page *find_get_page(struct address_space *mapping, pgoff_t offset)
-{
-	struct page *page = find_get_entry(mapping, offset);
-
-	if (radix_tree_exceptional_entry(page))
-		page = NULL;
-	return page;
-}
-EXPORT_SYMBOL(find_get_page);
-
-/**
  * find_lock_entry - locate, pin and lock a page cache entry
  * @mapping: the address_space to search
  * @offset: the page cache index
@@ -1038,66 +1018,84 @@ repeat:
 EXPORT_SYMBOL(find_lock_entry);
 
 /**
- * find_lock_page - locate, pin and lock a pagecache page
+ * pagecache_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
+ * @fgp_flags: PCG flags
+ * @gfp_mask: gfp mask to use if a page is to be allocated
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned locked and with an increased
- * refcount.
+ * Looks up the page cache slot at @mapping & @offset.
  *
- * Otherwise, %NULL is returned.
+ * PCG flags modify how the page is returned
  *
- * find_lock_page() may sleep.
- */
-struct page *find_lock_page(struct address_space *mapping, pgoff_t offset)
-{
-	struct page *page = find_lock_entry(mapping, offset);
-
-	if (radix_tree_exceptional_entry(page))
-		page = NULL;
-	return page;
-}
-EXPORT_SYMBOL(find_lock_page);
-
-/**
- * find_or_create_page - locate or add a pagecache page
- * @mapping: the page's address_space
- * @index: the page's index into the mapping
- * @gfp_mask: page allocation mode
+ * FGP_ACCESSED: the page will be marked accessed
+ * FGP_LOCK: Page is return locked
+ * FGP_CREAT: If page is not present then a new page is allocated using
+ *		@gfp_mask and added to the page cache and the VM's LRU
+ *		list. The page is returned locked and with an increased
+ *		refcount. Otherwise, %NULL is returned.
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned locked and with an increased
- * refcount.
- *
- * If the page is not present, a new page is allocated using @gfp_mask
- * and added to the page cache and the VM's LRU list.  The page is
- * returned locked and with an increased refcount.
+ * If FGP_LOCK or FGP_CREAT are specified then the function may sleep even
+ * if the GFP flags specified for FGP_CREAT are atomic.
  *
- * On memory exhaustion, %NULL is returned.
- *
- * find_or_create_page() may sleep, even if @gfp_flags specifies an
- * atomic allocation!
+ * If there is a page cache page, it is returned with an increased refcount.
  */
-struct page *find_or_create_page(struct address_space *mapping,
-		pgoff_t index, gfp_t gfp_mask)
+struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
+	int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask)
 {
 	struct page *page;
-	int err;
+
 repeat:
-	page = find_lock_page(mapping, index);
-	if (!page) {
-		page = __page_cache_alloc(gfp_mask);
+	page = find_get_entry(mapping, offset);
+	if (radix_tree_exceptional_entry(page))
+		page = NULL;
+	if (!page)
+		goto no_page;
+
+	if (fgp_flags & FGP_LOCK) {
+		if (fgp_flags & FGP_NOWAIT) {
+			if (!trylock_page(page)) {
+				page_cache_release(page);
+				return NULL;
+			}
+		} else {
+			lock_page(page);
+		}
+
+		/* Has the page been truncated? */
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
+		}
+		VM_BUG_ON_PAGE(page->index != offset, page);
+	}
+
+	if (page && (fgp_flags & FGP_ACCESSED))
+		mark_page_accessed(page);
+
+no_page:
+	if (!page && (fgp_flags & FGP_CREAT)) {
+		int err;
+		if ((fgp_flags & FGP_WRITE) && mapping_cap_account_dirty(mapping))
+			cache_gfp_mask |= __GFP_WRITE;
+		if (fgp_flags & FGP_NOFS) {
+			cache_gfp_mask &= ~__GFP_FS;
+			radix_gfp_mask &= ~__GFP_FS;
+		}
+
+		page = __page_cache_alloc(cache_gfp_mask);
 		if (!page)
 			return NULL;
-		/*
-		 * We want a regular kernel memory (not highmem or DMA etc)
-		 * allocation for the radix tree nodes, but we need to honour
-		 * the context-specific requirements the caller has asked for.
-		 * GFP_RECLAIM_MASK collects those requirements.
-		 */
-		err = add_to_page_cache_lru(page, mapping, index,
-			(gfp_mask & GFP_RECLAIM_MASK));
+
+		if (WARN_ON_ONCE(!(fgp_flags & FGP_LOCK)))
+			fgp_flags |= FGP_LOCK;
+
+		/* Init accessed so avoit atomic mark_page_accessed later */
+		if (fgp_flags & FGP_ACCESSED)
+			init_page_accessed(page);
+
+		err = add_to_page_cache_lru(page, mapping, offset, radix_gfp_mask);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			page = NULL;
@@ -1105,9 +1103,10 @@ repeat:
 				goto repeat;
 		}
 	}
+
 	return page;
 }
-EXPORT_SYMBOL(find_or_create_page);
+EXPORT_SYMBOL(pagecache_get_page);
 
 /**
  * find_get_entries - gang pagecache lookup
@@ -1404,39 +1403,6 @@ repeat:
 }
 EXPORT_SYMBOL(find_get_pages_tag);
 
-/**
- * grab_cache_page_nowait - returns locked page at given index in given cache
- * @mapping: target address_space
- * @index: the page index
- *
- * Same as grab_cache_page(), but do not wait if the page is unavailable.
- * This is intended for speculative data generators, where the data can
- * be regenerated if the page couldn't be grabbed.  This routine should
- * be safe to call while holding the lock for another page.
- *
- * Clear __GFP_FS when allocating the page to avoid recursion into the fs
- * and deadlock against the caller's locked page.
- */
-struct page *
-grab_cache_page_nowait(struct address_space *mapping, pgoff_t index)
-{
-	struct page *page = find_get_page(mapping, index);
-
-	if (page) {
-		if (trylock_page(page))
-			return page;
-		page_cache_release(page);
-		return NULL;
-	}
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
-	if (page && add_to_page_cache_lru(page, mapping, index, GFP_NOFS)) {
-		page_cache_release(page);
-		page = NULL;
-	}
-	return page;
-}
-EXPORT_SYMBOL(grab_cache_page_nowait);
-
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
@@ -2406,7 +2372,6 @@ int pagecache_write_end(struct file *fil
 {
 	const struct address_space_operations *aops = mapping->a_ops;
 
-	mark_page_accessed(page);
 	return aops->write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 EXPORT_SYMBOL(pagecache_write_end);
@@ -2488,34 +2453,18 @@ EXPORT_SYMBOL(generic_file_direct_write)
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
 					pgoff_t index, unsigned flags)
 {
-	int status;
-	gfp_t gfp_mask;
 	struct page *page;
-	gfp_t gfp_notmask = 0;
+	int fgp_flags = FGP_LOCK|FGP_ACCESSED|FGP_WRITE|FGP_CREAT;
 
-	gfp_mask = mapping_gfp_mask(mapping);
-	if (mapping_cap_account_dirty(mapping))
-		gfp_mask |= __GFP_WRITE;
 	if (flags & AOP_FLAG_NOFS)
-		gfp_notmask = __GFP_FS;
-repeat:
-	page = find_lock_page(mapping, index);
+		fgp_flags |= FGP_NOFS;
+
+	page = pagecache_get_page(mapping, index, fgp_flags,
+			mapping_gfp_mask(mapping),
+			GFP_KERNEL);
 	if (page)
-		goto found;
+		wait_for_stable_page(page);
 
-	page = __page_cache_alloc(gfp_mask & ~gfp_notmask);
-	if (!page)
-		return NULL;
-	status = add_to_page_cache_lru(page, mapping, index,
-						GFP_KERNEL & ~gfp_notmask);
-	if (unlikely(status)) {
-		page_cache_release(page);
-		if (status == -EEXIST)
-			goto repeat;
-		return NULL;
-	}
-found:
-	wait_for_stable_page(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
@@ -2564,7 +2513,7 @@ again:
 
 		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
-		if (unlikely(status))
+		if (unlikely(status < 0))
 			break;
 
 		if (mapping_writably_mapped(mapping))
@@ -2573,7 +2522,6 @@ again:
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		flush_dcache_page(page);
 
-		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))
diff -puN mm/shmem.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible mm/shmem.c
--- a/mm/shmem.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible
+++ a/mm/shmem.c
@@ -1372,9 +1372,13 @@ shmem_write_begin(struct file *file, str
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	int ret;
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
+	if (*pagep)
+		init_page_accessed(*pagep);
+	return ret;
 }
 
 static int
_

Patches currently in -mm which might be from mgorman@suse.de are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
linux-next.patch

