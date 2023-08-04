Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABB7C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjHDScp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjHDSbp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B20C559D
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E90E620BC
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77073C433C8;
        Fri,  4 Aug 2023 18:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691173692;
        bh=0Wj4vov6kbYk6Cp1DBXNRMZMzKAzZrVC2KzaqYZB24o=;
        h=Date:To:From:Subject:From;
        b=b6kkf/+Q5V2pq1qr2DtryDlKna0PQkHy6iaIKRai3SuXjuXPRCRhHOqeZk8lneWCS
         LyIZl3uufj8M1u4PCoHkt7+XxaXJ3ew+fjJzud+c9U1cDdF1IE/zmxRGPvu3S/eiFv
         F8w6dpEbsNQRz1xR2StehjSXxAnQFgmM7Q3Uh8yo=
Date:   Fri, 04 Aug 2023 11:28:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch added to mm-unstable branch
Message-Id: <20230804182812.77073C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: explicitly set FOLL_HONOR_NUMA_FAULT in hva_to_pfn_slow()
has been added to the -mm mm-unstable branch.  Its filename is
     kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: kvm: explicitly set FOLL_HONOR_NUMA_FAULT in hva_to_pfn_slow()
Date: Thu, 3 Aug 2023 16:32:04 +0200

KVM is *the* case we know that really wants to honor NUMA hinting falls.
As we want to stop setting FOLL_HONOR_NUMA_FAULT implicitly, set
FOLL_HONOR_NUMA_FAULT whenever we might obtain pages on behalf of a VCPU
to map them into a secondary MMU, and add a comment why.

Do that unconditionally in hva_to_pfn_slow() when calling
get_user_pages_unlocked().

kvmppc_book3s_instantiate_page(), hva_to_pfn_fast() and
gfn_to_page_many_atomic() are similarly used to map pages into a
secondary MMU. However, FOLL_WRITE and get_user_page_fast_only() always
implicitly honor NUMA hinting faults -- as documented for
FOLL_HONOR_NUMA_FAULT -- so we can limit this change to a single location
for now.

Don't set it in check_user_page_hwpoison(), where we really only want to
check if the mapped page is HW-poisoned.

We won't set it for other KVM users of get_user_pages()/pin_user_pages()
* arch/powerpc/kvm/book3s_64_mmu_hv.c: not used to map pages into a
  secondary MMU.
* arch/powerpc/kvm/e500_mmu.c: only used on shared TLB pages with userspace
* arch/s390/kvm/*: s390x only supports a single NUMA node either way
* arch/x86/kvm/svm/sev.c: not used to map pages into a secondary MMU.

This is a preparation for making FOLL_HONOR_NUMA_FAULT no longer
implicitly be set by get_user_pages() and friends.

Link: https://lkml.kernel.org/r/20230803143208.383663-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c~kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow
+++ a/virt/kvm/kvm_main.c
@@ -2517,7 +2517,18 @@ static bool hva_to_pfn_fast(unsigned lon
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
 {
-	unsigned int flags = FOLL_HWPOISON;
+	/*
+	 * When a VCPU accesses a page that is not mapped into the secondary
+	 * MMU, we lookup the page using GUP to map it, so the guest VCPU can
+	 * make progress. We always want to honor NUMA hinting faults in that
+	 * case, because GUP usage corresponds to memory accesses from the VCPU.
+	 * Otherwise, we'd not trigger NUMA hinting faults once a page is
+	 * mapped into the secondary MMU and gets accessed by a VCPU.
+	 *
+	 * Note that get_user_page_fast_only() and FOLL_WRITE for now
+	 * implicitly honor NUMA hinting faults and don't need this flag.
+	 */
+	unsigned int flags = FOLL_HWPOISON | FOLL_HONOR_NUMA_FAULT;
 	struct page *page;
 	int npages;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch

