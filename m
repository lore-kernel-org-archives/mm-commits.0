Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B62BC47089
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 20:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiLEUCN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiLEUCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 15:02:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBD6E3
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 12:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B6A761360
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 20:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A27DC433C1;
        Mon,  5 Dec 2022 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670270523;
        bh=4u8OI96i1wjnLmDXvGasPUrmdPahqhr6IFvNCcl3fQ8=;
        h=Date:To:From:Subject:From;
        b=jXvrcIpGf5SNDg6r7J6G2sRcmHh4s1LHkwa4YBI12SRLqHTmHW3Ta3p59rDBuKEZp
         x8RbdAAvtZbmheIhvE71gkMzH2GXiEjyT3dpu2TVUulEHAvm/j4rYCz+qUzMJqEmyB
         G19zVjyJv+LLXi421TAsMeoeoTLng6wllzFZwaaI=
Date:   Mon, 05 Dec 2022 12:02:02 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch added to mm-unstable branch
Message-Id: <20221205200203.6A27DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch

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
Subject: selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
Date: Mon, 5 Dec 2022 20:37:14 +0100

The tests fail to compile in some environments (e.g., Debian 11.5 on x86).
Let's simply conditionally define MADV_POPULATE_(READ|WRITE) if not
already defined, similar to how the khugepaged.c test handles it.

Link: https://lkml.kernel.org/r/20221205193716.276024-3-david@redhat.com
Fixes: 39b2e5cae43d ("selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/madv_populate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -20,6 +20,13 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ	22
+#endif /* MADV_POPULATE_READ */
+#ifndef MADV_POPULATE_WRITE
+#define MADV_POPULATE_WRITE	23
+#endif /* MADV_POPULATE_WRITE */
+
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
  */
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

