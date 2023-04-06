Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3D7C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjDFCpG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbjDFCob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3C28A6F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0AAD6421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3491EC433D2;
        Thu,  6 Apr 2023 02:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749069;
        bh=SzH80FiqFdHZ/2nh66mJ3p3rGi7GwBpu2Olpf0Tsb6k=;
        h=Date:To:From:Subject:From;
        b=WgMX+YjJa+0Gd1U2tn9OFshfPx9b0ZmG2td14whfDw41/UOfnym69nEDClyqX4taU
         Q/AyBjqvUG+ELP4zWs5lwWMTg+yQZ5eGjIGjScMH4DIwvuRSuR8pm0MlCBOgornJBa
         dSYAD7YJxQZqwZ78SAxm7B5qEuWBb5HN3zxrhWOI=
Date:   Wed, 05 Apr 2023 19:44:28 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@linux.vnet.ibm.com, pgofman@codeweavers.com,
        nadav.amit@gmail.com, david@redhat.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch removed from -mm tree
Message-Id: <20230406024429.3491EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: smoke test UFFD_FEATURE_WP_UNPOPULATED
has been removed from the -mm tree.  Its filename was
     selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 tools/testing/selftests/mm/userfaultfd.c |   45 ++++++++++++++++++++-
 1 file changed, 43 insertions(+), 2 deletions(-)

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

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch

