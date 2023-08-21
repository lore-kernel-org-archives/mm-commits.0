Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777EFEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjHUV3Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjHUV3Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB17EC7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 831EE61366
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E4C433C7;
        Mon, 21 Aug 2023 21:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653360;
        bh=LXu0EXLl982/z0oyHOgueedBbHCGncToOuMg8VQG3w4=;
        h=Date:To:From:Subject:From;
        b=uA9YvrkAcgukXzBcVkIoPwFN+lw6Ju5XQqDZEn+MKmETkrFqvTymx+cu/CCB/WkuL
         HKxlWftySpjvqOE6Fmika7oFXYXs8ia9bcT9/C/Oo+rsTFtrvCiDuzv+466i5iZKNG
         KVNqGrqoFm09tqRy3w90iD8PoXv97JRx4INp9rHk=
Date:   Mon, 21 Aug 2023 14:29:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch removed from -mm tree
Message-Id: <20230821212920.C88E4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kvm: explicitly set FOLL_HONOR_NUMA_FAULT in hva_to_pfn_slow()
has been removed from the -mm tree.  Its filename was
     kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

