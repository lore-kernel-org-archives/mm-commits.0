Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0E361DAC
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388535; cv=none; b=TRAbLP4jrHKmcHYNqtcX1dcaI/TtVV0+SrOqWpOsUo0864sn+eDlbW0juImTKL8ro/gwl9gmTi0wEIh+MU6Rrkg90tKudaQz/FIWTPZ/9mXOuhEV0Y8gBDC/ozVDvQj1FSRPZeHf3p6s98OnCHDw1k9kVk/RgT5FWl23WK/lqKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388535; c=relaxed/simple;
	bh=Gjcw/790/jLYFjmEJ5w6j5DowkcG/pRbbG5xF1ANpMc=;
	h=Date:To:From:Subject:Message-Id; b=oSTGengSBcO5j16veznzGCGueQKLpYJn26tvwn4KjUa+5qHZYoCyFUcZ4j1VSsLJcnBFhacNGul/3TWiC0uF1WTeRDi4A08k5kJN/jap+u5nRbJ32gKJ5BAmrPOKTIt4A9qZAaXQJleMFFqhg3bYMZGYTeduVNdarC97/QTLUhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyvHA2Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyvHA2Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59976C19424;
	Tue, 24 Mar 2026 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388535;
	bh=Gjcw/790/jLYFjmEJ5w6j5DowkcG/pRbbG5xF1ANpMc=;
	h=Date:To:From:Subject:From;
	b=uyvHA2FdZK4/5z499Y26LWvi3teFfIRsWPmPrfMYSEIUx/97ZAfWkWKZzN2h8S8ZT
	 wY+AJg/0FuhjLKjWQIukTV997J+JrkeHGZcvxZag5IzQY9CXk+ZOHj/D3aMY/YQLpl
	 6jbzavMpEFrXosqATqzOzovdjpzytlmNHrxJZxZ8=
Date: Tue, 24 Mar 2026 14:42:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,sayalip@linux.ibm.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,anshuman.khandual@arm.com,anishm7030@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch removed from -mm tree
Message-Id: <20260324214215.59976C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip migration tests if NUMA is unavailable
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-migration-tests-if-numa-is-unavailable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 0c2d08728470 ("mm: add selftests for migration entries")
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


