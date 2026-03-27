Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F313F99E9
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634359; cv=none; b=VnyvDYXdhSiklgSXw8bBeUAgIVZDlDqrF9WyPnPzkCGN8MEonQfcLkAWeKJZWUnji6nMJLpWDZbmvaFOkZv5secmqgddtahIyRgI5QQcpYvsjscVvj0ha8Z4gX1z7ZQc2iLU+L28U0n5hl+UHevPx8ZTuOcv/JVxxvjzvlC3sMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634359; c=relaxed/simple;
	bh=90OI0rFJaNy0COypHLf0B683W3J2MBmfPuwcfg/dZRw=;
	h=Date:To:From:Subject:Message-Id; b=sbZeAWeovuf6LmQu8jdsjc8v14DDAYNO8EI5gCZBf2TlTOzIbbkrFEn5mS5LEFvj2+JeKy+iuYTYSeSTBYAostrpRGTieyI/uTtD51LJDG+XvOij34FM7xxA+r1PgVfyFQSydNQZ6ylUZE6WZmFWJo6fDvJ2gc6smHa7LnYyVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KlHWUz9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KlHWUz9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC72C19423;
	Fri, 27 Mar 2026 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634359;
	bh=90OI0rFJaNy0COypHLf0B683W3J2MBmfPuwcfg/dZRw=;
	h=Date:To:From:Subject:From;
	b=KlHWUz9qt3hkQTsjpIuyZCbzl/I96pbbWKWdbQxFBu428pOAhGWVjLQaf0+tpmGTU
	 WSdDPuG8+Peu5m+RIYYPmZYOaRSHw62OVwEpVq97elHWd4vv+CstiAy61whafQYZ+h
	 m8O+mNg+WfdQb4qFsGQysh9pOS7JJ1by/CdxrrmI=
Date: Fri, 27 Mar 2026 10:59:18 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch removed from -mm tree
Message-Id: <20260327175919.2FC72C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Thu, 12 Mar 2026 17:55:37 +0530

uffd-stress currently fails when the computed nr_pages_per_cpu
evaluates to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g. 1GB) and a
high number of CPUs, where the total allocated memory is sufficient
overall but not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources
rather than incorrect kernel behaviour. Update the test
to treat this condition as a test skip instead of reporting an error.

Link: https://lkml.kernel.org/r/2516cad1d9dcbe613619a1006aed1991302c9bee.1773305678.git.sayalip@linux.ibm.com
Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

