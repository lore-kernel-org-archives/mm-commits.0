Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCF18DB1A
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 03:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749783850; cv=none; b=pgIKeiR0B78FtzlyRPVtNsFanae9EBPY0ZaL3Si4BtQ4p4fKMQhlJPQ7AlMrkLf2oadbM8Esz56uXjOR469Gr6i2xX1G5Qnqie/TDrOBhEqkNlKs24Ul6f/NbkQgyae+Jahwi+5c3IRVJRJc2uAXvpVPQoLofaRdyfl93Cwk3pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749783850; c=relaxed/simple;
	bh=dOX4udISPPHF7kJdJiEF88x5EqMocPfSyTqehuZwGAQ=;
	h=Date:To:From:Subject:Message-Id; b=e1H8afenOT1nGhMSvsqn98nIzU6r9t4yRgWHvMMuvLa8RcC01tHlQx+BFw8OMREK3domjcpv4QSpjO9yrc7Vj1mVrB/K8nDy16UYQCCeigBIKJ0oDB/XCjbrZlm3Se1lSGZMT02k+EDI0h/TBdIbNOcLuj2ONLXc+Tp6Z+JEKwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S94RBuf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S94RBuf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72848C4CEEA;
	Fri, 13 Jun 2025 03:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749783849;
	bh=dOX4udISPPHF7kJdJiEF88x5EqMocPfSyTqehuZwGAQ=;
	h=Date:To:From:Subject:From;
	b=S94RBuf4bsClz9DU9s32zDxxDOFGZyqPRMA5t/NQowJVUbzPrhxzj0bSfuRIYAYF4
	 1Iguf/NSzE9A55KpNcB4BdgDkIZskJ4tXw29xYvHGFkqnJ/eNArZtVGYHQzay6ePRL
	 OcqWgCjt+CObBgnCAbPz6xllM6vJ/Y9SJP+Zq2EM=
Date: Thu, 12 Jun 2025 20:04:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-khugepaged-fix-the-shmem-collapse-failure.patch added to mm-new branch
Message-Id: <20250613030409.72848C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: khugepaged: fix the shmem collapse failure
has been added to the -mm mm-new branch.  Its filename is
     selftests-khugepaged-fix-the-shmem-collapse-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-khugepaged-fix-the-shmem-collapse-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: khugepaged: fix the shmem collapse failure
Date: Fri, 13 Jun 2025 09:49:19 +0800

When running the khugepaged selftest for shmem (./khugepaged all:shmem), I
encountered the following test failures:

: Run test: collapse_full (khugepaged:shmem)
: Collapse multiple fully populated PTE table.... Fail
: ...
: Run test: collapse_single_pte_entry (khugepaged:shmem)
: Collapse PTE table with single PTE entry present.... Fail
: ...
: Run test: collapse_full_of_compound (khugepaged:shmem)
: Allocate huge page... OK
: Split huge page leaving single PTE page table full of compound pages... OK
: Collapse PTE table full of compound pages.... Fail

The reason for the failure is that it will set MADV_NOHUGEPAGE to prevent
khugepaged from continuing to scan shmem VMA after khugepaged finishes
scanning in the wait_for_scan() function.  Moreover, shmem requires a
refault to establish PMD mappings.

However, after commit 2b0f922323cc ("mm: don't install PMD mappings when
THPs are disabled by the hw/process/vma"), PMD mappings are prevented if
the VMA is set with MADV_NOHUGEPAGE flag, so shmem cannot establish PMD
mappings during refault.

One way to fix this issue is to move the MADV_NOHUGEPAGE setting after the
shmem refault.  After shmem refault and check huge, the test case will
unmap the shmem immediately.  So it seems unnecessary to set the
MADV_NOHUGEPAGE.

Then we can simply drop the MADV_NOHUGEPAGE setting, and all khugepaged
test cases passed.

Link: https://lkml.kernel.org/r/d8502fc50d0304c2afd27ced062b1d636b7a872e.1749779183.git.baolin.wang@linux.alibaba.com
Fixes: 2b0f922323cc ("mm: don't install PMD mappings when THPs are disabled by the hw/process/vma")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-khugepaged-fix-the-shmem-collapse-failure
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -561,8 +561,6 @@ static bool wait_for_scan(const char *ms
 		usleep(TICK);
 	}
 
-	madvise(p, nr_hpages * hpage_pmd_size, MADV_NOHUGEPAGE);
-
 	return timeout == -1;
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch

