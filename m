Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C5E1509B4;
	Mon,  5 Feb 2024 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707167335; cv=none; b=GEz4WIjb9jZ1GEP/OOnwkVh+O9mOnZW20YcGzNNs1Tbe8N0e0IH9UdYK5nA0bNdI4aCXP2SodkNclJZXwaitfc/ibW502t+IYri2L106urSDiBtwv6KeeD+DaJqitV5W9o5tChzhYJxsJlTUuU4vNE9MTSVNYbiwWAAcM0Nn0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707167335; c=relaxed/simple;
	bh=biKneaSJseSe+6JBLd4UMROHAignWpqHbXjxEn3Vclo=;
	h=Date:To:From:Subject:Message-Id; b=Djktz97jAD5Lrld+rAmkkxld5fG0Y5JerPVvLCrEkg61xVka2Krd3/PwRpjyWc2EJjVMcrYJcrKoXVIMybt2g2tELYxIry7Od5SG0tKxU+im3T+l/JFMRq1j1Y5WfbknJXfaLjSa/FAf5yyJ82u8VxSLG8FwYCqD3bpxE7nvmBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsv47+qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsv47+qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFA3C32792;
	Mon,  5 Feb 2024 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707167334;
	bh=biKneaSJseSe+6JBLd4UMROHAignWpqHbXjxEn3Vclo=;
	h=Date:To:From:Subject:From;
	b=jsv47+qSUNt1dyryv8+31Xb8z1XRgFs+Rh8jOKcFL6dAtNbGytIM/EeJ9u+gQd/yQ
	 0d7cimUOEFN99Jf2RTR96UAj/HyyQWEDUQ3t0wTkoWnWNpxnx8n0/9zDkPC4qlwAtw
	 z3OgJz32OpSVvP3RhcKY/SYwMmyZgt5FQbsoJJJc=
Date: Mon, 05 Feb 2024 13:08:54 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,peter.griffin@linaro.org,terry.tritton@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch added to mm-hotfixes-unstable branch
Message-Id: <20240205210854.ADFA3C32792@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: uffd-unit-test check if huge page size is 0
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch

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
From: Terry Tritton <terry.tritton@linaro.org>
Subject: selftests/mm: uffd-unit-test check if huge page size is 0
Date: Mon, 5 Feb 2024 14:50:56 +0000

If HUGETLBFS is not enabled then the default_huge_page_size function will
return 0 and cause a divide by 0 error. Add a check to see if the huge page
size is 0 and skip the hugetlb tests if it is.

Link: https://lkml.kernel.org/r/20240205145055.3545806-2-terry.tritton@linaro.org
Fixes: 16a45b57cbf2 ("selftests/mm: add framework for uffd-unit-test")
Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1517,6 +1517,12 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
+			if ((mem_type->mem_flag == MEM_HUGETLB ||
+			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
+			    (default_huge_page_size() == 0)) {
+				uffd_test_skip("huge page size is 0, feature missing?");
+				continue;
+			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
_

Patches currently in -mm which might be from terry.tritton@linaro.org are

selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch

