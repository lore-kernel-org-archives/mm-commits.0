Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432B1C3A5A7
	for <mm-commits@archiver.kernel.org>; Tue,  6 Dec 2022 23:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiLFXbu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Dec 2022 18:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLFXbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2022 18:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF72143AFA
        for <mm-commits@vger.kernel.org>; Tue,  6 Dec 2022 15:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BE961961
        for <mm-commits@vger.kernel.org>; Tue,  6 Dec 2022 23:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33D2C433C1;
        Tue,  6 Dec 2022 23:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670369493;
        bh=spQN0Q+8kx2rpVtiQxI/Qo9hBSBSV/YQRtAYcSOq9TI=;
        h=Date:To:From:Subject:From;
        b=bnqVXJS48d1jO1IR3sB4XXTcqVkGJ0f3zco03e5qFnu7urqRWFBloWAUkkHY3qdDl
         B/WM9H5lnZPMftOvet2tyYumJBDTWGzlqOP9HpvjJipS2280mYvNJsOcyqbH8D4kqU
         omM5OisYLMwUJVq0KNH2Q46Uc7KRyBnZ7SngKLlw=
Date:   Tue, 06 Dec 2022 15:31:32 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20221206233133.A33D2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch

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
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch
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

