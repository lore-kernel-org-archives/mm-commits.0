Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35F75FF18
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+aGWQ5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ECFC433C8;
	Wed, 13 Dec 2023 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702498236;
	bh=Khf70ot3Kh9MZ9gotyrzb33WUPZZVE0pljKSf++nHRg=;
	h=Date:To:From:Subject:From;
	b=B+aGWQ5vBoopAT33/IGjJO70kyZNydzytIRoKhTx/OmREWoPYbhn0YLnYwzCk8KU/
	 BdO/ebFb9zZWYd+ALs4d5HBUKciYRON51NrSnMPG7cIYPzWdzPAdt9z3SJ+6n0/ZS+
	 mU+QA0I8n/C22rYRYjOUl8yURBz3mkL/h8uCDnZI=
Date: Wed, 13 Dec 2023 12:10:35 -0800
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,tytso@mit.edu,stable@kernel.org,ritesh.list@gmail.com,jack@suse.cz,hch@infradead.org,david@fromorbit.com,adilger.kernel@dilger.ca,libaokun1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch added to mm-hotfixes-unstable branch
Message-Id: <20231213201036.18ECFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: avoid buffered read/write race to read inconsistent data
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: <stable@kernel.org>
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

mm-filemap-avoid-buffered-read-write-race-to-read-inconsistent-data.patch

