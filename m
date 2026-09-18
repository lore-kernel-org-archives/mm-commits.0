Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C5C3E3DAB
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 19:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761079; cv=none; b=OIaE5kKxU2E+TP7Z5/jqTyatN/3UNn3HhGpeOgEpEN0dN99OJom4zHkc3msvvLGiTjt9ch6jly0W2kccjw4oIJtPFcNs7/HZf49hXPf943UUhNBDts+TJyo1Lc8qgZaqn+q99971vK8leH/Sm3fRERnqt6DeRF9UDr+BmRDrX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761079; c=relaxed/simple;
	bh=FC91EHpg2r9mmVtpwb7Y0oKy3ZoskGuOyD2wTMslKCY=;
	h=Date:To:From:Subject:Message-Id; b=Zz1Mvf9U20GXOiQXBO2cSwlzqk+4Qof/XmTyFL8aKq/HTmYKJJawmvgLao8h0XvZ3AhizGZMhNw5RFxwrSJ071SL6dHqScvhJyOmdmq+9gqj/uc7dY6nubWw48P70ZkR7/9sbKrNxJ3mlV1E/y43wMx+QqlDTvP72D1j1vF5HFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekZ03uEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekZ03uEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEAF1F00898;
	Fri, 18 Sep 2026 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789761077;
	bh=Z5+xf54AfPB3WRfneW+X3udSvnFdRTQg0+esDcGnZ4g=;
	h=Date:To:From:Subject;
	b=ekZ03uExdtc2uDxvxPAbZfXOodvmxnmN8Y73I5OEnsWT0jzxYnARPJjqWp0fvhbKz
	 b2aLszouUun573xGmrDY+x9YvKJkJrd8I30up+ZtT5LJyTr0pDLmIftlfNV4s+2/EU
	 POA3K4/xMS0lbF8nIIu4TAN0flc3ujahalCtukfU=
Date: Fri, 18 Sep 2026 12:51:17 -0700
To: mm-commits@vger.kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-make-file-helpers-return-errors-fix.patch added to mm-new branch
Message-Id: <20260918195117.CAEAF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-make-file-helpers-return-errors-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-make-file-helpers-return-errors-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-make-file-helpers-return-errors-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests-mm-make-file-helpers-return-errors-fix
Date: Fri, 18 Sep 2026 17:40:50 +0530

Convert hugetlb_nr_resv_pages(), which was missed when read_num()
changed to return an error and store the parsed value through an output
pointer.

Link: https://lore.kernel.org/937939c3-ae9a-4148-a601-0f8876216423@arm.com
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/hugepage_settings.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-make-file-helpers-return-errors-fix
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -515,10 +515,18 @@ unsigned long hugetlb_free_pages(unsigne
 unsigned long hugetlb_nr_resv_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-report-actual-pinned-bytes.patch
mm-gup_test-safely-calculate-gup-batch-size.patch
selftests-mm-make-file-helpers-return-errors.patch
selftests-mm-make-file-helpers-return-errors-fix.patch
tools-lib-mm-add-shared-file-helpers.patch
tools-lib-mm-move-hugepage_settings-out-of-selftests.patch
tools-mm-move-gup_test-from-selftests-mm-to-tools-mm.patch
tools-mm-make-gup_bench-a-benchmark-only-tool.patch
selftests-mm-add-a-gup-selftest.patch

