Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3612C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjDRXiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjDRXgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217E6D330
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0267262F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5737DC433D2;
        Tue, 18 Apr 2023 23:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860936;
        bh=2zsB60/IXXPlXANXu7lwZxfuS8KaQmBzgwIASKD3z1M=;
        h=Date:To:From:Subject:From;
        b=GeBCUucE3zZRn2wXojIAudeD5YPWztJW/w7bxLJTv8J2YunB7nILy4qdJzxvSJUDK
         vnpPQ8OK21HId2doYvLpmjgBIkyxyVgJWKgPwm4orfzOXKfcvewFIsxTTMz58f1+eE
         RtUuF7LSRubPKzxjrW/yFHvv9uh/rWLVyaTwyOmI=
Date:   Tue, 18 Apr 2023 16:35:35 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch removed from -mm tree
Message-Id: <20230418233536.5737DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: workaround no way to detect uffd-minor + wp
has been removed from the -mm tree.  Its filename was
     selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: workaround no way to detect uffd-minor + wp
Date: Wed, 12 Apr 2023 12:45:17 -0400

Userfaultfd minor+wp mode was very recently added.  The test will fail on
the old kernels at ioctl(UFFDIO_CONTINUE) which is misterious. 
Unfortunately there's no feature bit to detect for this support.

Add a hack to leverage WP_UNPOPULATED to detect whether that feature
existed, since WP_UNPOPULATED was merged right after minor+wp.

Link: https://lkml.kernel.org/r/20230412164517.329152-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-workaround-no-way-to-detect-uffd-minor-wp
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -780,7 +780,13 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_SHMEM | MEM_HUGETLB,
 		.uffd_feature_required =
 		UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
-		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		/*
+		 * HACK: here we leveraged WP_UNPOPULATED to detect whether
+		 * minor mode supports wr-protect.  There's no feature flag
+		 * for it so this is the best we can test against.
+		 */
+		UFFD_FEATURE_WP_UNPOPULATED,
 	},
 	{
 		.name = "minor-collapse",
_

Patches currently in -mm which might be from peterx@redhat.com are

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

