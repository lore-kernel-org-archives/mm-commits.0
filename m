Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6936F8FE
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067207; cv=none; b=nF7E+BvVJ8UXEmLFafnl4vjE0qGVRn5z0jIq7ah4bZUThrZdnrJfBJHYm/TLGZPmBVGd1aKWjh6hzAc79RYwOQlSyF7irVRw4aRJZxagUCPdAjzNkQw2+5Kx0Wl1aLBgRFgQ1Nmwf37kj0k0RmhWG2Ds7IgBTud0c3o1OCZEiHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067207; c=relaxed/simple;
	bh=gfioa/czNApH2avrmt3vrvu/82WPqs83Umu5pahatZw=;
	h=Date:To:From:Subject:Message-Id; b=IuwNjuJVMRMdSsJMpvSXrGg1fmSt7vVpSbcNr2rWMi+MkCAqxzGd0fq08B3kfUKcgtezBJoic4MQXqRDHWfUYhlHvwN9vgx9kTljQmGqgYBB5L3PbU01X7rJ2KlZ0naWiex7BEOzLjsxZKlldXMje+4LJTUaT6jN3TTc8r41FmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/ze1yUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/ze1yUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB18E1F000E9;
	Sun, 21 Jun 2026 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067206;
	bh=icPeCyU26T/Y8aWNdelgI6ckNjV0M6si0sG7M6KSu0c=;
	h=Date:To:From:Subject;
	b=i/ze1yUNMBFv2dHnYVRQw0rehmeRf1PM+pAWBCzrtMesmrXw7A8Zg4m+myqkhKT+2
	 F3VRfItnkLu+GEns1JBxnUxLJJOOnlRntwnic7flnJGzhTDC4hRWgQQEanAUvUS8IF
	 q9yOTyWEqweu7ml4UkFhKG10OsxuiyuGpG2S96Lc=
Date: Sun, 21 Jun 2026 11:40:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch removed from -mm tree
Message-Id: <20260621184006.AB18E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Thu, 21 May 2026 12:17:51 +0530

uffd-stress currently fails when the computed nr_pages_per_cpu evaluates
to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g.  1GB) and a high
number of CPUs, where the total allocated memory is sufficient overall but
not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources rather
than incorrect kernel behaviour.  Update the test to treat this condition
as a test skip instead of reporting an error.

[sayalip@linux.ibm.com: use ksft_exit_skip() instead of KSFT_SKIP]
  Link: https://lore.kernel.org/88202b56-1dc5-43e2-9d1f-a0823a9531f0@linux.ibm.com
Link: https://lore.kernel.org/0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com
Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -489,9 +489,8 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_exit_skip("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
 	}
 
 	bounces = atoi(argv[3]);
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


