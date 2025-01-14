Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE91C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836935; cv=none; b=h4QkGRQKdLXJC9KTM/Be6DD1KSQOCEocaZvjEIaihXEj7kwFFX/khOezPCl/Q0RjRmUxBXPiWa1t27cP29MQFH40+OsOv4xl9yMSYZ573DrvAL1Oy3QBH8utWIrewSjgnKFA9HTs7PyYjGIZsJrNOIuUQvcAf+PPi2YDVCRph7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836935; c=relaxed/simple;
	bh=Pyk0eZEMOAcG/oI5dGtlcjfB6HrbLcYaW7tKqN1qlIc=;
	h=Date:To:From:Subject:Message-Id; b=mRTJen6o6i8z7KEm1Gofv62qclBiqkrpu6otWu4jx0fgc1RHKQwsOiWEkQ/a7ho4+DyLB9dk+erY51NdLzqiSaUEoNx2R7wsh8NKw5ZcO40m+TrTZjnvI4OIpIZ/HdFgfhjM3nNbmfADSsvsLsjlIKMBmdyHM4//5+szuL65evs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXtF4tgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXtF4tgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37C6C4CEDF;
	Tue, 14 Jan 2025 06:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836934;
	bh=Pyk0eZEMOAcG/oI5dGtlcjfB6HrbLcYaW7tKqN1qlIc=;
	h=Date:To:From:Subject:From;
	b=bXtF4tgkKPeHOphXyBVimnTmZIEW55FesiAYJ2h80Y4dafkLACeRkddn4zrjzcOIQ
	 OMJ+35zhQB7qIbEvY61c5wAMOV1x5WyT7LuVtnO6/OFG3f/qeGXua85oDvjfidCBE9
	 XJWg9AbOAh0JCxu9GkNDfesfS1KZmCVL88fVNOAY=
Date: Mon, 13 Jan 2025 22:42:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jhubbard@nvidia.com,donettom@linux.ibm.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-a-few-missing-gitignore-files.patch removed from -mm tree
Message-Id: <20250114064214.D37C6C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add a few missing gitignore files
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-a-few-missing-gitignore-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: selftests/mm: add a few missing gitignore files
Date: Mon, 25 Nov 2024 14:40:36 +0800

Compiled binary files should be added to .gitignore
'git status' complains:
   Untracked files:
   (use "git add <file>..." to include in what will be committed)
         mm/hugetlb_dio
         mm/pkey_sighandler_tests_32
         mm/pkey_sighandler_tests_64

Link: https://lkml.kernel.org/r/20241125064036.413536-1-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-a-few-missing-gitignore-files
+++ a/tools/testing/selftests/mm/.gitignore
@@ -36,6 +36,9 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
+hugetlb_dio
+pkey_sighandler_tests_32
+pkey_sighandler_tests_64
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch
mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch
mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch

