Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DC9C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 01:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLJByb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 20:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLJBya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 20:54:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0451E4B9A2
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 17:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EEFE623C6
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 01:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1E8C433EF;
        Sat, 10 Dec 2022 01:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670637268;
        bh=3XwhcGQmlty6rqGa++geEpZS6xloumpVQqjvml5TL74=;
        h=Date:To:From:Subject:From;
        b=ZTfes/8Gx44OfHGwvrD3WDpba1SiPFHkr4wEkznGJyCvIqdgws5E9Y4hXRPYEob+5
         leAN54607hlvDL4pInAedOPhecfxXsrD2yHEW6D5dp3FHpDWSndhsKGZ8PVSRGAdsk
         sQt/vq9pjw1wWN944L/F6GzbxNKQPDL+UwOEvEfw=
Date:   Fri, 09 Dec 2022 17:54:28 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch removed from -mm tree
Message-Id: <20221210015428.DA1E8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch

This patch was dropped because it was folded into mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix
Date: Wed, 7 Dec 2022 21:15:36 +0100
  CONFIG_PHYS_ADDR_T_64BIT on 32bit"

use "int" for comparison, as we're only comparing numbers < 64.

Link: https://lkml.kernel.org/r/1f157500-2676-7cef-a84e-9224ed64e540@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swapops.h~mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix
+++ a/include/linux/swapops.h
@@ -35,7 +35,7 @@
 #ifdef MAX_PHYSMEM_BITS
 #define SWP_PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
 #else  /* MAX_PHYSMEM_BITS */
-#define SWP_PFN_BITS		min_t(phys_addr_t, \
+#define SWP_PFN_BITS		min_t(int, \
 				      sizeof(phys_addr_t) * 8 - PAGE_SHIFT, \
 				      SWP_TYPE_SHIFT)
 #endif	/* MAX_PHYSMEM_BITS */
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
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

