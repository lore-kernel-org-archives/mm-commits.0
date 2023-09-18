Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BF7CD13D9
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjIRQJ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjIRQJN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:09:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF02649D7
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:07:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485AFC433C9;
        Mon, 18 Sep 2023 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695051660;
        bh=cO4bK2idgM3srF/4uQTX05QpMvF2JVQp32tRCxnQIt8=;
        h=Date:To:From:Subject:From;
        b=G+ltuYDCb42IUSRUuOJmpjs3MwAP4I650X7buwdOYaYz2c+Wkgf3Tdqtbq1hx0XWO
         WVh3fofTQYw+6wx+w9BbwfqzVzU/3hvb2YIyJOQcevbM//OLZ697BEXRSu507hJ8aS
         rB7ZULnm5kRyNI92JuI65Iho3trktpKtrgwfP3RU=
Date:   Mon, 18 Sep 2023 08:40:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org, shy828301@gmail.com,
        ryan.roberts@arm.com, hughd@google.com, david@redhat.com,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-functions-folio_in_range-and-folio_within_vma.patch added to mm-unstable branch
Message-Id: <20230918154100.485AFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add functions folio_in_range() and folio_within_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-functions-folio_in_range-and-folio_within_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-functions-folio_in_range-and-folio_within_vma.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm: add functions folio_in_range() and folio_within_vma()
Date: Mon, 18 Sep 2023 15:33:16 +0800

Patch series "support large folio for mlock", v3.

Yu mentioned at [1] about the mlock() can't be applied to large folio.

I leant the related code and here is my understanding:

- For RLIMIT_MEMLOCK related, there is no problem.  Because the
  RLIMIT_MEMLOCK statistics is not related underneath page.  That means
  underneath page mlock or munlock doesn't impact the RLIMIT_MEMLOCK
  statistics collection which is always correct.

- For keeping the page in RAM, there is no problem either.  At least,
  during try_to_unmap_one(), once detect the VMA has VM_LOCKED bit set in
  vm_flags, the folio will be kept whatever the folio is mlocked or not.

So the function of mlock for large folio works.  But it's not optimized
because the page reclaim needs scan these large folio and may split them.

This series identified the large folio for mlock to four types:
  - The large folio is in VM_LOCKED range and fully mapped to the
    range

  - The large folio is in the VM_LOCKED range but not fully mapped to
    the range

  - The large folio cross VM_LOCKED VMA boundary

  - The large folio cross last level page table boundary

For the first type, we mlock large folio so page reclaim will skip it.

For the second/third type, we don't mlock large folio.  As the pages not
mapped to VM_LOACKED range are mapped to none VM_LOCKED range, if system
is in memory pressure situation, the large folio can be picked by page
reclaim and split.  Then the pages not mapped to VM_LOCKED range can be
reclaimed.

For the fourth type, we don't mlock large folio because locking one page
table lock can't prevent the part in another last level page table being
unmapped.  Thanks to Ryan for pointing this out.


To check whether the folio is fully mapped to the range, PTEs needs be
checked to see whether the page of folio is associated.  Which needs take
page table lock and is heavy operation.  So far, the only place needs this
check is madvise and page reclaim.  These functions already have their own
PTE iterator.

patch1 introduce API to check whether large folio is in VMA range.
patch2 make page reclaim/mlock_vma_folio/munlock_vma_folio support
       large folio mlock/munlock.
patch3 make mlock/munlock syscall support large folio.

Yu also mentioned a race which can make folio unevictable after munlock
during RFC v2 discussion [3]:
We decided that race issue didn't block this series based on:
  - That race issue was not introduced by this series

  - We had a looks-ok fix for that race issue. Need to wait
    for mlock_count fixing patch as Yosry Ahmed suggested [4]

[1] https://lore.kernel.org/linux-mm/CAOUHufbtNPkdktjt_5qM45GegVO-rCFOMkSh0HQminQ12zsV8Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20230809061105.3369958-1-fengwei.yin@intel.com/
[3] https://lore.kernel.org/linux-mm/CAOUHufZ6=9P_=CAOQyw0xw-3q707q-1FVV09dBNDC-hpcpj2Pg@mail.gmail.com/


This patch (of 3):

folio_in_range() will be used to check whether the folio is mapped to
specific VMA and whether the mapping address of folio is in the range.

Also a helper function folio_within_vma() to check whether folio
is in the range of vma based on folio_in_range().

Link: https://lkml.kernel.org/r/20230918073318.1181104-1-fengwei.yin@intel.com
Link: https://lkml.kernel.org/r/20230918073318.1181104-2-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/mm/internal.h~mm-add-functions-folio_in_range-and-folio_within_vma
+++ a/mm/internal.h
@@ -587,6 +587,56 @@ extern long faultin_vma_page_range(struc
 				   bool write, int *locked);
 extern bool mlock_future_ok(struct mm_struct *mm, unsigned long flags,
 			       unsigned long bytes);
+
+/*
+ * NOTE: This function can't tell whether the folio is "fully mapped" in the
+ * range.
+ * "fully mapped" means all the pages of folio is associated with the page
+ * table of range while this function just check whether the folio range is
+ * within the range [start, end). Funcation caller nees to do page table
+ * check if it cares about the page table association.
+ *
+ * Typical usage (like mlock or madvise) is:
+ * Caller knows at least 1 page of folio is associated with page table of VMA
+ * and the range [start, end) is intersect with the VMA range. Caller wants
+ * to know whether the folio is fully associated with the range. It calls
+ * this function to check whether the folio is in the range first. Then checks
+ * the page table to know whether the folio is fully mapped to the range.
+ */
+static inline bool
+folio_within_range(struct folio *folio, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	pgoff_t pgoff, addr;
+	unsigned long vma_pglen = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	VM_WARN_ON_FOLIO(folio_test_ksm(folio), folio);
+	if (start > end)
+		return false;
+
+	if (start < vma->vm_start)
+		start = vma->vm_start;
+
+	if (end > vma->vm_end)
+		end = vma->vm_end;
+
+	pgoff = folio_pgoff(folio);
+
+	/* if folio start address is not in vma range */
+	if (!in_range(pgoff, vma->vm_pgoff, vma_pglen))
+		return false;
+
+	addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+
+	return !(addr < start || end - addr < folio_size(folio));
+}
+
+static inline bool
+folio_within_vma(struct folio *folio, struct vm_area_struct *vma)
+{
+	return folio_within_range(folio, vma, vma->vm_start, vma->vm_end);
+}
+
 /*
  * mlock_vma_folio() and munlock_vma_folio():
  * should be called with vma's mmap_lock held for read or write,
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch
mm-add-functions-folio_in_range-and-folio_within_vma.patch
mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range.patch
mm-mlock-update-mlock_pte_range-to-handle-large-folio.patch

