Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CD3446CE
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400538; cv=none; b=tL699/z3nNzcuzZJFKBoza1BkY5vHpXQAjcbCClUkd/WceL5klm7nAciTTcHtAbzFaGP9gDeBnUt70xCA3lSebZh8PX/Hij1dBpEk2Sj2P1M40u/czZ+0tuJr+vWEUaKC+0k89sQBDBg/TYYxuhCDtk3JK80FcH2Od7hwPeIYko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400538; c=relaxed/simple;
	bh=ZKqGcLDr4GZNDJ1nH1UYHzrSDn7gKMP0n4Ef3MTAUvs=;
	h=Date:To:From:Subject:Message-Id; b=C9kWWf8KmoICLujAQVX+8k7rf4fskqkhhPu45qTm+zNUI/j5pS3r6ddxwclaKlO86kI24t44vtc6wWQTIO35+7tkIlUt0j33u875QG+X0RaiOKk7mUKOkDcRPPjp9+1OB0cXJpl0fy4kXND7mTRzHfUZTgjK9YWM5Bk9+kNk5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u7bR6LzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u7bR6LzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD9B1F000E9;
	Thu, 21 May 2026 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400536;
	bh=X675pxZbcRo6XBsvS0BY1TqaEENDRpOqnk0yWIlVU9I=;
	h=Date:To:From:Subject;
	b=u7bR6LzS2/KIAMlTFxlfQpC8bpcSa6gLes+IQn5h9mtyDSqiKjtn8DkESMk/tZ2/e
	 suPudol92A69xk1aLpsIg66ZFXTpg455fbW6vg8mNuPg+f4bZF3nCxxQf8oyh1OM0x
	 8MTU3cAclFmYNKuiVMQggdDnO+KAcBSgrpR8m0kQ=
Date: Thu, 21 May 2026 14:55:36 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch added to mm-new branch
Message-Id: <20260521215536.6DD9B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: clarify alternate unmapping in compaction_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

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
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: clarify alternate unmapping in compaction_test
Date: Thu, 21 May 2026 12:17:53 +0530

Add a comment explaining that every other entry in the list is unmapped to
intentionally create fragmentation with locked pages before invoking
check_compaction().

Link: https://lore.kernel.org/da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-clarify-alternate-unmapping-in-compaction_test
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -181,6 +181,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

