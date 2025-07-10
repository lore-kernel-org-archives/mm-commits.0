Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EFA284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126295; cv=none; b=aMqvLeH8gYOPwd1prX0thUSHTOpD8wjKVBJAiIVqDZH17VkWiccVQQdBMoQWmWk4LGyBkoO/TjpY97DWBWZK+yHMC+A6WnnTgkqFP+2luAYb7PyAnmS94LUf1zFEcn1n4xDOaYwLq00jY9xM8/oneKPRl1NhzU4s3mx0Do/iAUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126295; c=relaxed/simple;
	bh=yMmxsMIxjZuK9+kNRQI73UmMiWH48W1jtEMuw3Uab54=;
	h=Date:To:From:Subject:Message-Id; b=uqCc4qBLhaXO0b9ZBXtkBT72iC5TOCneDAOnBMgbdm+DLmOIz0sa/wAq1lhC1ARAS3+5EXcjXIpWO6OK7sKWjRe14wMV8HOM/qzor3oGC/siCBQ1XJ1E6Pi52pmAM6z6OKndnNt8u/UbpLrDF1LaA8jLPDeEAADoMsOpuw3dKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KchL8MuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KchL8MuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF035C4CEF5;
	Thu, 10 Jul 2025 05:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126294;
	bh=yMmxsMIxjZuK9+kNRQI73UmMiWH48W1jtEMuw3Uab54=;
	h=Date:To:From:Subject:From;
	b=KchL8MuIp+j+iWIkpbyThfy5f++PJUjGGbN1n/73O2AGO7JIlvscI3ITC2Epph2T5
	 ujhPXdonZY9AyPoRDi+/UB2G7+2OmQPq6f5og/WEeJ7I2cXofCd4laBt0gL4hn2aBF
	 NsVw9NBJP+zFk5saTnNHkmUNcWRmzjinA1HTxQ5I=
Date: Wed, 09 Jul 2025 22:44:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,mcasquer@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-khugepaged-fix-the-shmem-collapse-failure.patch removed from -mm tree
Message-Id: <20250710054454.BF035C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: khugepaged: fix the shmem collapse failure
has been removed from the -mm tree.  Its filename was
     selftests-khugepaged-fix-the-shmem-collapse-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Tested-by: Mario Casquero <mcasquer@redhat.com>
Cc: Barry Song <baohua@kernel.org>
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

khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

