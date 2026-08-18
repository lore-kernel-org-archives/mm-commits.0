Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2E48424C
	for <mm-commits@vger.kernel.org>; Tue, 18 Aug 2026 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076767; cv=none; b=PI88q6Fa5XCQf4PniaPiGNxuV4voA7ohIcP69b+u+KRzWKrwrulTr7niLQN2Jlz6KravCDY3ujvVD3UYTmvmt0dF/ixRQSI0D9bHCCCTC2QOmAacPjMXyWIC7Ym8WiwuPsQlR0EZi3CJpK0RaipqZO4vPRQ2EEua7xwF6VO4afI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076767; c=relaxed/simple;
	bh=O7SRbk5I2WR9oy+hKfFUMUdXjXn7vHUly2zeWCT6YTY=;
	h=Date:To:From:Subject:Message-Id; b=vAorizKjUE1nLf5/U7IVzIvcsWaZffLIqqXYqSvDYIA267jZ6y2Luoa1nxlIJagj5ee+QGb90pzY5miKlZgFS18gDGgdFEKwBgeMJRh6wC6+GY5qiUcBQBWquUC5As0pZGnNWkbUrqinv3IvqfV6RKLrqR9mBaMrFF3OKZhMpBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LhGFlQgM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LhGFlQgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360ED1F000E9;
	Tue, 18 Aug 2026 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787076765;
	bh=0rCDOTXYVAdk5/LXNindm1KEGzGGkJdzpHc6th/1lC8=;
	h=Date:To:From:Subject;
	b=LhGFlQgMN1ajtaGgX+I7yPNK4SnVNaskCmRgxruf6sLxOgBxv9+2PeygsoiLPf185
	 D0MV+uCi1wTcy9yiuR6odJ5C6X26C7xmeFOIKUSPEbah3UXzXKqc8WUyRQFCfIGOy7
	 vGDHyJXcmlt0811mhtOnHguo42HvNFRgwFap5XFU=
Date: Tue, 18 Aug 2026 11:12:44 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@kernel.org,akpm@linux-foundation.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch added to mm-unstable branch
Message-Id: <20260818181245.360ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix unchecked ftruncate return value in soft-dirty test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

selftests-mm-fix-unchecked-ftruncate-return-value-in-soft-dirty-test.patch

