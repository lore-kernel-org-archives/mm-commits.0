From: akpm@linux-foundation.org
Subject: + tmpfs-revert-seek_data-and-seek_hole.patch added to -mm tree
Date: Mon, 09 Jul 2012 16:37:32 -0700
Message-ID: <20120709233733.BDBDF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:45004 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2GIXhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 19:37:37 -0400
Received: by weyr1 with SMTP id r1so35603wey.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 16:37:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, adilger@dilger.ca, andi@firstfloor.org, chris.mason@fusionio.com, david@fromorbit.com, hch@infradead.org, jeff.liu@oracle.com, josef@redhat.com, marco.stornelli@gmail.com


The patch titled
     Subject: tmpfs: revert SEEK_DATA and SEEK_HOLE
has been added to the -mm tree.  Its filename is
     tmpfs-revert-seek_data-and-seek_hole.patch

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
Subject: tmpfs: revert SEEK_DATA and SEEK_HOLE

Revert 4fb5ef089b28 ("tmpfs: support SEEK_DATA and SEEK_HOLE").  I believe
it's correct, and it's been nice to have from rc1 to rc6; but as the
original commit said:

I don't know who actually uses SEEK_DATA or SEEK_HOLE, and whether it
would be of any use to them on tmpfs.  This code adds 92 lines and 752
bytes on x86_64 - is that bloat or worthwhile?

Nobody asked for it, so I conclude that it's bloat: let's revert tmpfs to
the dumb generic support for v3.5.  We can always reinstate it later if
useful, and anyone needing it in a hurry can just get it out of git.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jeff liu <jeff.liu@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   94 ---------------------------------------------------
 1 file changed, 1 insertion(+), 93 deletions(-)

diff -puN mm/shmem.c~tmpfs-revert-seek_data-and-seek_hole mm/shmem.c
--- a/mm/shmem.c~tmpfs-revert-seek_data-and-seek_hole
+++ a/mm/shmem.c
@@ -1692,98 +1692,6 @@ static ssize_t shmem_file_splice_read(st
 	return error;
 }
 
-/*
- * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
- */
-static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
-				    pgoff_t index, pgoff_t end, int origin)
-{
-	struct page *page;
-	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
-	bool done = false;
-	int i;
-
-	pagevec_init(&pvec, 0);
-	pvec.nr = 1;		/* start small: we may be there already */
-	while (!done) {
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-					pvec.nr, pvec.pages, indices);
-		if (!pvec.nr) {
-			if (origin == SEEK_DATA)
-				index = end;
-			break;
-		}
-		for (i = 0; i < pvec.nr; i++, index++) {
-			if (index < indices[i]) {
-				if (origin == SEEK_HOLE) {
-					done = true;
-					break;
-				}
-				index = indices[i];
-			}
-			page = pvec.pages[i];
-			if (page && !radix_tree_exceptional_entry(page)) {
-				if (!PageUptodate(page))
-					page = NULL;
-			}
-			if (index >= end ||
-			    (page && origin == SEEK_DATA) ||
-			    (!page && origin == SEEK_HOLE)) {
-				done = true;
-				break;
-			}
-		}
-		shmem_deswap_pagevec(&pvec);
-		pagevec_release(&pvec);
-		pvec.nr = PAGEVEC_SIZE;
-		cond_resched();
-	}
-	return index;
-}
-
-static loff_t shmem_file_llseek(struct file *file, loff_t offset, int origin)
-{
-	struct address_space *mapping;
-	struct inode *inode;
-	pgoff_t start, end;
-	loff_t new_offset;
-
-	if (origin != SEEK_DATA && origin != SEEK_HOLE)
-		return generic_file_llseek_size(file, offset, origin,
-							MAX_LFS_FILESIZE);
-	mapping = file->f_mapping;
-	inode = mapping->host;
-	mutex_lock(&inode->i_mutex);
-	/* We're holding i_mutex so we can access i_size directly */
-
-	if (offset < 0)
-		offset = -EINVAL;
-	else if (offset >= inode->i_size)
-		offset = -ENXIO;
-	else {
-		start = offset >> PAGE_CACHE_SHIFT;
-		end = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-		new_offset = shmem_seek_hole_data(mapping, start, end, origin);
-		new_offset <<= PAGE_CACHE_SHIFT;
-		if (new_offset > offset) {
-			if (new_offset < inode->i_size)
-				offset = new_offset;
-			else if (origin == SEEK_DATA)
-				offset = -ENXIO;
-			else
-				offset = inode->i_size;
-		}
-	}
-
-	if (offset >= 0 && offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
-	}
-	mutex_unlock(&inode->i_mutex);
-	return offset;
-}
-
 static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 							 loff_t len)
 {
@@ -2787,7 +2695,7 @@ static const struct address_space_operat
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
-	.llseek		= shmem_file_llseek,
+	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= shmem_file_aio_read,
_
Subject: Subject: tmpfs: revert SEEK_DATA and SEEK_HOLE

Patches currently in -mm which might be from hughd@google.com are

fs-ramfs-file-nommu-add-setpageuptodate.patch
tmpfs-revert-seek_data-and-seek_hole.patch
shmem-fix-negative-rss-in-memcg-memorystat.patch
shmem-cleanup-shmem_add_to_page_cache.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
prio_tree-debugging-patch.patch

