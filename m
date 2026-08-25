Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D28349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622959; cv=none; b=B6pAB012d/EaiKkixlZsDiz+b5k6Us5vlXvXwb1BLXH4rf9K+iQ7Y1JZ0NjBArtaHnYYLEireOPKwEcJoY4Xtl2RP49DeoHwPeytPX1Eoq8qdMut5+YenRvLBG1QuwzhW3yDpFqD3zgO/PA4UdRq7wSX/qJ4fug9dE3GKgi/FSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622959; c=relaxed/simple;
	bh=9Q+Qt5lq2a1NCPpmV/REkqfbkgdstEQ7Bki8KO6E+q8=;
	h=Date:To:From:Subject:Message-Id; b=bvR0eAupmVAzDlp8Qi2B73yab+/+hoVgCAdFylyOzCDZ2TbdYo7+4QAi9sMb98g5zFtV4JlOT94hQ99KbNXwGAcxYlcgYUeNnuojX4E0zrSDxyNhPWjMOmhIYLfHgA8DIS4EGdQl6q8QUNchuW9rRsiPWd5aJaU9qLedR0YmzMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oq1L4URl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oq1L4URl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9897A1F000E9;
	Tue, 25 Aug 2026 01:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622957;
	bh=Gu+1FiMzVRu9/0aof7b9iD9+oYAvUW4XaVOepZX+TGQ=;
	h=Date:To:From:Subject;
	b=oq1L4URl4jztl0Env6f1RjslqNBvWzuuIO66bIqS2Sy+oyXy35tKN6xTJ6+zK754O
	 8eMXlTMAubS8cW5cN50ouVklvC3GIaRcVcibFa1l/YF+ZBL1mGdzet3op13FD1HZ55
	 k7v1EKHYSi0KaMvHdbaQt9p+nyEgWaLgXzl4c7Us=
Date: Mon, 24 Aug 2026 18:55:57 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,david@kernel.org,akpm@linux-foundation.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch removed from -mm tree
Message-Id: <20260825015557.9897A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix unchecked ftruncate return value in soft-dirty test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman <anshumantewari123@gmail.com>
Subject: selftests/mm: fix unchecked ftruncate return value in soft-dirty test
Date: Tue, 18 Aug 2026 19:02:06 +0530

test_mprotect() calls ftruncate() to resize the backing file before
mmap()'ing it, but never checks the return value.  If ftruncate() fails,
the file may remain shorter than the requested mapping size.  The
subsequent mmap() with MAP_SHARED can still succeed in this case, but the
very next line writes directly into the mapped memory (*map = 1), which
can trigger SIGBUS if the mapping extends beyond the actual file size.

Check the return value and fail cleanly with ksft_exit_fail_msg() if
ftruncate() fails, matching the error-handling style already used for the
mmap() call immediately below it.

Link: https://lore.kernel.org/20260818133206.39503-1-anshumantewari123@gmail.com
Signed-off-by: Anshuman <anshumantewari123@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/soft-dirty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -152,7 +152,8 @@ static void test_mprotect(int pagemap_fd
 			return;
 		}
 		unlink(fname);
-		ftruncate(test_fd, pagesize);
+		if (ftruncate(test_fd, pagesize) != 0)
+			ksft_exit_fail_msg("ftruncate failed\n");
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
 		if (map == MAP_FAILED)
_

Patches currently in -mm which might be from anshumantewari123@gmail.com are


