Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2CF481C3;
	Wed, 20 Dec 2023 21:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gf/1O5Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51FEC433C8;
	Wed, 20 Dec 2023 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108833;
	bh=YxQg0ayPzcJ9Oioh9/Gi7OjLWQNSoA7qvrbbxdqrCoc=;
	h=Date:To:From:Subject:From;
	b=gf/1O5HayrwdY0WSqR1HrDOdQdwgzvmegRpa+BCAhyUcWPnK54LRn07C6BptFcXhm
	 XVVkrauE8drN4N7NN+YCwrMOaNeLfLXV5dBAEJDFxRruIFLlRym2+Ox2pu2vTc0KUK
	 mhrXtNtntw/1C81ffkzoLZ9n3doTDryo5xFRGzi0=
Date: Wed, 20 Dec 2023 13:47:13 -0800
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,tytso@mit.edu,stable@vger.kernel.org,ritesh.list@gmail.com,jack@suse.cz,hch@infradead.org,david@fromorbit.com,adilger.kernel@dilger.ca,libaokun1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch removed from -mm tree
Message-Id: <20231220214713.A51FEC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: avoid buffered read/write race to read inconsistent data
has been removed from the -mm tree.  Its filename was
     mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baokun Li <libaokun1@huawei.com>
Subject: mm/filemap: avoid buffered read/write race to read inconsistent data
Date: Wed, 13 Dec 2023 14:23:24 +0800

The following concurrency may cause the data read to be inconsistent with
the data on disk:

             cpu1                           cpu2
------------------------------|------------------------------
                               // Buffered write 2048 from 0
                               ext4_buffered_write_iter
                                generic_perform_write
                                 copy_page_from_iter_atomic
                                 ext4_da_write_end
                                  ext4_da_do_write_end
                                   block_write_end
                                    __block_commit_write
                                     folio_mark_uptodate
// Buffered read 4096 from 0          smp_wmb()
ext4_file_read_iter                   set_bit(PG_uptodate, folio_flags)
 generic_file_read_iter            i_size_write // 2048
  filemap_read                     unlock_page(page)
   filemap_get_pages
    filemap_get_read_batch
    folio_test_uptodate(folio)
     ret = test_bit(PG_uptodate, folio_flags)
     if (ret)
      smp_rmb();
      // Ensure that the data in page 0-2048 is up-to-date.

                               // New buffered write 2048 from 2048
                               ext4_buffered_write_iter
                                generic_perform_write
                                 copy_page_from_iter_atomic
                                 ext4_da_write_end
                                  ext4_da_do_write_end
                                   block_write_end
                                    __block_commit_write
                                     folio_mark_uptodate
                                      smp_wmb()
                                      set_bit(PG_uptodate, folio_flags)
                                   i_size_write // 4096
                                   unlock_page(page)

   isize = i_size_read(inode) // 4096
   // Read the latest isize 4096, but without smp_rmb(), there may be
   // Load-Load disorder resulting in the data in the 2048-4096 range
   // in the page is not up-to-date.
   copy_page_to_iter
   // copyout 4096

In the concurrency above, we read the updated i_size, but there is no read
barrier to ensure that the data in the page is the same as the i_size at
this point, so we may copy the unsynchronized page out.  Hence adding the
missing read memory barrier to fix this.

This is a Load-Load reordering issue, which only occurs on some weak
mem-ordering architectures (e.g.  ARM64, ALPHA), but not on strong
mem-ordering architectures (e.g.  X86).  And theoretically the problem
doesn't only happen on ext4, filesystems that call filemap_read() but
don't hold inode lock (e.g.  btrfs, f2fs, ubifs ...) will have this
problem, while filesystems with inode lock (e.g.  xfs, nfs) won't have
this problem.

Link: https://lkml.kernel.org/r/20231213062324.739009-1-libaokun1@huawei.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/filemap.c~mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data
+++ a/mm/filemap.c
@@ -2608,6 +2608,15 @@ ssize_t filemap_read(struct kiocb *iocb,
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
 		/*
+		 * Pairs with a barrier in
+		 * block_write_end()->mark_buffer_dirty() or other page
+		 * dirtying routines like iomap_write_end() to ensure
+		 * changes to page contents are visible before we see
+		 * increased inode size.
+		 */
+		smp_rmb();
+
+		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
 		 */
_

Patches currently in -mm which might be from libaokun1@huawei.com are


