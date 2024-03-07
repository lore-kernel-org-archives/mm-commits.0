Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C126612C54C
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842542; cv=none; b=sD96G9fMnyWrMn6QwIeJIDb9q1vtR8QDZWzWMUFBZvlBZYYvXzRL5q7lD02bnC0vUtTb720ueZSEilMllLLG4X1TSSOQDt70HSV/NQDWUBqarJ/FoHt97w6pjtXeML8sDgh7js9VfE01nrUVz1Ry0LFK3w/Mr3o+9v6AoTGmUpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842542; c=relaxed/simple;
	bh=nocw9a2Fcn/BDlayO1e3xqZtv7vh9yXhjiWyL2CoVlo=;
	h=Date:To:From:Subject:Message-Id; b=Ygx/7ek9p2EBAPssVEzkx4oVCwFMj1s6vGnmW6dMJgfpco4BhGdgL4eewLfYh2sxZ8tu4aGXPST8Q7irbMGLYtC1wXgdR91gClgu5NJ743kIgUlh5x9WHcRZx4im6JSBIUn47JbzK/oM/UAhi2Pfgrm4ELnKuHVUnSorQjTiYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZ8OTtyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZ8OTtyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED11C433F1;
	Thu,  7 Mar 2024 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709842542;
	bh=nocw9a2Fcn/BDlayO1e3xqZtv7vh9yXhjiWyL2CoVlo=;
	h=Date:To:From:Subject:From;
	b=UZ8OTtyEu4CZ4KmDE3lNdN35EPgU/DRs461lb002O8+d7h6/+yy72mZO40qu+yOhZ
	 uMDzHWdxCjmL9pfcQh1b8YGm+rNZu7rnoGDeHOuDGj7PzEWcQIDRsqQUl1JfEfuLpn
	 W2ou7Y3h8fyuu9TmZOrG9omBxaBq+xKMkxgGwJ3E=
Date: Thu, 07 Mar 2024 12:15:41 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch added to mm-unstable branch
Message-Id: <20240307201542.1ED11C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uffd hugetlb tests with insufficient hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch

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
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: skip uffd hugetlb tests with insufficient hugepages
Date: Wed, 6 Mar 2024 15:37:13 -0700

Now that run_vmtests.sh does not guarantee that the correct hugepage count
is available, add a check inside the userfaultfd hugetlb test to verify
the nr_hugepages count before continuing.

Link: https://lkml.kernel.org/r/20240306223714.320681-3-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -441,6 +441,12 @@ int main(int argc, char **argv)
 	parse_test_type_arg(argv[1]);
 	bytes = atol(argv[2]) * 1024 * 1024;
 
+	if (test_type == TEST_HUGETLB &&
+	   get_free_hugepages() < bytes / page_size) {
+		printf("skip: Skipping userfaultfd... not enough hugepages\n");
+		return KSFT_SKIP;
+	}
+
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 
 	nr_pages_per_cpu = bytes / page_size / nr_cpus;
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch
selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch
selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

