Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB7B1D52D
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705441553; cv=none; b=eYghi0pGi5Sq6RkCZTJw0EAye/K5iiXlNKD8aRZK3l24EVo9tqwfyy5tyPzfypxFjdp4nuEjX9A6+CcPtWZI8FbFS5hbHK/CEbnOh9i6T6xFkUhPE7mdoBo6KzfHTrjTQH0r7JiscQYqVOs51smcFKBDVY32sZj22HYe5GvQtmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705441553; c=relaxed/simple;
	bh=w3hAzGFayHt005e4h+T4v/e/bPl0q2ma55rogSRvHvg=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=Amfa1CS3QWWo5/mo8kOotSD2ctm5D0qMnVk1mdegb7p50GT170kzcTM4ensPxG6md738Lh2RQ/pJkKWIMqnaf2dVgeIu4SavxkSbTiLSjlEzQLpYMeRFMJ6TsqfmwySYN7jskCG+ogmVvn814ElkAxAjrFRT057EyKeW4lau7T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzl4k/BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzl4k/BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13068C433C7;
	Tue, 16 Jan 2024 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705441552;
	bh=w3hAzGFayHt005e4h+T4v/e/bPl0q2ma55rogSRvHvg=;
	h=Date:To:From:Subject:From;
	b=yzl4k/BO2waz4YE0qphL8TVKKQBHpe2btE3N5643MGLeDuV/ikH/rhlKxSwfA61xZ
	 0xAgBZI7U5OA7GbEHy8AkibQ9Q2+RgK6lwD18+bIWWXCT4jVfrZJ6bkrtp3R60gO0t
	 kqBYKV1iAxZaxyq/W2sdLVQdkct2SCwP1HzxZkJg=
Date: Tue, 16 Jan 2024 13:45:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-missing-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20240116214552.13068C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: add missing tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-missing-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-missing-tests.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests.sh: add missing tests
Date: Tue, 16 Jan 2024 14:06:40 +0500

Add missing tests to run_vmtests.sh. The mm kselftests are run through
run_vmtests.sh. If a test isn't present in this script, it'll not run
with run_tests or `make -C tools/testing/selftests/mm run_tests`.

Link: https://lkml.kernel.org/r/20240116090641.3411660-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-missing-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -248,6 +248,9 @@ CATEGORY="hugetlb" run_test ./map_hugetl
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
+CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh
+CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh
+CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 
 nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 # For this test, we need one and just one huge page
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

