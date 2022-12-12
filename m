Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839EBC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiLLCSX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiLLCQq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84414DFD4
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 472CCB80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06130C433EF;
        Mon, 12 Dec 2022 02:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811304;
        bh=+BFlwfE/0tijZJniUWIRxRfvPdwrgShsrupnULVtzT8=;
        h=Date:To:From:Subject:From;
        b=y1L9LrGmDiPV0FpinjkqA7qGCr9ydJ5ozFxQcwONHBDQAvqXC8+wBFqWku6mKPVUN
         kVtFWt3EKpjgRDFqrL46rJkIOzdbEbhMswphAsaMRlNHXediyz32Q8CQlF+l6VG2BJ
         rNRA0SHFykdz3HI5633CDC41/kDMSU7UisrNXkQk=
Date:   Sun, 11 Dec 2022 18:15:03 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-ksm_functional_tests-fixes-for-32bit.patch removed from -mm tree
Message-Id: <20221212021504.06130C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: ksm_functional_tests: fixes for 32bit
has been removed from the -mm tree.  Its filename was
     selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


