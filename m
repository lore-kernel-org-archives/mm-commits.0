Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77542C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjHDSdh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjHDSdE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A35253
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3611F6210B
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A894C433C9;
        Fri,  4 Aug 2023 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691173694;
        bh=ldmANPLvtxLmCRHUu/1wueL/HJ5wGF8kT+fd+Dx8zog=;
        h=Date:To:From:Subject:From;
        b=ENIBPSO38wTQrs1qprFGvXKz+akZicgOfe9QyMaYgtshG7yww/Rax9qWKWG7WsTXV
         tBDfpN5rgQOAKyRIVWWgNxX92XmaY+TOpq8g96uLsIHmiwMT4RzH2BVeM3j2R5L4KZ
         zhSE0irKAqXOThiwdin/KsS6ZLNhA+brENNJS5NA=
Date:   Fri, 04 Aug 2023 11:28:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch added to mm-unstable branch
Message-Id: <20230804182814.8A894C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: don't implicitly set FOLL_HONOR_NUMA_FAULT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch

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
Subject: mm/gup: don't implicitly set FOLL_HONOR_NUMA_FAULT
Date: Thu, 3 Aug 2023 16:32:05 +0200

Commit 0b9d705297b2 ("mm: numa: Support NUMA hinting page faults from
gup/gup_fast") from 2012 documented as the primary reason why we would want
to handle NUMA hinting faults from GUP:

  KVM secondary MMU page faults will trigger the NUMA hinting page
  faults through gup_fast -> get_user_pages -> follow_page ->
  handle_mm_fault.

That is still the case today, and relevant KVM code has been converted to
manually set FOLL_HONOR_NUMA_FAULT. So let's stop setting
FOLL_HONOR_NUMA_FAULT for all GUP users and cross fingers that not that
many other ones that really require such handling for autonuma remain.

Possible interaction with MMU notifiers:

 Assume a driver obtains a page using get_user_pages() to map it into
 a secondary MMU, and uses the MMU notifier framework to get notified on
 changes.

 Assume get_user_pages() succeeded on a PROT_NONE-mapped page (because
 FOLL_HONOR_NUMA_FAULT is not set) in an accessible VMA and the page is
 mapped into a secondary MMU. Once user space would turn that mapping
 inaccessible using mprotect(PROT_NONE), the actual PTE in the page table
 might not change. If the MMU notifier would be smart and optimize for that
 case "why notify if the PTE didn't change", that could be problematic.

 At least change_pmd_range() with MMU_NOTIFY_PROTECTION_VMA for now does an
 unconditional mmu_notifier_invalidate_range_start() ->
 mmu_notifier_invalidate_range_end() and should be fine.

 Note that even if a PTE in an accessible VMA is pte_protnone(), the
 underlying page might be accessed by a secondary MMU that does not set
 FOLL_HONOR_NUMA_FAULT, and test_young() MMU notifiers would return "true".

Link: https://lkml.kernel.org/r/20230803143208.383663-5-david@redhat.com
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

 mm/gup.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/gup.c~mm-gup-dont-implicitly-set-foll_honor_numa_fault
+++ a/mm/gup.c
@@ -2244,13 +2244,6 @@ static bool is_valid_gup_args(struct pag
 		gup_flags |= FOLL_UNLOCKABLE;
 	}
 
-	/*
-	 * For now, always trigger NUMA hinting faults. Some GUP users like
-	 * KVM require the hint to be as the calling context of GUP is
-	 * functionally similar to a memory reference from task context.
-	 */
-	gup_flags |= FOLL_HONOR_NUMA_FAULT;
-
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
 			 (FOLL_PIN | FOLL_GET)))
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

