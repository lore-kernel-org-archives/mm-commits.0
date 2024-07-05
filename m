Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5EC15B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141634; cv=none; b=AoswUsZhiC2Ms0PXLCt9scNGgmC3M0/bPDWyT3S2kQGyctTIjsAHQnB5toH8t93jOjgEJgjstiRIJvh3sFBELFDEq5CWg4cYTDuTe0+8XfGi4I4Zx0d2RdTpvlnOhAftwCBfZs4JCY6u3O1b6CJikra2nz6W9IVgTDCH+hFb7wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141634; c=relaxed/simple;
	bh=Y+pnswjI/2aB1SnjU8SAwj5t/WSnBAvAG4oHMepLXFc=;
	h=Date:To:From:Subject:Message-Id; b=ReB9yiQ1MklRKjW+DrWariJg5b8W4u22vuPOWJGGj5EV5O1iSTlarrvLqP6RCggzjk7RrWMCylHexTG5k/SprMLGAgAH4DJWx1pvKADX9mRp3RY9ciIRPdKGPGoQAp4Kgrfw//CKOvWmAbYBwVUFSWOwZJgbIxBMHVJzLOasDTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PIUAZZ5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PIUAZZ5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25814C3277B;
	Fri,  5 Jul 2024 01:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141634;
	bh=Y+pnswjI/2aB1SnjU8SAwj5t/WSnBAvAG4oHMepLXFc=;
	h=Date:To:From:Subject:From;
	b=PIUAZZ5oD+bMkGNq6CTZvVHRPXsQdQebDOvAddTtqMSf8TwbyA0rvO1IkV8lE0DwX
	 h7tCvMM2RHspgrqodfh2fWpfpPHtSIWdrw1/8YPlI2xXLZDSLaDrGdiII1YepA4HpA
	 6AtE1DpAEyrZFRmKRljLVaT0lA2IPDnIyW3iR82A=
Date: Thu, 04 Jul 2024 18:07:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch removed from -mm tree
Message-Id: <20240705010714.25814C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
has been removed from the -mm tree.  Its filename was
     turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


