Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9120C00528
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 17:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjHERFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 13:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjHERFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 13:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51A4213;
        Sat,  5 Aug 2023 10:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A85060C59;
        Sat,  5 Aug 2023 17:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB5EC433C7;
        Sat,  5 Aug 2023 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691255107;
        bh=/ZHxou1mqDeLEzINrKjUbe7rElU2zXz1t2FFl19Jp2k=;
        h=Date:To:From:Subject:From;
        b=jugaSIhdtoifD0vFmoZTFFEA6OXJevQ+iAc9ooO1wLGqpPmALlQuyAh/3OvTuS1yG
         G4FTC6DIQuQMcsz2C2hAI5StUvWdBSnOsoOmXRqhFbw++enndZygwPBfdLEOmArZQi
         gTnNgbO+Z0ueAe1jEmDlYelgigecGKezgLwT1jMc=
Date:   Sat, 05 Aug 2023 10:05:05 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        ryan.roberts@arm.com, peterx@redhat.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch added to mm-hotfixes-unstable branch
Message-Id: <20230805170507.9DB5EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: handle cont-PTE hugetlb pages correctly in gup_must_unshare() via GUP-fast
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: handle cont-PTE hugetlb pages correctly in gup_must_unshare() via GUP-fast
Date: Sat, 5 Aug 2023 12:12:56 +0200

In contrast to most other GUP code, GUP-fast common page table walking
code like gup_pte_range() also handles hugetlb pages.  But in contrast to
other hugetlb page table walking code, it does not look at the hugetlb PTE
abstraction whereby we have only a single logical hugetlb PTE per hugetlb
page, even when using multiple cont-PTEs underneath -- which is for
example what huge_ptep_get() abstracts.

So when we have a hugetlb page that is mapped via cont-PTEs, GUP-fast
might stumble over a PTE that does not map the head page of a hugetlb page
-- not the first "head" PTE of such a cont mapping.

Logically, the whole hugetlb page is mapped (entire_mapcount == 1), but we
might end up calling gup_must_unshare() with a tail page of a hugetlb
page.

We only maintain a single PageAnonExclusive flag per hugetlb page (as
hugetlb pages cannot get partially COW-shared), stored for the head page. 
That flag is clear for all tail pages.

So when gup_must_unshare() ends up calling PageAnonExclusive() with a tail
page of a hugetlb page:

1) With CONFIG_DEBUG_VM_PGFLAGS

Stumbles over the:

	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);

