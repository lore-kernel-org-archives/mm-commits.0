Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA022C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383802AbiEMTVq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383847AbiEMTVQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B654EDDE
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B6D62245
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B36C34113;
        Fri, 13 May 2022 19:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469673;
        bh=sp2BScphQDsGsJ3MenLjsas9X98X6mcPrY3qLYzgPRc=;
        h=Date:To:From:Subject:From;
        b=LO2lqRCozpm5kj7Q7cs7H+OOk9pdm+lWwxAbKiaJ+AyDTTD1ikm9PDTIjAWS7RJQZ
         d7AK45uOCfgNs5p8T/Er4pXJkw+v+iycRW607mn/DGdPxltxuRyF7mYjmSu4av/Kt2
         KGFDULZN7oXycQS1jOWgS9l7OblNsDoisnFCjxt8=
Date:   Fri, 13 May 2022 12:21:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch removed from -mm tree
Message-Id: <20220513192113.97B36C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/uffd: enable uffd-wp for shmem/hugetlbfs
has been removed from the -mm tree.  Its filename was
     selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/uffd: enable uffd-wp for shmem/hugetlbfs

After we added support for shmem and hugetlbfs, we can turn uffd-wp test
on always now.

Link: https://lkml.kernel.org/r/20220405014932.15212-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -82,7 +82,7 @@ static int test_type;
 static volatile bool test_uffdio_copy_eexist = true;
 static volatile bool test_uffdio_zeropage_eexist = true;
 /* Whether to test uffd write-protection */
-static bool test_uffdio_wp = false;
+static bool test_uffdio_wp = true;
 /* Whether to test uffd minor faults */
 static bool test_uffdio_minor = false;
 
@@ -1594,8 +1594,6 @@ static void set_test_type(const char *ty
 	if (!strcmp(type, "anon")) {
 		test_type = TEST_ANON;
 		uffd_test_ops = &anon_uffd_test_ops;
-		/* Only enable write-protect test for anonymous test */
-		test_uffdio_wp = true;
 	} else if (!strcmp(type, "hugetlb")) {
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
_

Patches currently in -mm which might be from peterx@redhat.com are


