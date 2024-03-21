Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5783AC2B;
	Thu, 21 Mar 2024 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711063766; cv=none; b=sTqw3E9AKVRUyA07KS0wVKV7X3ReSYjT0GpR3pPaN1F6z4czOv+MnCy6P5VzgXrTVWeEUF1o+X5RqytSXBShsXK0RkqG2Ity/fdDdLHvrleA/GljghnP92V/NBN9Xwv7Iu+Ey6ulQKQe201Vra9OBeATKrWsExM/GDVFLprz/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711063766; c=relaxed/simple;
	bh=Cwy3gjtlov2MBpkg2h/pA/fEJLYD2JcccAuiRul6qU4=;
	h=Date:To:From:Subject:Message-Id; b=rgO9R0TkMSlP5im4vGAQLRB2p+1c0QCMwai1J3LSwm5Nfso0LZdCXETYesxFjwCMoZwNjmLNW4Fm2fBcT64wF4R0N0dqlI6aKf6rlqa0OYtIvhhldmYbSERdA3DQpPlDvxS9VxzTyPCSqgxjgD5PO/ssR+nhms60TID/Kid5mLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tvTbpaC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tvTbpaC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B9CC433C7;
	Thu, 21 Mar 2024 23:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711063765;
	bh=Cwy3gjtlov2MBpkg2h/pA/fEJLYD2JcccAuiRul6qU4=;
	h=Date:To:From:Subject:From;
	b=tvTbpaC+0Sb3jzmnn8HAWuIG6W9v1dRra7YsTmROoNte7x0Bq3iNJr+A8eI8Kftzt
	 ctqSgclUKJjuidKsdTPx5gXuJWu25QNl+Yz8u8qJYuPoaqix0Nmnc/QAnwI3hS0/BI
	 kn/VIy6BkivIKpCx7wS2G2cDe3LGXAOn6yaclmMI=
Date: Thu, 21 Mar 2024 16:29:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20240321232925.B0B9CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: sigbus-wp test requires UFFD_FEATURE_WP_HUGETLBFS_SHMEM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch

