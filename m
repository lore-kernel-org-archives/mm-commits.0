Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DD92E7F39
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898438; cv=none; b=Qkz2/p2P9Py+ifHg295Z/B+PMi+Se/AabbXw0qjJVGHRgLj71Q/4CQUqvOEeZGdoU+yTkP4k8vIXEVYNkIT62gJIyNxOnLpSf8hZOdYyWZSweFn2EqB1Paok6cy5ASRdWDLdMuxHp8bGTEeMxX93b5T0KkRT9mY6OJtHwSJx3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898438; c=relaxed/simple;
	bh=zhHHryXZBfclc19BtBFTcEDW8D9P+4WPQjCsGVicuwg=;
	h=Date:To:From:Subject:Message-Id; b=XVaSeKjZHQ+ab4n+3ekNYvGduawt1T5kXKqw8JTC6LZ4Mp0a/HQXfdr45egzYUqPMgCQ8F8JqF1xT7eKh+TVWLUoq3Di6xF0UhOwP6D9ulsoZKdCMQRtFqHE8Lam+MANF+CriXGgr7ou4h3qQAwy81JO+cDueiLKMPdAipuWa98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6neqPzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6neqPzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680A6C2BC9E;
	Mon, 30 Mar 2026 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898438;
	bh=zhHHryXZBfclc19BtBFTcEDW8D9P+4WPQjCsGVicuwg=;
	h=Date:To:From:Subject:From;
	b=R6neqPztrj9e+HDhjtUCSMdU0Q9NOq+XtYKsl7tctFtrMYpTrQJA+sJF4mit/s4mY
	 C4hMebXKivQBJhwezxPVsrN5ojxj5nL763fSXBPhFe7uZaaSY+Ac18ilTC8hGytinC
	 dN8LrPoG+KKObKfJ2OhZ7IptXkemKWrBgbOByPQQ=
Date: Mon, 30 Mar 2026 12:20:37 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-vm_util-robust-write_file.patch removed from -mm tree
Message-Id: <20260330192038.680A6C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/vm_util: robust write_file()
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-robust-write_file.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm/vm_util: robust write_file()
Date: Tue, 24 Mar 2026 09:33:14 +0800

Add two more checks for buflen and numwritten.  The buflen should be at
least one, otherwise the 'buflen - 1' could underflow and cause trouble. 
The numwritten should be equal to 'buflen - 1'.  The test will exit if any
of these conditions aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Link: https://lkml.kernel.org/r/20260324013316.2590422-5-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
+	if (buflen < 1)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
 		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
+	errno = saved_errno;
 	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
+				strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, buf, buflen - 1, numwritten);
 }
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

