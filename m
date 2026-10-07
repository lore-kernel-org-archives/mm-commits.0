Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B30214812
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334254; cv=none; b=n6P62N/wWmLRE6fxWMPEK124oNw+xfZqi+Ja55DOStWhXhUBakneJB2U5lqPVJOOs5Z5lusrclzwn5OUmsteFasd/dkdCmmFYsaO1kxPaLM4nKL+cXytySFA2ipvXJz3WMvXavMnrGD6P24vA73Cmu90P9ffX2Wsit9HBtVUEAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334254; c=relaxed/simple;
	bh=719TDkyNY+rOEcMG6QQMJ1nPBHF5TaDG09xxNTdkYWw=;
	h=Date:To:From:Subject:Message-Id; b=sYjQS9nQo131fzzUzMz6ghYLcWQIl12L8FW73n8prNitc2eKKF24MndVL4FUWypJmmrNqdiy/JwPAdKm52mmDc9uFktFcbpDQYVwTvdKKytGoBEOxrDcb5LjEEEZ/DDIwf388ErN1FbXjtLD/G5i7snJCXxYLECzN1xn2alBePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eeM36SKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eeM36SKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EAC1F0089B;
	Wed,  7 Oct 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334252;
	bh=2Q25xY1tlL3PUUD7QTqFqXN2kKByVWJ/vNwjT434knM=;
	h=Date:To:From:Subject;
	b=eeM36SKbUU+hvvQ32HHjx5yHmqn9AlS7t4yVXrKUBoBwOW5mIcAcs10X8QmYIlbqf
	 fJVgW3wgqpTEg6UkfKRTLxOlMdAU2VZD0700TYKkAOj7YStQCrUfsPEKwhAeB3k+Dj
	 b7x8pdE6XTLb4OFmtw8SWCNa58teLDS7/oawHQLc=
Date: Tue, 06 Oct 2026 17:50:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch removed from -mm tree
Message-Id: <20261007005052.D1EAC1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged: consolidate error exits via kselftest helpers
has been removed from the -mm tree.  Its filename was
     selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: khugepaged: consolidate error exits via kselftest helpers
Date: Mon, 17 Aug 2026 14:19:55 +0800

Replace the perror()+exit(EXIT_FAILURE) pattern with
ksft_exit_fail_perror() so failures are reported through the
kselftest framework, consistent with the rest of the file.

Link: https://lore.kernel.org/20260817061955.45454-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -337,21 +337,15 @@ static void *file_setup_area_common(int
 		ksft_exit_fail_perror("open()");
 
 	size = nr_hpages * hpage_pmd_size;
-	if (ftruncate(fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (ftruncate(fd, size))
+		ksft_exit_fail_perror("ftruncate()");
 	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
 		MAP_SHARED, fd, 0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 	fill_memory(p, 0, size);
-	if (msync(p, size, MS_SYNC)) {
-		perror("msync()");
-		exit(EXIT_FAILURE);
-	}
+	if (msync(p, size, MS_SYNC))
+		ksft_exit_fail_perror("msync()");
 	close(fd);
 	munmap(p, size);
 	success("OK");
@@ -426,7 +420,7 @@ static bool file_check_huge(void *addr,
 	case VMA_SHMEM:
 		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
 	default:
-		exit(EXIT_FAILURE);
+		ksft_exit_fail_msg("Unknown VMA type\n");
 		return false;
 	}
 }
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

