Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2157BC4708E
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 20:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLEUCP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiLEUCL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 15:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C6663DE
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 12:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF945B811E3
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 20:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C9C433C1;
        Mon,  5 Dec 2022 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670270527;
        bh=Mf/s+iUxmpi45xB9r0Izt6Vx4gWuB9Dcr6scbPQjXmw=;
        h=Date:To:From:Subject:From;
        b=lOVLCskltJUn/5p/r1WQyqcQSOAUHropU5HDRmJ8VvtBDyNXerFUQyufdWSDfu82B
         e4yEx/T5FZSdIAr8tmgUsJQuSZae65mIAoaU5bTsYPiCIC6nAJm/qCGPIieb4qNO+M
         XRcmb5wbehSC7jo0KiFFczd2TzVNbEacko2VXS88=
Date:   Mon, 05 Dec 2022 12:02:06 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-ksm_functional_tests-fixes-for-32bit.patch added to mm-unstable branch
Message-Id: <20221205200207.7E1C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: ksm_functional_tests: fixes for 32bit
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

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
Subject: selftests/vm: ksm_functional_tests: fixes for 32bit
Date: Mon, 5 Dec 2022 20:37:16 +0100

The test currently fails on 32bit.  Fixing the "-1ull" vs.  "-1ul" seems
to make the test pass and the compiler happy.

Note: This test is not in mm-stable yet. This fix should be squashed into
      "selftests/vm: add KSM unmerge tests".

Link: https://lkml.kernel.org/r/20221205193716.276024-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_functional_tests.c |    4 ++--
 tools/testing/selftests/vm/vm_util.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/ksm_functional_tests.c~selftests-vm-ksm_functional_tests-fixes-for-32bit
+++ a/tools/testing/selftests/vm/ksm_functional_tests.c
@@ -42,13 +42,13 @@ static bool range_maps_duplicates(char *
 	for (offs_a = 0; offs_a < size; offs_a += pagesize) {
 		pfn_a = pagemap_get_pfn(pagemap_fd, addr + offs_a);
 		/* Page not present or PFN not exposed by the kernel. */
-		if (pfn_a == -1ull || !pfn_a)
+		if (pfn_a == -1ul || !pfn_a)
 			continue;
 
 		for (offs_b = offs_a + pagesize; offs_b < size;
 		     offs_b += pagesize) {
 			pfn_b = pagemap_get_pfn(pagemap_fd, addr + offs_b);
-			if (pfn_b == -1ull || !pfn_b)
+			if (pfn_b == -1ul || !pfn_b)
 				continue;
 			if (pfn_a == pfn_b)
 				return true;
--- a/tools/testing/selftests/vm/vm_util.c~selftests-vm-ksm_functional_tests-fixes-for-32bit
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -50,7 +50,7 @@ unsigned long pagemap_get_pfn(int fd, ch
 	/* If present (63th bit), PFN is at bit 0 -- 54. */
 	if (entry & 0x8000000000000000ull)
 		return entry & 0x007fffffffffffffull;
-	return -1ull;
+	return -1ul;
 }
 
 void clear_softdirty(void)
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
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

