Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E286613D251
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291569; cv=none; b=PEw8v+zbWhU/Md61XEqCqN+l7sXR5hvq6SgGtI5la1U21JRqobTQi+aHMzPMPUOuP1Wt/J1RogJs24592BbH16e09fiuZS0LFybXsyJlayciMEh6Kl67b3nWYuTSQn1dHSuAPuJiNwILOx8X8hB5f2ZD/z7sGZgCD/2Trj3H9UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291569; c=relaxed/simple;
	bh=P/v0/o81LKHgL+1x48NxeQzGcSUZdvpdZP0Muvl26hw=;
	h=Date:To:From:Subject:Message-Id; b=ry06OV06pkjl/xYMBo3qqL9QZDC8bhJJNlr170vbUUpX2owndhF1T3NIv/60hdsNEDiGWpDqgCiLipe6EdYNoP6+/7WpqFod6e3nUnc9IjnOknONtLi4P9mrn5yLJDQ73xSjDg4yRuUSHxwZkkJlhHCwaRacxEzIVMju/FpSsGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEvj1nnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEvj1nnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDE9C32782;
	Tue, 25 Jun 2024 04:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291568;
	bh=P/v0/o81LKHgL+1x48NxeQzGcSUZdvpdZP0Muvl26hw=;
	h=Date:To:From:Subject:From;
	b=tEvj1nnPUBh4H8d6yxhjmVW9WvPA07NHRCq1VQ9BZMDNfuAMiGwssFKnjgnfmoZh6
	 CfmhlNlUlqynG8hoS67XTgZTRFaZQh5AU+vXvk6C5XAwoS49MKgkuXDe899cKMYbYi
	 yrrRHjzxCATPPjMGbo9q+En5A2d8TQ+M8LPWweGs=
Date: Mon, 24 Jun 2024 21:59:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switch-reduce-test-noise.patch removed from -mm tree
Message-Id: <20240625045928.AEDE9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch: reduce test noise
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switch-reduce-test-noise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: va_high_addr_switch: reduce test noise
Date: Wed, 22 May 2024 12:34:34 +0530

Patch series "Restructure va_high_addr_switch".

The va_high_addr_switch memory selftest tests out some corner cases
related to allocation and page/hugepage faulting around the switch
boundary.  Currently, the page size and hugepage size have been statically
defined.  Post FEAT_LPA2, the Aarch64 Linux kernel adds support for 4k and
16k translation granules on higher addresses; we restructure the test to
support the same.  In addition, we avoid invocation of the binary twice,
in the shell script, to reduce test noise.


This patch (of 2):

When invoking the binary with "--run-hugetlb" flag, the testcases
involving the base page are anyways going to be run.  Therefore, remove
duplication by invoking the binary only once.

Link: https://lkml.kernel.org/r/20240522070435.773918-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20240522070435.773918-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-va_high_addr_switch-reduce-test-noise
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -57,8 +57,4 @@ check_test_requirements()
 }
 
 check_test_requirements
-./va_high_addr_switch
-
-# In order to run hugetlb testcases, "--run-hugetlb" must be appended
-# to the binary.
 ./va_high_addr_switch --run-hugetlb
_

Patches currently in -mm which might be from dev.jain@arm.com are


