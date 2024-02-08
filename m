Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA467A13
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369680; cv=none; b=lUpC7ka5yySuoWq85WQM37+koN+DiMZkAiYYJXeFUt2y1A32wWJVM1eu8hp6DRUDhBr1OPovhBzMS80HdWtaj19m2YV2n/LSRJn7tFdzYZyY0/gbxyCYBO0Cifck5aWkgUONB46CcgeWcsDAYVcMW2f8bWJzU1FSYJMGKvOCdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369680; c=relaxed/simple;
	bh=rRTFfCmHiJO6ETX8RnWT8k/hffzHvXISMS17HoFODeE=;
	h=Date:To:From:Subject:Message-Id; b=WxLWzrpWHIh8Xq3vYLlG/qSiP6Gq3s1Ypi96BtmQkH6nw1H09cdzFhc9wYDKjz9Khqi+C0yVbqKd7c/5qPZDwfI9fQ31ng/PCEk0EJ3CBxDBGjT1xGfVOpIpdILSHSOdmWfb6rvSzwrqT8f+Wfyn//4KO19Ip4KRNT7GTi/v7nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rB7RR2Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rB7RR2Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFDAC43390;
	Thu,  8 Feb 2024 05:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369679;
	bh=rRTFfCmHiJO6ETX8RnWT8k/hffzHvXISMS17HoFODeE=;
	h=Date:To:From:Subject:From;
	b=rB7RR2UeycjzhsmWVBvd5JMfyMhcuftBcM4KEVQhy9DSHZWfXUaVUMjo2JBPLNFvV
	 8by/upeiFp5GO4DnWgUEDgJgg+lEtK/bMg/Jf3tagOF5Ht8Xje7aRwB4lHZAeiTpj3
	 i54AUkdRhOAqzOJFyAC+Dfr/mQmasqxFGRH4JJtQ=
Date: Wed, 07 Feb 2024 21:21:19 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,aishwarya.tcv@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch removed from -mm tree
Message-Id: <20240208052119.BAFDAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: core: include linux/close_range.h for CLOSE_RANGE_* macros
has been removed from the -mm tree.  Its filename was
     selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: core: include linux/close_range.h for CLOSE_RANGE_* macros
Date: Tue, 24 Oct 2023 20:51:25 +0500

Correct header file is needed for getting CLOSE_RANGE_* macros. 
Previously it was tested with newer glibc which didn't show the need to
include the header which was a mistake.

Link: https://lkml.kernel.org/r/20231024155137.219700-1-usama.anjum@collabora.com
Fixes: ec54424923cf ("selftests: core: remove duplicate defines")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Link: https://lore.kernel.org/all/7161219e-0223-d699-d6f3-81abd9abf13b@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/core/close_range_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/core/close_range_test.c~selftests-core-include-linux-close_rangeh-for-close_range_-macros
+++ a/tools/testing/selftests/core/close_range_test.c
@@ -12,6 +12,7 @@
 #include <syscall.h>
 #include <unistd.h>
 #include <sys/resource.h>
+#include <linux/close_range.h>
 
 #include "../kselftest_harness.h"
 #include "../clone3/clone3_selftests.h"
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

