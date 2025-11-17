Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833CD2264CA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343258; cv=none; b=ZzmoG2stLFPC6Z9ZCW94yjjkgW1JhHpNshAnndu0IfadjP/hY5Tz98yBiM+piN568Tz4pQdGJ9/IBcpsr//CFewq46wdUXnauEtLLGBShYqTHmvrOM73z4Nys+lHK5m5Ukn9mmyrv5bhK80OSml4C00fM0skIYYnbQGihu6eh2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343258; c=relaxed/simple;
	bh=yW1qi6reygtLr2k4LIY4H65ueqW+JDJiadjVaNvJ40c=;
	h=Date:To:From:Subject:Message-Id; b=OrfGKFHCtQeAcPaoTBcH/J9Qr3sPpF/kJYqF7hDUzgDC3nAByKanZI7DuhsoRJhDxYZuJg/90imDgO2ccum2wcYobz+FmYuqoR7iB3boMuLjbFB2qLVv6tVxGnOp3VSLotH18HIhMxfQcqpTHpJWHKJJMJcb4CoH/GapMQH4RZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDFWSKKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDFWSKKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395D9C19425;
	Mon, 17 Nov 2025 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343258;
	bh=yW1qi6reygtLr2k4LIY4H65ueqW+JDJiadjVaNvJ40c=;
	h=Date:To:From:Subject:From;
	b=kDFWSKKhTzgT/BUkVQBPpj0CouY+yzncvMMxb7gRk9lJkxvn0ehmeumHftp+QpNAC
	 /qeccn98H4rTfdznl5JygLpIscKGW83OxJCy99Bxn4VnCuIDzWI31RvA3X5GQyvU+T
	 ODOoUx+kioj9/rlIUCEACydEFpxcEEyRDFv+ALh0=
Date: Sun, 16 Nov 2025 17:34:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-obsolete_target-sysfs-file.patch removed from -mm tree
Message-Id: <20251117013418.395D9C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document obsolete_target sysfs file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-obsolete_target-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document obsolete_target sysfs file
Date: Wed, 22 Oct 2025 18:25:29 -0700

Update DAMON ABI document for the newly added obsolete_target DAMON sysfs
file.

Link: https://lkml.kernel.org/r/20251023012535.69625-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-obsolete_target-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,13 @@ Description:	Writing to and reading from
 		the target process if the context is for virtual address spaces
 		monitoring, respectively.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/obsolete_target
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		obsoleteness of the matching parameters commit destination
+		target.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/nr_regions
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

