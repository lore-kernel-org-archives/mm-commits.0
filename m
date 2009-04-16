From: akpm@linux-foundation.org
Subject: + readahead-enforce-full-sync-mmap-readahead-size.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:00:44 -0700
Message-ID: <200904162300.n3GN0jnG007988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbZDPXCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     readahead: enforce full sync mmap readahead size
has been added to the -mm tree.  Its filename is
     readahead-enforce-full-sync-mmap-readahead-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch

