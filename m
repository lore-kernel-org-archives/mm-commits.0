Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BC0C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjHDSey (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjHDSbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D605255AB
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 014376210E
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593AEC433C7;
        Fri,  4 Aug 2023 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691173696;
        bh=zsML8vVEAy7IY04S6/uUgi+otWYuFGq+w7uzRo1joxw=;
        h=Date:To:From:Subject:From;
        b=j/QWdKgjJr4/RuUAfgmNzPV2HGp8BzLuC8yc38ou/3tF6SIaolV6D48o861isAu3R
         3zQlyYVTptGLLRa1ttpmQoPueJHeJ9EUFOnVAzjl3W+qeKYCHfM6KLyuJYS7FxQgyF
         Oa70lXInCYkkMyE5nlf0P7aF9iq4TN1t8iKHqY7w=
Date:   Fri, 04 Aug 2023 11:28:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pgtable-improve-pte_protnone-comment.patch added to mm-unstable branch
Message-Id: <20230804182816.593AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pgtable: improve pte_protnone() comment
has been added to the -mm mm-unstable branch.  Its filename is
     pgtable-improve-pte_protnone-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pgtable-improve-pte_protnone-comment.patch

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
Subject: pgtable: improve pte_protnone() comment
Date: Thu, 3 Aug 2023 16:32:06 +0200

Especially the "For PROT_NONE VMAs, the PTEs are not marked
_PAGE_PROTNONE" part is wrong: doing an mprotect(PROT_NONE) will end up
marking all PTEs on x86_64 as _PAGE_PROTNONE, making pte_protnone()
indicate "yes".

So let's improve the comment, so it's easier to grasp which semantics
pte_protnone() actually has.

Link: https://lkml.kernel.org/r/20230803143208.383663-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/pgtable.h~pgtable-improve-pte_protnone-comment
+++ a/include/linux/pgtable.h
@@ -1446,12 +1446,16 @@ static inline int pud_trans_unstable(pud
 
 #ifndef CONFIG_NUMA_BALANCING
 /*
- * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
- * the only case the kernel cares is for NUMA balancing and is only ever set
- * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
- * _PAGE_PROTNONE so by default, implement the helper as "always no". It
- * is the responsibility of the caller to distinguish between PROT_NONE
- * protections and NUMA hinting fault protections.
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
+ * perfectly valid to indicate "no" in that case, which is why our default
+ * implementation defaults to "always no".
+ *
+ * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
+ * page protection due to NUMA hinting. NUMA hinting faults only apply in
+ * accessible VMAs.
+ *
+ * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
+ * looking at the VMA accessibility is sufficient.
  */
 static inline int pte_protnone(pte_t pte)
 {
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