For example, when executing the COW selftests with 64k hugetlb pages on
arm64:

  [   61.082187] page:00000000829819ff refcount:3 mapcount:1 mapping:0000000000000000 index:0x1 pfn:0x11ee11
  [   61.082842] head:0000000080f79bf7 order:4 entire_mapcount:1 nr_pages_mapped:0 pincount:2
  [   61.083384] anon flags: 0x17ffff80003000e(referenced|uptodate|dirty|head|mappedtodisk|node=0|zone=2|lastcpupid=0xfffff)
  [   61.084101] page_type: 0xffffffff()
  [   61.084332] raw: 017ffff800000000 fffffc00037b8401 0000000000000402 0000000200000000
  [   61.084840] raw: 0000000000000010 0000000000000000 00000000ffffffff 0000000000000000
  [   61.085359] head: 017ffff80003000e ffffd9e95b09b788 ffffd9e95b09b788 ffff0007ff63cf71
  [   61.085885] head: 0000000000000000 0000000000000002 00000003ffffffff 0000000000000000
  [   61.086415] page dumped because: VM_BUG_ON_PAGE(PageHuge(page) && !PageHead(page))
  [   61.086914] ------------[ cut here ]------------
  [   61.087220] kernel BUG at include/linux/page-flags.h:990!
  [   61.087591] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  [   61.087999] Modules linked in: ...
  [   61.089404] CPU: 0 PID: 4612 Comm: cow Kdump: loaded Not tainted 6.5.0-rc4+ #3
  [   61.089917] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  [   61.090409] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [   61.090897] pc : gup_must_unshare.part.0+0x64/0x98
  [   61.091242] lr : gup_must_unshare.part.0+0x64/0x98
  [   61.091592] sp : ffff8000825eb940
  [   61.091826] x29: ffff8000825eb940 x28: 0000000000000000 x27: fffffc00037b8440
  [   61.092329] x26: 0400000000000001 x25: 0000000000080101 x24: 0000000000080000
  [   61.092835] x23: 0000000000080100 x22: ffff0000cffb9588 x21: ffff0000c8ec6b58
  [   61.093341] x20: 0000ffffad6b1000 x19: fffffc00037b8440 x18: ffffffffffffffff
  [   61.093850] x17: 2864616548656761 x16: 5021202626202965 x15: 6761702865677548
  [   61.094358] x14: 6567615028454741 x13: 2929656761702864 x12: 6165486567615021
  [   61.094858] x11: 00000000ffff7fff x10: 00000000ffff7fff x9 : ffffd9e958b7a1c0
  [   61.095359] x8 : 00000000000bffe8 x7 : c0000000ffff7fff x6 : 00000000002bffa8
  [   61.095873] x5 : ffff0008bb19e708 x4 : 0000000000000000 x3 : 0000000000000000
  [   61.096380] x2 : 0000000000000000 x1 : ffff0000cf6636c0 x0 : 0000000000000046
  [   61.096894] Call trace:
  [   61.097080]  gup_must_unshare.part.0+0x64/0x98
  [   61.097392]  gup_pte_range+0x3a8/0x3f0
  [   61.097662]  gup_pgd_range+0x1ec/0x280
  [   61.097942]  lockless_pages_from_mm+0x64/0x1a0
  [   61.098258]  internal_get_user_pages_fast+0xe4/0x1d0
  [   61.098612]  pin_user_pages_fast+0x58/0x78
  [   61.098917]  pin_longterm_test_start+0xf4/0x2b8
  [   61.099243]  gup_test_ioctl+0x170/0x3b0
  [   61.099528]  __arm64_sys_ioctl+0xa8/0xf0
  [   61.099822]  invoke_syscall.constprop.0+0x7c/0xd0
  [   61.100160]  el0_svc_common.constprop.0+0xe8/0x100
  [   61.100500]  do_el0_svc+0x38/0xa0
  [   61.100736]  el0_svc+0x3c/0x198
  [   61.100971]  el0t_64_sync_handler+0x134/0x150
  [   61.101280]  el0t_64_sync+0x17c/0x180
  [   61.101543] Code: aa1303e0 f00074c1 912b0021 97fffeb2 (d4210000)

2) Without CONFIG_DEBUG_VM_PGFLAGS

Always detects "not exclusive" for passed tail pages and refuses to PIN
the tail pages R/O, as gup_must_unshare() == true.  GUP-fast will fallback
to ordinary GUP.  As ordinary GUP properly considers the logical hugetlb
PTE abstraction in hugetlb_follow_page_mask(), pinning the page will
succeed when looking at the PageAnonExclusive on the head page only.

So the only real effect of this is that with cont-PTE hugetlb pages, we'll
always fallback from GUP-fast to ordinary GUP when not working on the head
page, which ends up checking the head page and do the right thing.

Consequently, the cow selftests pass with cont-PTE hugetlb pages as well
without CONFIG_DEBUG_VM_PGFLAGS.

Note that this only applies to anon hugetlb pages that are mapped using
cont-PTEs: for example 64k hugetlb pages on a 4k arm64 kernel.

... and only when R/O-pinning (FOLL_PIN) such pages that are mapped into
the page table R/O using GUP-fast.

On production kernels (and even most debug kernels, that don't set
CONFIG_DEBUG_VM_PGFLAGS) this patch should theoretically not be required
to be backported.  But of course, it does not hurt.

Link: https://lkml.kernel.org/r/20230805101256.87306-1-david@redhat.com
Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/internal.h~mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast
+++ a/mm/internal.h
@@ -1005,6 +1005,16 @@ static inline bool gup_must_unshare(stru
 		smp_rmb();
 
 	/*
+	 * During GUP-fast we might not get called on the head page for a
+	 * hugetlb page that is mapped using cont-PTE, because GUP-fast does
+	 * not work with the abstracted hugetlb PTEs that always point at the
+	 * head page. For hugetlb, PageAnonExclusive only applies on the head
+	 * page (as it cannot be partially COW-shared), so lookup the head page.
+	 */
+	if (unlikely(!PageHead(page) && PageHuge(page)))
+		page = compound_head(page);
+
+	/*
 	 * Note that PageKsm() pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch
mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch

