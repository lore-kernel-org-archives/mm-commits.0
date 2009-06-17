From: akpm@linux-foundation.org
Subject: [merged] readahead-enforce-full-sync-mmap-readahead-size.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:03 -0700
Message-ID: <200906171833.n5HIX301031619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759710AbZFQSdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     readahead: enforce full sync mmap readahead size
has been removed from the -mm tree.  Its filename was
     readahead-enforce-full-sync-mmap-readahead-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: enforce full sync mmap readahead size
From: Wu Fengguang <fengguang.wu@intel.com>

Now that we do readahead for sequential mmap reads, here is a simple
evaluation of the impacts, and one further optimization.

It's an NFS-root debian desktop system, readahead size = 60 pages.
The numbers are grabbed after a fresh boot into console.

approach        pgmajfault      RA miss ratio   mmap IO count   avg IO size(pages)
   A            383             31.6%           383             11
   B            225             32.4%           390             11
   C            224             32.6%           307             13

case A: mmap sync/async readahead disabled
case B: mmap sync/async readahead enabled, with enforced full async readahead size
case C: mmap sync/async readahead enabled, with enforced full sync/async readahead size
or:
A = vanilla 2.6.30-rc1
B = A plus mmap readahead
C = B plus this patch

The numbers show that
- there are good possibilities for random mmap reads to trigger readahead
- 'pgmajfault' is reduced by 1/3, due to the _async_ nature of readahead
- case C can further reduce IO count by 1/4
- readahead miss ratios are not quite affected

The theory is
- readahead is _good_ for clustered random reads, and can perform
  _better_ than readaround because they could be _async_.
- async readahead size is guaranteed to be larger than readaround
  size, and they are _async_, hence will mostly behave better
However for B
- sync readahead size could be smaller than readaround size, hence may
  make things worse by produce more smaller IOs
which will be fixed by this patch.

Final conclusion:
- mmap readahead reduced major faults by 1/3 and no obvious overheads;
- mmap io can be further reduced by 1/4 with this patch.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-enforce-full-sync-mmap-readahead-size mm/filemap.c
--- a/mm/filemap.c~readahead-enforce-full-sync-mmap-readahead-size
+++ a/mm/filemap.c
@@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
-		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		page_cache_sync_readahead(mapping, ra, file, offset,
+					  ra->ra_pages);
 		return;
 	}
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

