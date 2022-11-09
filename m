Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114BAC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKIB2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIB2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:28:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA4B1E703
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5759E617E2
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFDAC433C1;
        Wed,  9 Nov 2022 01:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957325;
        bh=4/gIfC2Qc+pcjtsTg7dSsNKdXMsrosX4PyX2HOwQI20=;
        h=Date:To:From:Subject:From;
        b=svQKF8SvnoaZPntr5Mh+uyjQV0FFE4Qc8ZRt1CBmjYsIgeXvYKepSZsXM2RNJFY0E
         ZB/XrRZ1wwRxH7Bl+uuRqQaFyJVZqNj2d1aKLCdCDPWqGaDLNdO0UeoR09K3cW8upN
         VfN/ILVZ2BQFNQ30kTyVuj9/B9SXpllbOgIs1IJE=
Date:   Tue, 08 Nov 2022 17:28:45 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch removed from -mm tree
Message-Id: <20221109012845.ADFDAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
has been removed from the -mm tree.  Its filename was
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch

This patch was dropped because it was folded into mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
Date: Wed, 19 Oct 2022 14:31:15 +0200

silence a warning on 32-bit

https://lore.kernel.org/all/202210182101.XOyPZEQV-lkp@intel.com/T/#u


Link: https://lkml.kernel.org/r/74adbb51-6e33-f636-8a9c-2ad87bd9007e@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
+++ a/mm/gup_test.c
@@ -299,7 +299,8 @@ static inline int pin_longterm_test_read
 	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
 		void *addr = page_to_virt(pin_longterm_test_pages[i]);
 
-		if (copy_to_user((void __user *)user_addr, addr, PAGE_SIZE))
+		if (copy_to_user((void __user *)(unsigned long)user_addr, addr,
+				 PAGE_SIZE))
 			return -EFAULT;
 		user_addr += PAGE_SIZE;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

