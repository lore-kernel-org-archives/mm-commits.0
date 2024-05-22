Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BAD57C8E
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400488; cv=none; b=r1j0ZlVLKOAYqlO47/nTd4h+shdtlpTxjUmczcfmi38KsD5N4NuqG4oI7RX7csTy17twRjRy4bKsgsjyGhwpokaR92g4kKfjUl99+js/vMEKwNnxC57OOKTxRy1oBS7Qr+17xyLNuGCazVdiTTzR7EeaMtKtM8Qekeg4rDfYWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400488; c=relaxed/simple;
	bh=qCnTmzkT0MfepyXPdk7FevFB8c7QCZRZedsksbGc8L8=;
	h=Date:To:From:Subject:Message-Id; b=BGoHQBV0ZGjYvzUffp86yJ/2rK3Qoin3y1AHq4kemMHJZ3asb2QYe36xfzJlCsus3uBSc12p63YpN7XAqGRhwzgZ2S9+uyk/n9iNXzT7ntdwPkIdDvqScrQyU18nR3RMIzYxyOrsZ09usFr7b5JnsZmo9W5EGKDVH/yu6BIBnQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axQeT5pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axQeT5pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFF7C2BBFC;
	Wed, 22 May 2024 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400487;
	bh=qCnTmzkT0MfepyXPdk7FevFB8c7QCZRZedsksbGc8L8=;
	h=Date:To:From:Subject:From;
	b=axQeT5pQWUQfKan4NuyHKiifWF9K6N2NQJFwkmEwQR4O/l3L/WWZTw3FCmLaxhPSd
	 o4L8ir0dplDDlhMMnl/qzM62DN+xKsCXFHm2SC1jB/+SGkh5O+GxgecQNuwZkDpPWf
	 qMxe1+mk6E1hxgm10qEbB+i7aPE/XyELBQrIz2O4=
Date: Wed, 22 May 2024 10:54:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-va_high_addr_switch-reduce-test-noise.patch added to mm-unstable branch
Message-Id: <20240522175447.7FFF7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: va_high_addr_switch: reduce test noise
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-va_high_addr_switch-reduce-test-noise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-va_high_addr_switch-reduce-test-noise.patch

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

selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64.patch
selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch
selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation.patch
selftests-mm-va_high_addr_switch-reduce-test-noise.patch
selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

