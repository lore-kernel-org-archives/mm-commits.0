Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374E319069C
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719431713; cv=none; b=BUzwC5fxyCs6t1CfWJdsTNFw8+aZGlDiTKfku2qeXzakhBw89DO4tWbw1Y9fAKp2DDlp3Ov6F2HGV7EI6RKAtAZ8eKF5xHRTMcPxItziE7HE/YQvg7/pY9UohWhqoDXQI8ysGkdGRNJP7DNZaizmaDgr45vNv02alRoISA36axo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719431713; c=relaxed/simple;
	bh=+YGZx6jwHOVANog+iPY9tXuZpe5vgbsPLM3fjwyTpv4=;
	h=Date:To:From:Subject:Message-Id; b=NsATdDceHlhcku353oje6/C6LDP/uBrjDn7V86s7lznTfhJn5ojXnLJMHX2X6NWSVDkY7rK9K0FoQxBCm2ckI6uhC39C8Y+CEsGNryhND1V68y7nHt9CFwaqg9Yg4YsYMGcK60uOFZ0/EEQV2fPy+lMTq/ftzz6/mqnGnm6jNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXYTbXO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXYTbXO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF2EC116B1;
	Wed, 26 Jun 2024 19:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719431712;
	bh=+YGZx6jwHOVANog+iPY9tXuZpe5vgbsPLM3fjwyTpv4=;
	h=Date:To:From:Subject:From;
	b=tXYTbXO6fxKvM3J33PTnQWqItuYNRDutMIv4wqe+jVR/Aj0o+lNx5nFW8xiGrp5FF
	 ccHgZfESNzaF0esTJMp9DkMdu4xIGb/sqRI4XnyD314EOemyEh0SRlnmlF7SkVwYgW
	 /+R/rJbHp6R923Y3tKmdQe1C2ZnWPoUwDfiT0czo=
Date: Wed, 26 Jun 2024 12:55:12 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch added to mm-unstable branch
Message-Id: <20240626195512.ADF2EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
has been added to the -mm mm-unstable branch.  Its filename is
     turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

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
From: Audra Mitchell <audra@redhat.com>
Subject: mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
Date: Wed, 26 Jun 2024 09:05:13 -0400

If CONFIG_PTE_MARKER_UFFD_WP is disabled, then we turn off three features
in userfaultfd_api (UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
UFFD_FEATURE_WP_UNPOPULATED, and UFFD_FEATURE_WP_ASYNC).

Currently this test always will call uffdio_regsiter with the flag
UFFDIO_REGISTER_MODE_WP.  However, the kernel ensures in vma_can_userfault
that if the feature UFFD_FEATURE_WP_HUGETLBFS_SHMEM is disabled, only
allow the VM_UFFD_WP on anonymous vmas, meaning our call to
uffdio_regsiter will fail.

We still want to be able to run the test even if we have
CONFIG_PTE_MARKER_UFFD_WP disabled, so check to see if the feature
UFFD_FEATURE_WP_HUGETLBFS_SHMEM has been turned off in the test and if so,
disable us from calling uffdio_regsiter with the flag
UFFDIO_REGISTER_MODE_WP.

Link: https://lkml.kernel.org/r/20240626130513.120193-3-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/uffd-stress.c~turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -417,6 +417,9 @@ static void parse_test_type_arg(const ch
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
+	if (test_type != TEST_ANON && !(features & UFFD_FEATURE_WP_HUGETLBFS_SHMEM))
+		test_uffdio_wp = false;
+
 	close(uffd);
 	uffd = -1;
 }
_

Patches currently in -mm which might be from audra@redhat.com are

fix-userfaultfd_api-to-return-einval-as-expected.patch
update-uffd-stress-to-handle-einval-for-unset-config-features.patch
turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

