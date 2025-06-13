Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C318DB1A
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 03:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749783851; cv=none; b=FFdB5fCBO5AKvnBBQ3TgyE9D0PxPIj9O7Q1o40qOEIMnFpa86JotZTxIzSJyAT2ESY9ATTSGipQT3zXhJx9o5FP12RszmRMwGuzK7I2xg7H/7+Tqk7grs8SwdpbxS9aMD8H9YTHzjposmgY2uyqoOPIf7GEY0NaMxV5N4DEpmmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749783851; c=relaxed/simple;
	bh=TNH+hacEIOHmhYOwEC1sNgaVecuOPLIVRRN36eIxzEQ=;
	h=Date:To:From:Subject:Message-Id; b=R8Xrq77i6TLoDQaWyAtRWuRazDwtiRsRW7OSOKkaVZ0LsOINb3J0R7Nx5hr4I3dQ9sn5LQwAFnG/3bwJcxsG3oG41G/5GcaShtCwgiGkfLScCmg5QCcC6ew52NB+6CW7mAYqe33Tz5Lv+ghXtffPP+sHzAHox5bp/TTtgd09TaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1kmI91BS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1kmI91BS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE3CC4CEEA;
	Fri, 13 Jun 2025 03:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749783851;
	bh=TNH+hacEIOHmhYOwEC1sNgaVecuOPLIVRRN36eIxzEQ=;
	h=Date:To:From:Subject:From;
	b=1kmI91BSZ+SqiM0LN82cqGvewy43fQL9mutBOhRNzkBCFMxeTD/gWl4BPq9iqVxfW
	 AXdgkM6IlqfIw3eEgmwgUnrgaUDC2wX49cTxUU6jdrYYogRyJe8+VUEM3uZ3tXAOmf
	 bL41+UE8OiEIGX0RfmtjmiyxzWZPKji3v8U+E8cc=
Date: Thu, 12 Jun 2025 20:04:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-shmem-collapse-as-a-default-test-item.patch added to mm-new branch
Message-Id: <20250613030411.7EE3CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: add shmem collapse as a default test item
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-shmem-collapse-as-a-default-test-item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-shmem-collapse-as-a-default-test-item.patch

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
Subject: selftests: mm: add shmem collapse as a default test item
Date: Fri, 13 Jun 2025 09:49:20 +0800

Currently, we only test anonymous memory collapse by default.  We should
also add shmem collapse as a default test item to catch issues that could
break the test cases.

Link: https://lkml.kernel.org/r/a30b1529b399f2e649b5a05c3d352f41a68faeae.1749779183.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-shmem-collapse-as-a-default-test-item
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -485,6 +485,10 @@ CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
 
+CATEGORY="thp" run_test ./khugepaged all:shmem
+
+CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
+
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 # Try to create XFS if not provided
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch

