Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF7305699
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779847407; cv=none; b=hwXVN2ASyaiSZNMln2Mgi7zMqUJtGUz3Ek+HjSfR1cYoc5v9MRkucwCQ3NKRIcJgMcL1U9+FNF1llW/bg+g5l2ZMy9RWBW/kc+FGXi8ifKLZ1KJRU7EdRXDgOXmhS6j+65+vpFihminvjxc8pUMsEhioyWZRfmh4V1Nn3P8kLiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779847407; c=relaxed/simple;
	bh=YlA4e8w8KYcBXNGQjmZ68S8byxINlqAMAdAVGuS7CC4=;
	h=Date:To:From:Subject:Message-Id; b=IVUe9TjDe2gasbi+wRSv96hppBVn6yb3u4XjOnZHgZNV0CkCbYhKuoA51uQkxEbdpempUhWPW5P759NcgFmy4i89wRPp9wkcSacsvLgk2Ql3HBmrijZuObhfv/MTdX5aFBewOGl0b0DxX9Cnbp8PJRXlW94odMFYbMMG0yV/+Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1loMiH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1loMiH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8451F000E9;
	Wed, 27 May 2026 02:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779847405;
	bh=YC8UWeaPbh0vD+22U9+zWXSQFGBcMyRSOQ1thfFnY3M=;
	h=Date:To:From:Subject;
	b=o1loMiH+VNVuNDWvCQAuxoM0n+IjqQMaSW3XWffeWL2hm3yVaGxktT0Xva7BzoIMP
	 o3KrdXWdjIWpdn7lXobGm6a/BlIOGULYbIpRg73Q1BqPM+jpDR1VLnwYXjeMWJ3sbQ
	 5tQnk563OiRy8aXL5OMCTnyxjnqVVwfvlLRiMbtM=
Date: Tue, 26 May 2026 19:03:24 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch removed from -mm tree
Message-Id: <20260527020325.5F8451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch

This patch was dropped because it was folded into selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
Date: Tue May 12 02:26:23 PM PDT 2026

remove unneeded local, per David

Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -610,10 +610,7 @@ static int create_pagecache_thp_and_fd(c
 	for (i = 0; i < sizeof(buf); i++)
 		buf[i] = (unsigned char)i;
 	for (i = 0; i < fd_size; i += sizeof(buf)) {
-		ssize_t written;
-
-		written = write(*fd, buf, sizeof(buf));
-		if (written != sizeof(buf)) {
+		if (write(*fd, buf, sizeof(buf)) != sizeof(buf)) {
 			ksft_perror("write testfile");
 			close(*fd);
 			goto err_out_unlink;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

