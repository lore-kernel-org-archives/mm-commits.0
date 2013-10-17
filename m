From: akpm@linux-foundation.org
Subject: + readahead-fix-sequential-read-cache-miss-detection.patch added
 to -mm tree
Date: Thu, 17 Oct 2013 13:23:01 -0700
Message-ID: <52604725.DUanFU3hRDHYgeFP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3JQUXC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 16:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pierre.tardy@intel.com, fengguang.wu@intel.com, david.a.cohen@linux.intel.com, damien.ramonda@intel.com

Subject: + readahead-fix-sequential-read-cache-miss-detection.patch added to -mm tree
To: damien.ramonda@intel.com,david.a.cohen@linux.intel.com,fengguang.wu@intel.com,pierre.tardy@intel.com
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 13:23:01 -0700


The patch titled
     Subject: readahead: fix sequential read cache miss detection
has been added to the -mm tree.  Its filename is
     readahead-fix-sequential-read-cache-miss-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/readahead-fix-sequential-read-cache-miss-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/readahead-fix-sequential-read-cache-miss-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Damien Ramonda <damien.ramonda@intel.com>
Subject: readahead: fix sequential read cache miss detection

The kernel's readahead algorithm sometimes interprets random read accesses
as sequential and triggers unnecessary data prefecthing from storage
device (impacting random read average latency).

In order to identify sequential cache read misses, the readahead algorithm
intends to check whether offset - previous offset == 1 (trivial sequential
reads) or offset - previous offset == 0 (sequential reads not aligned on
page boundary):

if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)

The current offset is stored in the "offset" variable of type "pgoff_t"
(unsigned long), while previous offset is stored in "ra->prev_pos" of type
"loff_t" (long long).  Therefore, operands of the if statement are
implicitly converted to type long long.  Consequently, when previous
offset > current offset (which happens on random pattern), the if
condition is true and access is wrongly interpeted as sequential.  An
unnecessary data prefetching is triggered, impacting the average random
read latency.

Storing the previous offset value in a "pgoff_t" variable (unsigned long)
fixes the sequential read detection logic.

Signed-off-by: Damien Ramonda <damien.ramonda@intel.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Pierre Tardy <pierre.tardy@intel.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-fix-sequential-read-cache-miss-detection mm/readahead.c
--- a/mm/readahead.c~readahead-fix-sequential-read-cache-miss-detection
+++ a/mm/readahead.c
@@ -401,6 +401,7 @@ ondemand_readahead(struct address_space
 		   unsigned long req_size)
 {
 	unsigned long max = max_sane_readahead(ra->ra_pages);
+	pgoff_t prev_offset;
 
 	/*
 	 * start of file
@@ -452,8 +453,11 @@ ondemand_readahead(struct address_space
 
 	/*
 	 * sequential cache miss
+	 * trivial case: (offset - prev_offset) == 1
+	 * unaligned reads: (offset - prev_offset) == 0
 	 */
-	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+	prev_offset = (unsigned long long)ra->prev_pos >> PAGE_CACHE_SHIFT;
+	if (offset - prev_offset <= 1UL)
 		goto initial_readahead;
 
 	/*
_

Patches currently in -mm which might be from damien.ramonda@intel.com are

readahead-fix-sequential-read-cache-miss-detection.patch

