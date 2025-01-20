Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835E88BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337163; cv=none; b=P35KOk4g5zBMiZxi0CIFVVVHJmYJxBJO+O2T+887Tc4GCxpxgBHHCyS76dE7Z9kK1R7dJpBw23GhDzA7CbiC1hwCb1RX0wNWipXU7ISpObXb5nCKp2BOT+8IdQ+25lN4ETqoadHFoHcbxaGhgCJfiD1yys0oIoVjxYkKFBa9Ho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337163; c=relaxed/simple;
	bh=0TS2D9aMGRyZsqrqJLvIu9IVaqOEhSiOCEzkiaLJcJQ=;
	h=Date:To:From:Subject:Message-Id; b=PNfwMVRg9zDMXTemgD6C6uhsedA6ryxnLXHdylmxh1B4MNSXCSal/j17HI1J9F2eUwyamzk8bTBj6Bt+oY0fKpAqKM0KX+pnQMnQtfBb+H2Mxh7WVh8BFG6lxX6UBr0a6MdvPUqe10bui1JMtzcWQtqlJ7A/2SFkrTTYxW1Cb6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7D1uJhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7D1uJhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BF9C4CED6;
	Mon, 20 Jan 2025 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337163;
	bh=0TS2D9aMGRyZsqrqJLvIu9IVaqOEhSiOCEzkiaLJcJQ=;
	h=Date:To:From:Subject:From;
	b=B7D1uJhp9KObtFH//mQs997Axo47v7HSaMytCAnhv5A5/TATsToiWndmsk3ZZd6In
	 Lv3AWkXsf3LL6fgwYDPgqmlGQRb8mZDThAJYkVD71uMn+JGCsA+sWzx1Wu4RK1Y5jb
	 KwGS2ALqNTMa4hwDnO8PMlSP8lq+JgPItk+QLiDY=
Date: Sun, 19 Jan 2025 17:39:22 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch removed from -mm tree
Message-Id: <20250120013923.00BF9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()
has been removed from the -mm tree.  Its filename was
     selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: liuye <liuye@kylinos.cn>
Subject: selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()
Date: Tue, 14 Jan 2025 10:38:38 +0800

Release memory before exception branch returns to prevent memory leaks

Checking tools/testing/selftests/mm/mkdirty.c ...
tools/testing/selftests/mm/mkdirty.c:283:3: error: Memory leak: src [memleak]
  return;
  ^

Link: https://lkml.kernel.org/r/20250114023838.48589-1-liuye@kylinos.cn
Signed-off-by: liuye <liuye@kylinos.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mkdirty.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mkdirty.c~selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy
+++ a/tools/testing/selftests/mm/mkdirty.c
@@ -280,6 +280,7 @@ static void test_uffdio_copy(void)
 	dst = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (dst == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
+		free(src);
 		return;
 	}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch

