From: akpm@linux-foundation.org
Subject: + mm-percpu-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:22:43 -0700
Message-ID: <55f89a33.gD+In16XkNsg81a2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbIOWWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-percpu-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-percpu-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-percpu-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/percpu: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/percpu.c~mm-percpu-use-offset_in_page-macro mm/percpu.c
--- a/mm/percpu.c~mm-percpu-use-offset_in_page-macro
+++ a/mm/percpu.c
@@ -1554,12 +1554,12 @@ int __init pcpu_setup_first_chunk(const
 	PCPU_SETUP_BUG_ON(ai->nr_groups <= 0);
 #ifdef CONFIG_SMP
 	PCPU_SETUP_BUG_ON(!ai->static_size);
-	PCPU_SETUP_BUG_ON((unsigned long)__per_cpu_start & ~PAGE_MASK);
+	PCPU_SETUP_BUG_ON(offset_in_page(__per_cpu_start));
 #endif
 	PCPU_SETUP_BUG_ON(!base_addr);
-	PCPU_SETUP_BUG_ON((unsigned long)base_addr & ~PAGE_MASK);
+	PCPU_SETUP_BUG_ON(offset_in_page(base_addr));
 	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
-	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
+	PCPU_SETUP_BUG_ON(offset_in_page(ai->unit_size));
 	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
 	PCPU_SETUP_BUG_ON(ai->dyn_size < PERCPU_DYNAMIC_EARLY_SIZE);
 	PCPU_SETUP_BUG_ON(pcpu_verify_alloc_info(ai) < 0);
@@ -1806,7 +1806,7 @@ static struct pcpu_alloc_info * __init p
 
 	alloc_size = roundup(min_unit_size, atom_size);
 	upa = alloc_size / min_unit_size;
-	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+	while (alloc_size % upa || (offset_in_page(alloc_size / upa)))
 		upa--;
 	max_upa = upa;
 
@@ -1838,7 +1838,7 @@ static struct pcpu_alloc_info * __init p
 	for (upa = max_upa; upa; upa--) {
 		int allocs = 0, wasted = 0;
 
-		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+		if (alloc_size % upa || (offset_in_page(alloc_size / upa)))
 			continue;
 
 		for (group = 0; group < nr_groups; group++) {
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

