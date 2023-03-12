Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A2C6FD19
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 21:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCLVSJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 17:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjCLVSE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 17:18:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355AA10EB
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 14:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7529B80B7C
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 21:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6CAC433EF;
        Sun, 12 Mar 2023 21:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678655878;
        bh=gk0XM6a8kunyvZj5iXz3RpwgDPU0mCIDhWBCPbZp2wk=;
        h=Date:To:From:Subject:From;
        b=Yf+PVD4cbQ3tYG7Eo0m0Pk12WQa9nbwDALYV7SElBoklEmufaVfhflNMzTfAx3NLh
         Ea6MZ2xkhUGucJFn/oskt/Ek9zJrfH7Q3C7lTm3CY6+kskCgYREIza5zo/V/HicDfH
         f9bPLiJlKAsdooUA+MREI8MlxX0zPU23sgUR1jzU=
Date:   Sun, 12 Mar 2023 14:17:57 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@linux.vnet.ibm.com, pgofman@codeweavers.com,
        nadav.amit@gmail.com, david@redhat.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch added to mm-unstable branch
Message-Id: <20230312211758.5D6CAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: smoke test UFFD_FEATURE_WP_UNPOPULATED
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: smoke test UFFD_FEATURE_WP_UNPOPULATED
Date: Thu, 9 Mar 2023 17:37:11 -0500

Enable it by default on the stress test, and add some smoke tests for the
pte markers on anonymous.

Link: https://lkml.kernel.org/r/20230309223711.823547-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/userfaultfd.c~selftests-mm-smoke-test-uffd_feature_wp_unpopulated
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -1444,6 +1444,43 @@ static int pagemap_test_fork(bool presen
 	return result;
 }
 
+static void userfaultfd_wp_unpopulated_test(int pagemap_fd)
+{
+	uint64_t value;
+
+	/* Test applying pte marker to anon unpopulated */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+
+	/* Test unprotect on anon pte marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, false);
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Test zap on anon marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Test fault in after marker removed */
+	*area_dst = 1;
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+	/* Drop it to make pte none again */
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+
+	/* Test read-zero-page upon pte marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	*(volatile char *)area_dst;
+	/* Drop it to make pte none again */
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+}
+
 static void userfaultfd_pagemap_test(unsigned int test_pgsize)
 {
 	struct uffdio_register uffdio_register;
@@ -1462,7 +1499,7 @@ static void userfaultfd_pagemap_test(uns
 	/* Flush so it doesn't flush twice in parent/child later */
 	fflush(stdout);
 
-	uffd_test_ctx_init(0);
+	uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED);
 
 	if (test_pgsize > page_size) {
 		/* This is a thp test */
@@ -1482,6 +1519,10 @@ static void userfaultfd_pagemap_test(uns
 
 	pagemap_fd = pagemap_open();
 
+	/* Smoke test WP_UNPOPULATED first when it's still empty */
+	if (test_pgsize == page_size)
+		userfaultfd_wp_unpopulated_test(pagemap_fd);
+
 	/* Touch the page */
 	*area_dst = 1;
 	wp_range(uffd, (uint64_t)area_dst, test_pgsize, true);
@@ -1526,7 +1567,7 @@ static int userfaultfd_stress(void)
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
 
-	uffd_test_ctx_init(0);
+	uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED);
 
 	if (posix_memalign(&area, page_size, page_size))
 		err("out of memory");
_

Patches currently in -mm which might be from peterx@redhat.com are

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

