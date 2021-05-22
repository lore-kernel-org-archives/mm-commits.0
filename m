Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C34C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5754B61164
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhEVT4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 15:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhEVT4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 15:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A66D761163;
        Sat, 22 May 2021 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621713323;
        bh=KXlQgwyYX0vsquXz538TQLnrDkKMQQy2FYXUpGSgZSY=;
        h=Date:From:To:Subject:From;
        b=tOs49Dre+7i/R2ZZdzBqmkK4mrVjWypqStXyLq+2/YWsZ0gseJCK1ZwiTP95Hxxqf
         0raETfQzjpnYzobLBtwOnHuJPx8IhKbALlOpnrohJwbzm3VeRc6IC+88rimo2qNILY
         FAJeNnn67qN/q5wKlYJXt7fGRfu1jzX3fRxVuWuY=
Date:   Sat, 22 May 2021 12:55:22 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, khalid.aziz@oracle.com,
        kirill.shutemov@linux.intel.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, pcc@google.com, peterx@redhat.com,
        rppt@linux.ibm.com, walken@google.com, ying.huang@intel.com,
        zi.yan@cs.rutgers.edu
Subject:  [failures]
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch removed
 from -mm tree
Message-ID: <20210522195522.cR9W0GMvY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
has been removed from the -mm tree.  Its filename was
     mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: improve mprotect(R|W) efficiency on pages referenced once

In the Scudo memory allocator [1] we would like to be able to detect
use-after-free vulnerabilities involving large allocations by issuing
mprotect(PROT_NONE) on the memory region used for the allocation when it
is deallocated.  Later on, after the memory region has been "quarantined"
for a sufficient period of time we would like to be able to use it for
another allocation by issuing mprotect(PROT_READ|PROT_WRITE).

Before this patch, after removing the write protection, any writes to the
memory region would result in page faults and entering the copy-on-write
code path, even in the usual case where the pages are only referenced by a
single PTE, harming performance unnecessarily.  Make it so that any pages
in anonymous mappings that are only referenced by a single PTE are
immediately made writable during the mprotect so that we can avoid the
page faults.

This program shows the critical syscall sequence that we intend to use in
the allocator:

  #include <string.h>
  #include <sys/mman.h>

  enum { kSize = 131072 };

  int main(int argc, char **argv) {
    char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
                              MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    for (int i = 0; i != 100000; ++i) {
      memset(addr, i, kSize);
      mprotect((void *)addr, kSize, PROT_NONE);
      mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
    }
  }

The effect of this patch on the above program was measured on a
DragonBoard 845c by taking the median real time execution time of 10 runs.

Before: 2.94s
After:  0.66s

The effect was also measured using one of the microbenchmarks that we
normally use to benchmark the allocator [2], after modifying it to make
the appropriate mprotect calls [3].  With an allocation size of 131072
bytes to trigger the allocator's "large allocation" code path the
per-iteration time was measured as follows:

Before: 27450ns
After:   6010ns

This patch means that we do more work during the mprotect call itself in
exchange for less work when the pages are accessed.  In the worst case,
the pages are not accessed at all.  The effect of this patch in such cases
was measured using the following program:

  #include <string.h>
  #include <sys/mman.h>

  enum { kSize = 131072 };

  int main(int argc, char **argv) {
    char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
                              MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    memset(addr, 1, kSize);
    for (int i = 0; i != 100000; ++i) {
  #ifdef PAGE_FAULT
      memset(addr + (i * 4096) % kSize, i, 4096);
  #endif
      mprotect((void *)addr, kSize, PROT_NONE);
      mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
    }
  }

With PAGE_FAULT undefined (0 pages touched after removing write
protection) the median real time execution time of 100 runs was measured
as follows:

Before: 0.330260s
After:  0.338836s

With PAGE_FAULT defined (1 page touched) the measurements were as follows:

Before: 0.438048s
After:  0.355661s

So it seems that even with a single page fault the new approach is faster.

I saw similar results if I adjusted the programs to use a larger mapping
size.  With kSize = 1048576 I get these numbers with PAGE_FAULT undefined:

Before: 1.428988s
After:  1.512016s

i.e. around 5.5%.

And these with PAGE_FAULT defined:

Before: 1.518559s
After:  1.524417s

i.e. about the same.

What I think we may conclude from these results is that for smaller
mappings the advantage of the previous approach, although measurable, is
wiped out by a single page fault.  I think we may expect that there should
be at least one access resulting in a page fault (under the previous
approach) after making the pages writable, since the program presumably
made the pages writable for a reason.

For larger mappings we may guesstimate that the new approach wins if the
density of future page faults is > 0.4%.  But for the mappings that are
large enough for density to matter (not just the absolute number of page
faults) it doesn't seem like the increase in mprotect latency would be
very large relative to the total mprotect execution time.

[akpm@linux-foundation.org: avoid 80-column tricks]
Link: https://lkml.kernel.org/r/20210429214801.2583336-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I98d75ef90e20330c578871c87494d64b1df3f1b8
Link: [1] https://source.android.com/devices/tech/debug/scudo
Link: [2] https://cs.android.com/android/platform/superproject/+/master:bionic/benchmarks/stdlib_benchmark.cpp;l=53;drc=e8693e78711e8f45ccd2b610e4dbe0b94d551cc9
Link: [3] https://github.com/pcc/llvm-project/commit/scudo-mprotect-secondary2
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once
+++ a/mm/mprotect.c
@@ -47,6 +47,9 @@ static unsigned long change_pte_range(st
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool anon_writable;
+
+	anon_writable = vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE);
 
 	/*
 	 * Can be called with only the mmap_lock for reading by
@@ -132,9 +135,12 @@ static unsigned long change_pte_range(st
 			}
 
 			/* Avoid taking write faults for known dirty pages */
-			if (dirty_accountable && pte_dirty(ptent) &&
-					(pte_soft_dirty(ptent) ||
-					 !(vma->vm_flags & VM_SOFTDIRTY))) {
+			if ((dirty_accountable ||
+			     (anon_writable &&
+			      page_mapcount(pte_page(ptent)) == 1)) &&
+			    pte_dirty(ptent) &&
+			    (pte_soft_dirty(ptent) ||
+			     !(vma->vm_flags & VM_SOFTDIRTY))) {
 				ptent = pte_mkwrite(ptent);
 			}
 			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
_

Patches currently in -mm which might be from pcc@google.com are


