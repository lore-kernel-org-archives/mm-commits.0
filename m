Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A544130A54
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854697; cv=none; b=FbtNuz5J9ndVA/HE/Inj6ZF1+YKwGJWjhkPYSickv1n4eY16Wu3GsBlL7OaNVIC2dJAUM9y4Iv1TAGIdU7vAxG0dX8urqvUVNxH/eq9G9qz3H6HmpiVH12/AyT5w2VzkLOXrpDMbzpub92ZxbltcLGaDO/qTc0wDwmvAvChFGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854697; c=relaxed/simple;
	bh=p8wk0HPpEg0WDgwtqmIL2n+G4i90vvOvaamIhLsyzGc=;
	h=Date:To:From:Subject:Message-Id; b=kl/bSSuQlTEytxcFqdi/MtLWhZLl61mLHF94MfXeKcyO/RmtnkhDoDitP/vVpGT05T6z1Mv6MRwArxWRlxJRsBWVRBRslh5EW4wl98ONElUJXY8oE0jJ8CAQ2EOaxfvfgJ/nbhpnMKZPi2Eqd8s6la7/DG5UIkWUjS/16pdXcyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SEQgnzcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SEQgnzcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8680BC4CECF;
	Wed,  6 Nov 2024 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854696;
	bh=p8wk0HPpEg0WDgwtqmIL2n+G4i90vvOvaamIhLsyzGc=;
	h=Date:To:From:Subject:From;
	b=SEQgnzcnwNl8wTBMA2M3Y94vyjOumzkuKb3X49AbathtEHLzAt4iGt1R2CEhpB1Jx
	 3T+PSNWXtITIsc9fS2+xZKrc7u6lfI7csw2zcfmFJS9jY/Bxb1tXhNmu2UuFXet1DU
	 +VDtbaga8v/pjunCIecaZ7SjvWts2R97soXVGZs4=
Date: Tue, 05 Nov 2024 16:58:15 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,keith.lucas@oracle.com,donettom@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch removed from -mm tree
Message-Id: <20241106005816.8680BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add pkey_sighandler_xx, hugetlb_dio to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add pkey_sighandler_xx, hugetlb_dio to .gitignore
Date: Tue, 24 Sep 2024 19:59:11 +0100

Commit 6998a73efbb8 ("selftests/mm: Add new testcases for pkeys") and
commit 3a103b5315b7 ("selftest: mm: Test if hugepage does not get leaked
during __bio_release_pages()") generate test binaries hugetlb_dio,
pkey_sighandler_tests_32 and pkey_sighandler_tests_64 but did not add
these to .gitignore.  Correct this.

Link: https://lkml.kernel.org/r/20240924185911.117937-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -51,3 +51,6 @@ hugetlb_madv_vs_map
 mseal_test
 seal_elf
 droppable
+hugetlb_dio
+pkey_sighandler_tests_32
+pkey_sighandler_tests_64
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

