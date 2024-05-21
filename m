Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9ED487B0;
	Tue, 21 May 2024 21:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716328660; cv=none; b=r9AOp9fLBISHgwawq9WDs1Lyqs0vJGrEl+7gkFoxabLo3X7tuEAZQRm9FyQ1dg/JYL/Ylsiaxx496b7/4FqlewnQMrNo4SzTVALbcW5215i5w2IOWHXZJzbs3zZofX4ypB0dQuaPDTjVgfdKKp1qvL5NdmCB4HFyocUA+H8YbSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716328660; c=relaxed/simple;
	bh=z6Cq6IaOtg7fRetGRHSSaZQifhoWds6cYTVmgK/OuCw=;
	h=Date:To:From:Subject:Message-Id; b=eT3JyH/pD2hqCzizsFFuOTZM8bwnX4rYs6Pz2hTyj4vbwpRlKztPBB4O/EM+uPZVNT6S2PNHO46OzFGdXpur8BPKBkU1IYrZsfjGZVg78TdohhSlB8V2tlcGvaqP8K0IoeLcXC3yW3nmtvJ4NNf4uQCdBWBzDCIylmHwzMJqrvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPPZ7QzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPPZ7QzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C3EC2BD11;
	Tue, 21 May 2024 21:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716328659;
	bh=z6Cq6IaOtg7fRetGRHSSaZQifhoWds6cYTVmgK/OuCw=;
	h=Date:To:From:Subject:From;
	b=QPPZ7QzFZD50pgD2nQCrbwOdAZqz1sRZ2qyg3ebmhMrHk/qbdjGY52glXOyhsFxlb
	 dga+Cz2prFQDeW3pbVNR2XmqP7ZEc6H1Uv4ATBkK53NNTVGx0DBrTUtAMBXEECSWr2
	 u2p7jl0IKFU07XfdevA66Otv7EITtvpZMLoiyfTA=
Date: Tue, 21 May 2024 14:57:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjayaram@akamai.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch added to mm-hotfixes-unstable branch
Message-Id: <20240521215739.57C3EC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Tue, 21 May 2024 13:13:57 +0530

Currently, the test tries to set nr_hugepages to zero, but that is not
actually done because the file offset is not reset after read().  Fix that
using lseek().

Link: https://lkml.kernel.org/r/20240521074358.675031-3-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -108,6 +108,8 @@ int check_compaction(unsigned long mem_f
 		goto close_fd;
 	}
 
+	lseek(fd, 0, SEEK_SET);
+
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
 		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64.patch
selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch
selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation.patch

