Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623286AE9;
	Tue, 26 Mar 2024 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476505; cv=none; b=ktWWkqT5A+Cw5UmDm+Yx3dMutWKifhMqtdTA6+RPoVyNFcD669sZ4ukKb/RN4nIbgAlsKN6cpfJnV4QB89PBX494Zo44nuUJusnhOLHfohaEbNdigoP/yoUX8i+izgx8UWEfUK3ELe6EhrFzoJFnedGAIR0BqgQhs55SyDMGgpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476505; c=relaxed/simple;
	bh=8qAQjKK8IxkWeiFg9rQqmOXh6rlHyrGyVrlH4/OYatQ=;
	h=Date:To:From:Subject:Message-Id; b=B8nl9Z1CwH56+NNjaPihjMe+OwEpP7qYBrDtdBdAtQKvBq8qpzb9Xf9Y2UB8DJYzsaBDepdz7nCGXtsjrlk7M/1iVtK7qb0SNokS0Znk8Vb93kTTY2lOybxaCXZI90J71xoodfTcgXhzL1BYw/yq8j95Rmwa8A8qS7nykWAwXD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tG7Pxz7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tG7Pxz7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11521C43390;
	Tue, 26 Mar 2024 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476504;
	bh=8qAQjKK8IxkWeiFg9rQqmOXh6rlHyrGyVrlH4/OYatQ=;
	h=Date:To:From:Subject:From;
	b=tG7Pxz7WNWq3kw4SOSUlJJhApT3dCuUX8xsCXeeeDKb4WLezXDx0+9n1S3CFER9id
	 aff4RYUc5eCVobulr+jqSuwKiEzu8EHv3/E3u0QTJLPOke+5u+Sh9W72eb/kDscPI7
	 iqNEOlFf5ByP5a6Q/7sRAhenvrZQNM+wpIKPzNgI=
Date: Tue, 26 Mar 2024 11:08:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch removed from -mm tree
Message-Id: <20240326180824.11521C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: sigbus-wp test requires UFFD_FEATURE_WP_HUGETLBFS_SHMEM
has been removed from the -mm tree.  Its filename was
     selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: sigbus-wp test requires UFFD_FEATURE_WP_HUGETLBFS_SHMEM
Date: Thu, 21 Mar 2024 23:20:21 +0000

The sigbus-wp test requires the UFFD_FEATURE_WP_HUGETLBFS_SHMEM flag for
shmem and hugetlb targets.  Otherwise it is not backwards compatible with
kernels <5.19 and fails with EINVAL.

Link: https://lkml.kernel.org/r/20240321232023.2064975-1-edliaw@google.com
Fixes: 73c1ea939b65 ("selftests/mm: move uffd sig/events tests into uffd unit tests")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1427,7 +1427,8 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_fn = uffd_sigbus_wp_test,
 		.mem_targets = MEM_ALL,
 		.uffd_feature_required = UFFD_FEATURE_SIGBUS |
-		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
 	},
 	{
 		.name = "events",
_

Patches currently in -mm which might be from edliaw@google.com are


