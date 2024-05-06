Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D2E38F91
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957167; cv=none; b=JmzsxVqhAI4w0FqQfDIkx6iuo55TsDrr98nQ31rceRbFDThQv/l67YTsrZlu6xjendM9ejmBIMRNDPb7tkd2Gwi/6WwwxtwJs2f+9H7FGosuRy4YKfp7d2ZW2HZS70CxO4OsWdAMwxoGVDkI866B8sgzdQz2meb08+HG5dwj70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957167; c=relaxed/simple;
	bh=uC4R+cCDSuF34MGWrAY1bpcEAU2LAIztx+zgHitAQwQ=;
	h=Date:To:From:Subject:Message-Id; b=HoQy/NiSvPTw9TZMRSGpUBhT+RthjzIubIRM06yAzAnqkXl5JMIVF4E/LUuFDaHquZrLm+l9LTgiOew/uFQGC07MI1oiLDJmnmEyxqpPfnytwGKBRwgJ/cyVz1IWTQAPTuuoaV9M0Y3EU8gQPw4HdiBbileWtGzUfDeQgrvmNic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kF1dW30d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kF1dW30d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4206C113CC;
	Mon,  6 May 2024 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957167;
	bh=uC4R+cCDSuF34MGWrAY1bpcEAU2LAIztx+zgHitAQwQ=;
	h=Date:To:From:Subject:From;
	b=kF1dW30dichfqAjTitYth71XBVCBs94KMxaWzBgCgL3ASCmKfYeyU8bd9FNBwAOdm
	 oSJGJwM4zp/1/lF3GAAfme+T+8a8/UqJ4LCBiL0QKB+PYyWpZkj8tZkv1fd9OAy+55
	 PdgHzXVE2PdoJFJ0lN8AM6+q6ao+XgMZJOxY9btw=
Date: Sun, 05 May 2024 17:59:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch removed from -mm tree
Message-Id: <20240506005926.E4206C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: gup_longterm: test unsharing logic when R/O pinning
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests: mm: gup_longterm: test unsharing logic when R/O pinning
Date: Tue, 30 Apr 2024 15:15:08 +0200

In our FOLL_LONGTERM tests, we prefault the page tables for the GUP-fast
test cases to be able to find a PTE and exercise the "longterm pinning
allowed" logic on the GUP-fast path where possible.

For now, we always prefault the page tables writable, resulting in PTEs
that are writable.

Let's cover more cases to also test if our unsharing logic works as
expected (and is able to make progress when there is nothing to unshare)
by mprotect'ing the range R/O when R/O-pinning, so we don't get PTEs that
are writable.

This change would have found an issue introduced by commit a12083d721d7
("mm/gup: handle hugepd for follow_page()"), whereby R/O pinning was not
able to make progress in all cases, because unsharing logic was not
provided with the VMA to decide at some point that long-term R/O pinning a
!anon page is fine.

Link: https://lkml.kernel.org/r/20240430131508.86924-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -118,15 +118,22 @@ static void do_test(int fd, size_t size,
 		return;
 	}
 
-	/*
-	 * Fault in the page writable such that GUP-fast can eventually pin
-	 * it immediately.
-	 */
+	/* Fault in the page such that GUP-fast can pin it directly. */
 	memset(mem, 0, size);
 
 	switch (type) {
 	case TEST_TYPE_RO:
 	case TEST_TYPE_RO_FAST:
+		/*
+		 * Cover more cases regarding unsharing decisions when
+		 * long-term R/O pinning by mapping the page R/O.
+		 */
+		ret = mprotect(mem, size, PROT_READ);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			goto munmap;
+		}
+		/* FALLTHROUGH */
 	case TEST_TYPE_RW:
 	case TEST_TYPE_RW_FAST: {
 		struct pin_longterm_test args;
@@ -228,6 +235,7 @@ static void do_test(int fd, size_t size,
 		assert(false);
 	}
 
+munmap:
 	munmap(mem, size);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


