From: akpm@linux-foundation.org
Subject: [merged] mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:09 -0700
Message-ID: <20130430185009.8F61D31C22F__29362.0518096306$1367347828$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:42861 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3SuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:10 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so85975qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hughd@google.com, jmarchan@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: mark swap pages writeback before queueing for direct IO
has been removed from the -mm tree.  Its filename was
     mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: swap: mark swap pages writeback before queueing for direct IO

As pointed out by Andrew Morton, the swap-over-NFS writeback is not
setting PageWriteback before it is queued for direct IO.  While swap pages
do not participate in BDI or process dirty accounting and the IO is
synchronous, the writeback bit is still required and not setting it in
this case was an oversight.  swapoff depends on the page writeback to
synchronoise all pending writes on a swap page before it is reused. 
Swapcache freeing and reuse depend on checking the PageWriteback under
lock to ensure the page is safe to reuse.

Direct IO handlers and the direct IO handler for NFS do not deal with
PageWriteback as they are synchronous writes.  In the case of NFS, it
schedules pages (or a page in the case of swap) for IO and then waits
synchronously for IO to complete in nfs_direct_write().  It is recognised
that this is a slowdown from normal swap handling which is asynchronous
and uses a completion handler.  Shoving PageWriteback handling down into
direct IO handlers looks like a bad fit to handle the swap case although
it may have to be dealt with some day if swap is converted to use direct
IO in general and bmap is finally done away with.  At that point it will
be necessary to refit asynchronous direct IO with completion handlers onto
the swap subsystem.

As swapcache currently depends on PageWriteback to protect against races,
this patch sets PageWriteback under the page lock before queueing it for
direct IO.  It is cleared when the direct IO handler returns.  IO errors
are treated similarly to the direct-to-bio case except PageError is not
set as in the case of swap-over-NFS, it is likely to be a transient error.

It was asked what prevents such a page being reclaimed in parallel.  With
this patch applied, such a page will now be skipped (most of the time) or
blocked until the writeback completes.  Reclaim checks PageWriteback under
the page lock before calling try_to_free_swap and the page lock should
prevent the page being requeued for IO before it is freed.

This and Jerome's related patch should considered for -stable as far
back as 3.6 when swap-over-NFS was introduced.

[akpm@linux-foundation.org: use pr_err_ratelimited()]
[akpm@linux-foundation.org: remove hopefully-unneeded cast in printk]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/page_io.c~mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io mm/page_io.c
--- a/mm/page_io.c~mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io
+++ a/mm/page_io.c
@@ -223,6 +223,7 @@ int __swap_writepage(struct page *page,
 		kiocb.ki_left = PAGE_SIZE;
 		kiocb.ki_nbytes = PAGE_SIZE;
 
+		set_page_writeback(page);
 		unlock_page(page);
 		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
 						&kiocb, &iov,
@@ -232,8 +233,22 @@ int __swap_writepage(struct page *page,
 			count_vm_event(PSWPOUT);
 			ret = 0;
 		} else {
+			/*
+			 * In the case of swap-over-nfs, this can be a
+			 * temporary failure if the system has limited
+			 * memory for allocating transmit buffers.
+			 * Mark the page dirty and avoid
+			 * rotate_reclaimable_page but rate-limit the
+			 * messages but do not flag PageError like
+			 * the normal direct-to-bio case as it could
+			 * be temporary.
+			 */
 			set_page_dirty(page);
+			ClearPageReclaim(page);
+			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
+				page_file_offset(page));
 		}
+		end_page_writeback(page);
 		return ret;
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-memmap_init_zone-performance-improvement.patch

