From: akpm@linux-foundation.org
Subject: + mm-do_sync_mapping_range-integrity-fix.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:46 -0700
Message-ID: <200810302314.m9UNEkrE027598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbYJ3XP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: do_sync_mapping_range integrity fix
has been added to the -mm tree.  Its filename is
     mm-do_sync_mapping_range-integrity-fix.patch

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
Subject: mm: do_sync_mapping_range integrity fix
From: Nick Piggin <npiggin@suse.de>

Chris Mason notices do_sync_mapping_range didn't actually ask for data
integrity writeout.  Unfortunately, it is advertised as being usable for
data integrity operations.

This is a data integrity bug.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: jim owens <jowens@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sync.c~mm-do_sync_mapping_range-integrity-fix fs/sync.c
--- a/fs/sync.c~mm-do_sync_mapping_range-integrity-fix
+++ a/fs/sync.c
@@ -269,7 +269,7 @@ int do_sync_mapping_range(struct address
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
 		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
-						WB_SYNC_NONE);
+						WB_SYNC_ALL);
 		if (ret < 0)
 			goto out;
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
reiser4.patch

