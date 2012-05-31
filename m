From: akpm@linux-foundation.org
Subject: [merged] tmpfs-support-seek_data-and-seek_hole.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:53 -0700
Message-ID: <20120531191553.842B7A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39916 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab2EaTPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:54 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so137962yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, adilger@dilger.ca, andi@firstfloor.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, jeff.liu@oracle.com, josef@redhat.com, marco.stornelli@gmail.com, sunil.mushran@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support SEEK_DATA and SEEK_HOLE
has been removed from the -mm tree.  Its filename was
     tmpfs-support-seek_data-and-seek_hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: support SEEK_DATA and SEEK_HOLE

It's quite easy for tmpfs to scan the radix_tree to support llseek's new
SEEK_DATA and SEEK_HOLE options: so add them while the minutiae are still
on my mind (in particular, the !PageUptodate-ness of pages fallocated but
still unwritten).

But I don't know who actually uses SEEK_DATA or SEEK_HOLE, and whether it
would be of any use to them on tmpfs.  This code adds 92 lines and 752
bytes on x86_64 - is that bloat or worthwhile?

[akpm@linux-foundation.org: fix warning with CONFIG_TMPFS=n]
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jeff liu <jeff.liu@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-support-seek_data-and-seek_hole mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-seek_data-and-seek_hole
+++ a/mm/shmem.c
@@ -1674,6 +1674,98 @@ static ssize_t shmem_file_splice_read(st
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
+	struct address_space *mapping;
+	struct inode *inode;
+	pgoff_t start, end;
+	loff_t new_offset;
+
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek_size(file, offset, origin,
+							MAX_LFS_FILESIZE);
+	mapping = file->f_mapping;
+	inode = mapping->host;
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
@@ -2679,7 +2771,7 @@ static const struct address_space_operat
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

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

