Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D60C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 01:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLJByg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 20:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLJByc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 20:54:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418F4B9A2
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 17:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACD2CCE2B39
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 01:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E72C433D2;
        Sat, 10 Dec 2022 01:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670637267;
        bh=2V8nBsAiwo+cM2yF4oEhn4MCxEKTDj1odAmQ0s+YAYU=;
        h=Date:To:From:Subject:From;
        b=2GQ9blos7VLISlJGvDW+SBd1Um0OoR/BfJhXoGRqGYmJ+l8K+sdxKkGbbck9I3bFC
         fzK4QMaz1inanveAHAJn38vnOdE8a7hv1oA9ga7KXSc2su9nJ6NRqgz7JO5UdI44PZ
         cwmnl8rRhb26QCqOwexdAsS83R7ZaiAjG7jJ41xQ=
Date:   Fri, 09 Dec 2022 17:54:26 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch removed from -mm tree
Message-Id: <20221210015427.99E72C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch

This patch was dropped because it was folded into mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2
Date: Tue, 6 Dec 2022 11:57:37 +0100

rely on sizeof(phys_addr_t) and min_t() instead

Link: https://lkml.kernel.org/r/20221206105737.69478-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2
+++ a/include/linux/swapops.h
@@ -32,14 +32,14 @@
  * store PFN, we only need SWP_PFN_BITS bits.  Each of the pfn swap entries
  * can use the extra bits to store other information besides PFN.
  */
-#if defined(MAX_PHYSMEM_BITS)
-#define SWP_PFN_BITS			(MAX_PHYSMEM_BITS - PAGE_SHIFT)
-#elif !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
-#define SWP_PFN_BITS			SWP_TYPE_SHIFT
-#else
-#define SWP_PFN_BITS			(BITS_PER_LONG - PAGE_SHIFT)
-#endif	/* defined(MAX_PHYSMEM_BITS) */
-#define SWP_PFN_MASK			(BIT(SWP_PFN_BITS) - 1)
+#ifdef MAX_PHYSMEM_BITS
+#define SWP_PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
+#else  /* MAX_PHYSMEM_BITS */
+#define SWP_PFN_BITS		min_t(phys_addr_t, \
+				      sizeof(phys_addr_t) * 8 - PAGE_SHIFT, \
+				      SWP_TYPE_SHIFT)
+#endif	/* MAX_PHYSMEM_BITS */
+#define SWP_PFN_MASK		(BIT(SWP_PFN_BITS) - 1)
 
 /**
  * Migration swap entry specific bitfield definitions.  Layout:
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch
selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch
selftests-vm-cow-fix-compile-warning-on-32bit.patch
selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

