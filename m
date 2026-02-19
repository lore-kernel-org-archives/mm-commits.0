Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593A32C939
	for <mm-commits@vger.kernel.org>; Thu, 19 Feb 2026 22:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771540794; cv=none; b=UN42zAkO7O2DW57ngS2cR2oFPjEwqWLsZckaO1RTS5ZWW9EgMWhdaLngVMol8cU9cf+Rdft1sxEIKqc3wNqJuFrLdiSczCSaxQqiiHy9T65XU174Gekx5s8vmu3E2ybk2MGHRDBQO5535SPi6dUVTHvqTlALhHMXP78j13ptZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771540794; c=relaxed/simple;
	bh=emMDRHAq5YWK+Sq1DGs+bjirkGjEaIx/Ck+ohKUxJuw=;
	h=Date:To:From:Subject:Message-Id; b=LAnJvH+Wae/nxeTawUMTmVlIlnIOp7SEcvItWXTCrV/s8z2SuKkV54ejwguMYJmlT88SJTuIq1lNHJibckFvCUKm5A2V+cPDirE+fNN2w+KOv7Jn4N4SLGhOXwzEAkwRS6QooOa1BCXh8zARR1Y7En4hcGrDcF0NbvcOpHruY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YxZCghSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YxZCghSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD9DC4CEF7;
	Thu, 19 Feb 2026 22:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771540794;
	bh=emMDRHAq5YWK+Sq1DGs+bjirkGjEaIx/Ck+ohKUxJuw=;
	h=Date:To:From:Subject:From;
	b=YxZCghSl9qRDbcr57SS8Rt3PJrKS4pHLOr+yOsOzdrEIUh6ow+GVMdN3gZh+GOI5h
	 RbiyB1LAKAZ8rSjd+5t1khOXg6y298S5x4+kj6nk290klukdm9n9piP53pCCmjXNGv
	 rJxenw5v2AOZPfn00qnkRH+YoHnJX16V6IzFKiAY=
Date: Thu, 19 Feb 2026 14:39:53 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,sayalip@linux.ibm.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,anshuman.khandual@arm.com,anishm7030@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch added to mm-new branch
Message-Id: <20260219223954.1AD9DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip migration tests if NUMA is unavailable
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: AnishMulay <anishm7030@gmail.com>
Subject: selftests/mm: skip migration tests if NUMA is unavailable
Date: Wed, 18 Feb 2026 11:39:41 -0500

Currently, the migration test asserts that numa_available() returns 0.  On
systems where NUMA is not available (returning -1), such as certain ARM64
configurations or single-node systems, this assertion fails and crashes
the test.

Update the test to check the return value of numa_available().  If it is
less than 0, skip the test gracefully instead of failing.

This aligns the behavior with other MM selftests (like rmap) that skip
when NUMA support is missing.

Link: https://lkml.kernel.org/r/20260218163941.13499-1-anishm7030@gmail.com
Fixes: 0c2d08728470b ("mm: add selftests for migration entries")
Signed-off-by: AnishMulay <anishm7030@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-skip-migration-tests-if-numa-is-unavailable
+++ a/tools/testing/selftests/mm/migration.c
@@ -36,7 +36,8 @@ FIXTURE_SETUP(migration)
 {
 	int n;
 
-	ASSERT_EQ(numa_available(), 0);
+	if (numa_available() < 0)
+		SKIP(return, "NUMA not available");
 	self->nthreads = numa_num_task_cpus() - 1;
 	self->n1 = -1;
 	self->n2 = -1;
_

Patches currently in -mm which might be from anishm7030@gmail.com are

selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch

