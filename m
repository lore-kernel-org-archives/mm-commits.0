Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228C7C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E562D6100A
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhFAAlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 20:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFAAlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 20:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F242F611CB;
        Tue,  1 Jun 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622508010;
        bh=rowGhHiidfxLrezG/NU6IECOd4+aRZiuZiHC66NCAv0=;
        h=Date:From:To:Subject:From;
        b=2hPesXPEF66w+yQbzhyMa33GER7jBWE6BjCH1nZpmbE17qKGmYDK2XYMehVTbA5yW
         KJNGmC3+afDlecT2BOpU/y9zz931NdPFmEeI2xOqe5BiufA547zufUaJFDOMPnFErk
         A7pnsgz4QG8LLmYcEqPdpEXlANFeMxMLs6oB8J7I=
Date:   Mon, 31 May 2021 17:40:09 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, eugenis@google.com, kostyak@google.com,
        mm-commits@vger.kernel.org, pcc@google.com, peterx@redhat.com
Subject:  +
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch added to
 -mm tree
Message-ID: <20210601004009.GHBJsNnLk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
has been added to the -mm tree.  Its filename is
     mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

With PAGE_FAULT defined (1 page touched) the measurements were
as follows:

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

Link: https://lkml.kernel.org/r/20210527190453.1259020-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I98d75ef90e20330c578871c87494d64b1df3f1b8
Link: [1] https://source.android.com/devices/tech/debug/scudo
Link: [2] https://cs.android.com/android/platform/superproject/+/master:bionic/benchmarks/stdlib_benchmark.cpp;l=53;drc=e8693e78711e8f45ccd2b610e4dbe0b94d551cc9
Link: [3] https://github.com/pcc/llvm-project/commit/scudo-mprotect-secondary2
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Kostya Kortchinsky <kostyak@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once
+++ a/mm/mprotect.c
@@ -35,6 +35,29 @@
 
 #include "internal.h"
 
+static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
+				  unsigned long cp_flags)
+{
+	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
+		if (!(vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE)))
+			return false;
+
+		if (page_count(pte_page(pte)) != 1)
+			return false;
+	}
+
+	if (!pte_dirty(pte))
+		return false;
+
+	if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
+		return false;
+
+	if (pte_uffd_wp(pte))
+		return false;
+
+	return true;
+}
+
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
@@ -43,7 +66,6 @@ static unsigned long change_pte_range(st
 	spinlock_t *ptl;
 	unsigned long pages = 0;
 	int target_node = NUMA_NO_NODE;
-	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
@@ -132,11 +154,8 @@ static unsigned long change_pte_range(st
 			}
 
 			/* Avoid taking write faults for known dirty pages */
-			if (dirty_accountable && pte_dirty(ptent) &&
-					(pte_soft_dirty(ptent) ||
-					 !(vma->vm_flags & VM_SOFTDIRTY))) {
+			if (may_avoid_write_fault(ptent, vma, cp_flags))
 				ptent = pte_mkwrite(ptent);
-			}
 			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

