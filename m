From: akpm@linux-foundation.org
Subject: + tmpfs-support-seek_data-and-seek_hole-reprise.patch added to -mm tree
Date: Thu, 29 Nov 2012 14:38:33 -0800
Message-ID: <20121129223833.ED316100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:34233 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2K2Wig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 17:38:36 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so3301491oag.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 14:38:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, adilger@dilger.ca, andi@firstfloor.org, chris.mason@fusionio.com, david@fromorbit.com, eggert@cs.ucla.edu, hch@infradead.org, jaegeuk.hanse@gmail.com, jeff.liu@oracle.com, josef@redhat.com, marco.stornelli@gmail.com, sunil.mushran@oracle.com, tytso@mit.edu, wenqing.lz@taobao.com


The patch titled
     Subject: tmpfs: support SEEK_DATA and SEEK_HOLE (reprise)
has been added to the -mm tree.  Its filename is
     tmpfs-support-seek_data-and-seek_hole-reprise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: support SEEK_DATA and SEEK_HOLE (reprise)

Revert 3.5's f21f8062201f ("tmpfs: revert SEEK_DATA and SEEK_HOLE") to
reinstate 4fb5ef089b28 ("tmpfs: support SEEK_DATA and SEEK_HOLE"), with
the intervening additional arg to generic_file_llseek_size().

In 3.8, ext4 is expected to join btrfs, ocfs2 and xfs with proper
SEEK_DATA and SEEK_HOLE support; and a good case has now been made for it
on tmpfs, so let's join the party.

It's quite easy for tmpfs to scan the radix_tree to support llseek's new
SEEK_DATA and SEEK_HOLE options: so add them while the minutiae are still
on my mind (in particular, the !PageUptodate-ness of pages fallocated but
still unwritten).

[akpm@linux-foundation.org: fix warning with CONFIG_TMPFS=n]
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <wenqing.lz@taobao.com>
Cc: Jeff liu <jeff.liu@oracle.com>
Cc: Paul Eggert <eggert@cs.ucla.edu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-support-seek_data-and-seek_hole-reprise mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-seek_data-and-seek_hole-reprise
+++ a/mm/shmem.c
@@ -1709,6 +1709,96 @@ static ssize_t shmem_file_splice_read(st
 	return error;
 }
 
+/*
+ * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
+ */
+static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
+				    pgoff_t index, pgoff_t end, int origin)
+{
+	struct page *page;
+	struct pagevec pvec;
+	pgoff_t indices[PAGEVEC_SIZE];
+	bool done = false;
+	int i;
+
+	pagevec_init(&pvec, 0);
+	pvec.nr = 1;		/* start small: we may be there already */
+	while (!done) {
+		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+					pvec.nr, pvec.pages, indices);
+		if (!pvec.nr) {
+			if (origin == SEEK_DATA)
+				index = end;
+			break;
+		}
+		for (i = 0; i < pvec.nr; i++, index++) {
+			if (index < indices[i]) {
+				if (origin == SEEK_HOLE) {
+					done = true;
+					break;
+				}
+				index = indices[i];
+			}
+			page = pvec.pages[i];
+			if (page && !radix_tree_exceptional_entry(page)) {
+				if (!PageUptodate(page))
+					page = NULL;
+			}
+			if (index >= end ||
+			    (page && origin == SEEK_DATA) ||
+			    (!page && origin == SEEK_HOLE)) {
+				done = true;
+				break;
+			}
+		}
+		shmem_deswap_pagevec(&pvec);
+		pagevec_release(&pvec);
+		pvec.nr = PAGEVEC_SIZE;
+		cond_resched();
+	}
+	return index;
+}
+
+static loff_t shmem_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	pgoff_t start, end;
+	loff_t new_offset;
+
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek_size(file, offset, origin,
+					MAX_LFS_FILESIZE, i_size_read(inode));
+	mutex_lock(&inode->i_mutex);
+	/* We're holding i_mutex so we can access i_size directly */
+
+	if (offset < 0)
+		offset = -EINVAL;
+	else if (offset >= inode->i_size)
+		offset = -ENXIO;
+	else {
+		start = offset >> PAGE_CACHE_SHIFT;
+		end = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		new_offset = shmem_seek_hole_data(mapping, start, end, origin);
+		new_offset <<= PAGE_CACHE_SHIFT;
+		if (new_offset > offset) {
+			if (new_offset < inode->i_size)
+				offset = new_offset;
+			else if (origin == SEEK_DATA)
+				offset = -ENXIO;
+			else
+				offset = inode->i_size;
+		}
+	}
+
+	if (offset >= 0 && offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+	mutex_unlock(&inode->i_mutex);
+	return offset;
+}
+
 static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 							 loff_t len)
 {
@@ -2580,7 +2670,7 @@ static const struct address_space_operat
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
-	.llseek		= generic_file_llseek,
+	.llseek		= shmem_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= shmem_file_aio_read,
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-trace-filemap-add-and-del.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

