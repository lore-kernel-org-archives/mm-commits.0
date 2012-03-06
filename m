From: akpm@linux-foundation.org
Subject: + mm-update-stale-lock-ordering-comment-for-memory-failurec.patch added to -mm tree
Date: Tue, 06 Mar 2012 14:17:38 -0800
Message-ID: <20120306221738.865D1A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54489 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab2CFWRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 17:17:39 -0500
Received: by yenq2 with SMTP id q2so704655yen.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 14:17:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, a.p.zijlstra@chello.nl


The patch titled
     Subject: mm: update stale lock ordering comment for memory-failure.c
has been added to the -mm tree.  Its filename is
     mm-update-stale-lock-ordering-comment-for-memory-failurec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm: update stale lock ordering comment for memory-failure.c

When i_mmap_lock changed to a mutex the locking order in memory failure
was changed to take the sleeping lock first.  But the big fat mm lock
ordering comment (BFMLO) wasn't updated.  Do this here.

Pointed out by Andrew.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-update-stale-lock-ordering-comment-for-memory-failurec mm/filemap.c
--- a/mm/filemap.c~mm-update-stale-lock-ordering-comment-for-memory-failurec
+++ a/mm/filemap.c
@@ -101,9 +101,8 @@
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
- *  (code doesn't rely on that order, so you could switch it around)
- *  ->tasklist_lock             (memory_failure, collect_procs_ao)
- *    ->i_mmap_mutex
+ * ->i_mmap_mutex
+ *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
 /*
_
Subject: Subject: mm: update stale lock ordering comment for memory-failure.c

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
mm-update-stale-lock-ordering-comment-for-memory-failurec.patch
brlocks-lglocks-cleanups.patch

