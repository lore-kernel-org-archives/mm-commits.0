Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F80AC4708D
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 22:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLGWYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 17:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLGWYW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 17:24:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6922D20F4D
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 14:24:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 046CB61CC3
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 22:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F99C433D7;
        Wed,  7 Dec 2022 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670451860;
        bh=CBVT4SXRWxzeUY69+Gk9RngYb6G8PtH91AYwo2coF1Y=;
        h=Date:To:From:Subject:From;
        b=LqS+K0/VpcW1uetUBhfavLybh7NmWxnD1XN2ynG/ZZjuhuI9ZF9eeLkUucUaJHLcC
         7DfBQeeisS8kuoHkStqjd80VMysPKzaRzoe0x4VcuSYXHksPDxg2rdMUnvev7ogf5D
         wbWNAzLxwk87xgtXQ366Yt/kqzXEmWsY6zlYcE54=
Date:   Wed, 07 Dec 2022 14:24:19 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221207222420.50F99C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch

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
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch
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

