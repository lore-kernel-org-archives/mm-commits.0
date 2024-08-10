Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83D17E
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723253602; cv=none; b=o+C6HNsD6fsCyTl9kk4KEM57CYYOy9iRr949UX1pyfTs8rX2W7pLuPvdC/uNM85e47oUmfOllpEHvNX4Dc3Kpzb49hq1QGE6wulJcrnd0KcvlbfGtm928juW+O0h+QN3/zNy0qTNc8sbZFTsVdUcVbUEO9yLH2G/8rW81apctfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723253602; c=relaxed/simple;
	bh=ZWyJ0QMn1TYhZEdCEkSLPK+CkYPe9md9IpKDXrugVjQ=;
	h=Date:To:From:Subject:Message-Id; b=ZX1EBkrUjXL2MPQT6mUIAYbieo31BhSFEqJGiuJEZyNtz6/O62r5RDq0BgXoXUChBfz2OVfU49i2V3TP/C5WHUFOJ3chUKhbQOMDal+8FZm4fjwkyruU0KGK3p1Fj9teytxQJrNyH3fei9y2MBqKDZS8uIXsHGzwa3yX6JkGB90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j7Gw74tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j7Gw74tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F097AC32782;
	Sat, 10 Aug 2024 01:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723253602;
	bh=ZWyJ0QMn1TYhZEdCEkSLPK+CkYPe9md9IpKDXrugVjQ=;
	h=Date:To:From:Subject:From;
	b=j7Gw74tBY2FN3PRtL0dom1/bPTXasFzquYUidvD1+meXVLbDSfGe4ptU31T6E+avi
	 37Z73XAoQ3oZShDKyCpSfgwgEGLTjd4yjEZI+BJ8NdRdZOHQ1kWhRHMusbZu+tA1Vr
	 e30cTW/XwKOhiA5Wg1v9xhhQ1duVz3xZS0tQPdJI=
Date: Fri, 09 Aug 2024 18:33:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch added to mm-hotfixes-unstable branch
Message-Id: <20240810013321.F097AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: compaction_test: Fix off by one in check_compaction()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: selftests/mm: compaction_test: Fix off by one in check_compaction()
Date: Fri, 9 Aug 2024 15:32:30 +0300

The "initial_nr_hugepages" variable is unsigned long so it takes up to 20
characters to print, plus 1 more character for the NUL terminator. 
Unfortunately, this buffer is not quite large enough for the terminator to
fit.  Also use snprintf() for a belt and suspenders approach.

Link: https://lkml.kernel.org/r/87470c06-b45a-4e83-92ff-aac2e7b9c6ba@stanley.mountain
Fixes: fb9293b6b015 ("selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-fix-off-by-one-in-check_compaction
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -89,9 +89,10 @@ int check_compaction(unsigned long mem_f
 	int fd, ret = -1;
 	int compaction_index = 0;
 	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[20] = {0};
+	char init_nr_hugepages[24] = {0};
 
-	sprintf(init_nr_hugepages, "%lu", initial_nr_hugepages);
+	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
+		 "%lu", initial_nr_hugepages);
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch

