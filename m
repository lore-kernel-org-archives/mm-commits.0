From: akpm@linux-foundation.org
Subject: + readahead-sequential-mmap-readahead.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:20 -0700
Message-ID: <200904102339.n3ANdL0L021316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZDJXmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     readahead: sequential mmap readahead
has been added to the -mm tree.  Its filename is
     readahead-sequential-mmap-readahead.patch

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
Subject: readahead: sequential mmap readahead
From: Wu Fengguang <fengguang.wu@intel.com>

Auto-detect sequential mmap reads and do readahead for them.

The sequential mmap readahead will be triggered when
- sync readahead: it's a major fault and (prev_offset == offset-1);
- async readahead: minor fault on PG_readahead page with valid readahead state.

The benefits of doing readahead instead of read-around:
- less I/O wait thanks to async readahead
- double real I/O size and no more cache hits

The single stream case is improved a little.
For 100,000 sequential mmap reads:

                                    user       system    cpu        total
(1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
(1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
(2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607

The patched (2) has smallest total time, since it has no cache hit overheads
and less I/O block time(thanks to async readahead). Here the I/O size
makes no much difference, since there's only one single stream.

Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is 128KB,
since the half of the read-around pages will be readahead cache hits.

This is going to make _real_ differences for _concurrent_ IO streams.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-sequential-mmap-readahead mm/filemap.c
--- a/mm/filemap.c~readahead-sequential-mmap-readahead
+++ a/mm/filemap.c
@@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
 	if (VM_RandomReadHint(vma))
 		return;
 
-	if (VM_SequentialReadHint(vma)) {
+	if (VM_SequentialReadHint(vma) ||
+			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
 		page_cache_sync_readahead(mapping, ra, file, offset, 1);
 		return;
 	}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

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

