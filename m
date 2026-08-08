Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8A72F8E86
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786169728; cv=none; b=ja6dpMmDKLUeQBC85EU5lstQqjx2wJOic//SOpTRnrgFVi+JLDDldNgz1Q9UDYE37e8FZ06N+4UbOYQRwssLHgqZ43HFVH93lZsRFwLoZcF0kqLm2JbGf9RDjj/Ugpbi66znm8PdAuuLx4kHVpmP5tq5mtj3pX8oOZdGhxVLM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786169728; c=relaxed/simple;
	bh=1Cmjnjy9UfKeBhWgh6AYw8fI4VjAnJf1uprNTz3e2qU=;
	h=Date:To:From:Subject:Message-Id; b=uAApzBuS+LJ3GMxaPehnq8D+NOTTXvBKDq3jpYrfGg7l0kqgexojCmVBKV4cx8B0x48gTpdHwMxzcy2JBF98y4Gp6xQ1zZvKwwKvyo8agiWJXsGzYChNfYBoNF3x3pdXprv+GKR7qNGO6VJ18jQ6gGCh9GiE81ZmtwcqVtYvAy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jS2zS+i1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jS2zS+i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A01F000E9;
	Sat,  8 Aug 2026 06:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786169726;
	bh=pE86nTiszHpKdE/963LSJtEzK9mGfpaKfR5s+MXha78=;
	h=Date:To:From:Subject;
	b=jS2zS+i19wFHwYLHKw5NQMwfHUxoB3KB3jUUghRkxR7HwwggHLIaY+1ghcouqzR8G
	 ukH3xQc3zFStIsMbCdsv0vrzLK/Mw4fq9xQfK79JBaD1gNIIShGVY7sBNtdJK5VKem
	 vcTWhj/0cOC21RhOHYsvRnQG5uq3YQ4GpesOUI74=
Date: Fri, 07 Aug 2026 23:15:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,aishwarya.tcv@arm.com,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-transhuge-stress-check-duration-inside-page-loop.patch removed from -mm tree
Message-Id: <20260808061526.BF2A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: transhuge-stress: check duration inside page loop
has been removed from the -mm tree.  Its filename was
     selftests-mm-transhuge-stress-check-duration-inside-page-loop.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests/mm: transhuge-stress: check duration inside page loop
Date: Mon, 20 Jul 2026 16:01:05 +0530

transhuge-stress.c currently scans memory equal to RAM by default, in
jumps of hugepage size, trying to allocate and split a THP at each step. 
After the entire range is covered, it checks whether elapsed time is
greater than the duration.  But it is possible that the THP work it does
takes time more than the duration itself, causing the test to exceed the
CI timeout.

Check the elapsed time after each THP operation.  If the duration has
elapsed, break and end the test.  Adjust the statistics calculations to
accommodate partially completed passes.  Also, reject sizes which are
smaller than a huge page.

Link: https://lore.kernel.org/20260720103105.169955-1-sarthak.sharma@arm.com
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/transhuge-stress.c |   28 ++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-transhuge-stress-check-duration-inside-page-loop
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -35,6 +35,7 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	double elapsed = 0;
 
 	ksft_print_header();
 
@@ -60,8 +61,6 @@ int main(int argc, char **argv)
 			len = atoll(argv[i]) << 20;
 	}
 
-	ksft_set_plan(1);
-
 	if (name) {
 		backing_fd = open(name, O_RDWR);
 		if (backing_fd == -1)
@@ -78,6 +77,10 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("open pagemap\n");
 
 	len -= len % HPAGE_SIZE;
+	if (len == 0)
+		ksft_exit_fail_msg("len must be at least %d MiB\n",
+			HPAGE_SIZE >> 20);
+
 	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
 	if (ptr == MAP_FAILED)
 		ksft_exit_fail_msg("initial mmap");
@@ -91,6 +94,7 @@ int main(int argc, char **argv)
 	if (!map)
 		ksft_exit_fail_msg("map malloc\n");
 
+	ksft_set_plan(1);
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	while (1) {
@@ -125,16 +129,28 @@ int main(int argc, char **argv)
 			/* split transhuge page, keep last page */
 			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
+
+			if (duration > 0) {
+				clock_gettime(CLOCK_MONOTONIC, &b);
+				elapsed = b.tv_sec - start.tv_sec +
+					(b.tv_nsec - start.tv_nsec) / 1000000000.;
+				if (elapsed >= duration)
+					break;
+			}
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
 		s = b.tv_sec - a.tv_sec + (b.tv_nsec - a.tv_nsec) / 1000000000.;
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
-			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
-			       nr_succeed, nr_failed, nr_pages);
+				"%4d succeed, %4d failed, %4d different pages\n",
+				s, s * 1000 / (nr_failed + nr_succeed),
+				s > 0 ?
+					(double)(nr_failed + nr_succeed) *
+					(HPAGE_SIZE >> 20) / s :
+					0.0,
+				nr_succeed, nr_failed, nr_pages);
 
-		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
+		if (duration > 0 && elapsed >= duration) {
 			ksft_test_result_pass("Completed\n");
 			ksft_finished();
 		}
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are


