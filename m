Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE5C179A6
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876071; cv=none; b=tvQmnxYdEFBoGlaTwbzuGsLSSEKmlZ11xfFjo0B8A7exyuP+o1IDcfYOcv8eabhBZEjgMA2CYigfJjH8TkyixhNbJFWIFgG1gVRMxV0daJXEzSe0X2u5fFqQI1rWWc9JVwPyL65GLzq4G3OYqw9MnI7ZozWl9/TeOw1aim1clzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876071; c=relaxed/simple;
	bh=BYXkdIM4sFvgqgGSO5n+Ohco16c8S/XMXK1s1LlBvE8=;
	h=Date:To:From:Subject:Message-Id; b=Swla57LlXOOCPVWRl5PjeANK+Ke3gHs5Z746NPiINhyDXCo8RKXHdwRyi2/aF539S+sUq14WQgrwUHyn1+xO/L1gL7qXhax53ZtOH28CvyOwgF3RFBdutQ424E+7QfMRgfaX4ewFasZZ59IbyIuTvvcnyXYDMC9WNKBb+dAYfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSMXLA2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSMXLA2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C802C433F1;
	Fri,  2 Feb 2024 12:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876071;
	bh=BYXkdIM4sFvgqgGSO5n+Ohco16c8S/XMXK1s1LlBvE8=;
	h=Date:To:From:Subject:From;
	b=jSMXLA2fUsnN7byjDk2BNhZjPpc+xu/oWOqvSosMuti1sQ1U0sT10j2BYcLpIDGT2
	 w8sFMP8wYclbWw+g/b2VEEj3zvwc6wuP4OaclCKFHWWxJYo3jJVktGGCWTg/4Y2FyD
	 D1EzXcF6c7b0SDC9Hd+edkdZPZHZXEEepNfv/fP0=
Date: Fri, 02 Feb 2024 04:14:28 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,jsavitz@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch added to mm-unstable branch
Message-Id: <20240202121430.9C802C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb test category
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb test category
Date: Mon, 29 Jan 2024 03:52:46 -0800

The usage of run_vmtests.sh does not include hugetlb, which is a valid
test category.

Add the 'hugetlb' to the usage of run_vmtests.sh.

Link: https://lkml.kernel.org/r/20240129115246.1234253-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Joel Savitz <jsavitz@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb-test-category
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -64,6 +64,8 @@ separated by spaces:
 	test copy-on-write semantics
 - thp
 	test transparent huge pages
+- hugetlb
+	test hugetlbfs huge pages
 - migration
 	invoke move_pages(2) to exercise the migration entry code
 	paths in the kernel
_

Patches currently in -mm which might be from leitao@debian.org are

selftests-mm-new-test-that-steals-pages.patch
selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch

