Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E67735839C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622864; cv=none; b=LvR1WMRfEWgjqIYmLntjlGgq4iLmSaR95mCVYu+FoiDasA9Zm7X1/3H9jxgNvMRpBQyErHi2XA8+F/po3td5z5BUG2ezBeqJoJmYbob67KTl/LQaUpv1bgmpwTFoh2N94UVpxvIhW3qyXKyrpcg53ewnebtELkeFrNcTVwfEb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622864; c=relaxed/simple;
	bh=hDZVziZ2dKwqGBMBrmAbaCqUvNrvlq7HKrvxkkyF1s8=;
	h=Date:To:From:Subject:Message-Id; b=E5sU2hk/2ayjD7y7Fgh8CWv6d7oEAms6DZFGaZELs8szoAenoxcnnUIf7wwGEXXtxJxiEKI4ULmvlU+iuTE6xqj8UMf5HYdYcdhKyIIsJ0k+G0HTZQqUY/5ZxyUDXLYE/5HJI8Nj3XOiikxSPwA0Nk5X1BYKnVEq0cWtv07CYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VAeLFlo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VAeLFlo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90D81F00A3A;
	Tue, 25 Aug 2026 01:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622862;
	bh=kD8+ZmOCZRhID9tNGuHnJ+v1efMFt934KFeq12Xs/6E=;
	h=Date:To:From:Subject;
	b=VAeLFlo8xvd63cQ/AoEeNBWtIXcpi7D40rEhXbtC6e1tB7jEEo9VyLMmCu0YarPFR
	 q4kXvpF8Sw8xmOFhSTtE7ylBgaqkLGNzANpCPFGUvd+AvujNPdzfDnnSw7KlFF8RDz
	 1IKyWhELN2MUSNrT2LhbYW+g1pUv8p9RtEUbUgPY=
Date: Mon, 24 Aug 2026 18:54:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch removed from -mm tree
Message-Id: <20260825015421.E90D81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Mon, 27 Jul 2026 10:52:17 +0100

Patch series "selftests/mm: Handle unsupported and transient test
conditions", v3.

Several MM selftests report failures when the test environment lacks
an underlying prerequisite, such as fallocate() support, MADV_REMOVE,
local page-cache semantics, or swap.

This series converts those unsupported cases to SKIP while preserving
failures for unexpected errors. It also allows migration tests to retry
transient move_pages() failures.


This patch (of 4):

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds noise
because the test prerequisite is absent rather than the COW implementation
being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Link: https://lore.kernel.org/20260727095225.372655-1-usama.anjum@arm.com
Link: https://lore.kernel.org/20260727095225.372655-2-usama.anjum@arm.com
Fixes: f8664f3c4a08 ("selftests/vm: cow: basic COW tests for non-anonymous pages")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported
+++ a/tools/testing/selftests/mm/cow.c
@@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_te
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
_

Patches currently in -mm which might be from usama.anjum@arm.com are


