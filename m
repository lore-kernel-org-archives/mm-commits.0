Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608CCC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjDRXhm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjDRXgP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77C3CC2D
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E5863A0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0071FC433D2;
        Tue, 18 Apr 2023 23:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860917;
        bh=yaamf4DKFsRLsw19Rjh4Eid+w1rcxYppyBJjyOSsJgU=;
        h=Date:To:From:Subject:From;
        b=ygGFESyQTqjRJM6xFhoKK2wpvvxCcDBZV2ALVDlbXUfbkajJToLXVmal1L+3iHx/X
         iB/UEqN3crm0Uzglw+6sQqVMYoC6yFIQ7SOW2a/K2AqBcA0U6mrqYqQh1rhc8Qteg2
         ElMemUJb81ZFtT1h8Im3OY8TH4IhJm3nzIZW+gdw=
Date:   Tue, 18 Apr 2023 16:35:16 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch removed from -mm tree
Message-Id: <20230418233517.0071FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: reuse pagemap_get_entry() in vm_util.h
has been removed from the -mm tree.  Its filename was
     selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: reuse pagemap_get_entry() in vm_util.h
Date: Wed, 12 Apr 2023 12:42:31 -0400

Meanwhile drop pagemap_read_vaddr().

Link: https://lkml.kernel.org/r/20230412164231.328157-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/userfaultfd.c |   31 ++++++---------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/userfaultfd.c~selftests-mm-reuse-pagemap_get_entry-in-vm_utilh
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -1399,19 +1399,6 @@ static int pagemap_open(void)
 	return fd;
 }
 
-static uint64_t pagemap_read_vaddr(int fd, void *vaddr)
-{
-	uint64_t value;
-	int ret;
-
-	ret = pread(fd, &value, sizeof(uint64_t),
-		    ((uint64_t)vaddr >> 12) * sizeof(uint64_t));
-	if (ret != sizeof(uint64_t))
-		err("pread() on pagemap failed");
-
-	return value;
-}
-
 /* This macro let __LINE__ works in err() */
 #define  pagemap_check_wp(value, wp) do {				\
 		if (!!(value & PM_UFFD_WP) != wp)			\
@@ -1427,7 +1414,7 @@ static int pagemap_test_fork(bool presen
 	if (!child) {
 		/* Open the pagemap fd of the child itself */
 		fd = pagemap_open();
-		value = pagemap_read_vaddr(fd, area_dst);
+		value = pagemap_get_entry(fd, area_dst);
 		/*
 		 * After fork() uffd-wp bit should be gone as long as we're
 		 * without UFFD_FEATURE_EVENT_FORK
@@ -1446,24 +1433,24 @@ static void userfaultfd_wp_unpopulated_t
 
 	/* Test applying pte marker to anon unpopulated */
 	wp_range(uffd, (uint64_t)area_dst, page_size, true);
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
 
 	/* Test unprotect on anon pte marker */
 	wp_range(uffd, (uint64_t)area_dst, page_size, false);
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
 
 	/* Test zap on anon marker */
 	wp_range(uffd, (uint64_t)area_dst, page_size, true);
 	if (madvise(area_dst, page_size, MADV_DONTNEED))
 		err("madvise(MADV_DONTNEED) failed");
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
 
 	/* Test fault in after marker removed */
 	*area_dst = 1;
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
 	/* Drop it to make pte none again */
 	if (madvise(area_dst, page_size, MADV_DONTNEED))
@@ -1522,7 +1509,7 @@ static void userfaultfd_pagemap_test(uns
 	/* Touch the page */
 	*area_dst = 1;
 	wp_range(uffd, (uint64_t)area_dst, test_pgsize, true);
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
 	/* Make sure uffd-wp bit dropped when fork */
 	if (pagemap_test_fork(true))
@@ -1536,7 +1523,7 @@ static void userfaultfd_pagemap_test(uns
 		err("madvise(MADV_PAGEOUT) failed");
 
 	/* Uffd-wp should persist even swapped out */
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
 	/* Make sure uffd-wp bit dropped when fork */
 	if (pagemap_test_fork(false))
@@ -1544,12 +1531,12 @@ static void userfaultfd_pagemap_test(uns
 
 	/* Unprotect; this tests swap pte modifications */
 	wp_range(uffd, (uint64_t)area_dst, page_size, false);
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
 
 	/* Fault in the page from disk */
 	*area_dst = 2;
-	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
 
 	close(pagemap_fd);
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

