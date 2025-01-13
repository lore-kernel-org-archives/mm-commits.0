Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1D1714C6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742592; cv=none; b=tcDlx+BVQSbamTK/0PSxYBisS7aJaSI0phx2CAubiT96Wwxv39Y6ygnUR8OE9+mR9AOljozI/97j8gOEOtzB29D5eiR52k9weFo0rpu5k1hnNcPQW/AizxhtytNoGLTew5qXF6gBw+XEEh8GLWcgRvD/09mrOiL0F6BgP1HJ3pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742592; c=relaxed/simple;
	bh=/lOgevWAFt5vib3DGd0vG8DLGq0m2OyvkPgzJLde/mQ=;
	h=Date:To:From:Subject:Message-Id; b=ch98Ab5T3WpDvYVY4OPIV8eJVsApCUKkTaVzPDJnkkB4LvtSf+2avzt/KFV2jpaCwZcmzgUzoi/haRAC0YgTmjq9PK2zepEIbVfwNawCXg/LpEvHXDCkA8P8YfJqTVyBpQquTHvxT8Ym+z0qOKIFMSDtNI2i+f5zZfw1Ycxpbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xg1FuLPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xg1FuLPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062F2C4CED6;
	Mon, 13 Jan 2025 04:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742592;
	bh=/lOgevWAFt5vib3DGd0vG8DLGq0m2OyvkPgzJLde/mQ=;
	h=Date:To:From:Subject:From;
	b=Xg1FuLPKvhHA64Y/VjoXgkxNmrns2JEafoiBxzbm6OlNx/juh4OuKmXXn4yzc8oNQ
	 ixOfmAkH5k64e5qRBd3NZUiM9By2FH5O/wMbusWWdQIJyIvExVNIbVbwkF4J7+bt0o
	 rsX94dsMGv54IzkemI6RdehJ0vYw5iTmW0Xr1OaA=
Date: Sun, 12 Jan 2025 20:29:51 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-modify-the-incorrect-checking-parameters.patch added to mm-unstable branch
Message-Id: <20250113042952.062F2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/cow: modify the incorrect checking parameters
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: selftests/mm/cow: modify the incorrect checking parameters
Date: Mon, 13 Jan 2025 11:28:58 +0800

In run_with_memfd_hugetlb(), some error handle have passed incorrect
parameters.  It should be "smem", but it was mistakenly written as "mem".

Let's fix it.

Link: https://lkml.kernel.org/r/20250113032858.63670-1-hao.ge@linux.dev
Fixes: baa489fabd01 ("selftests/vm: rename selftests/vm to selftests/mm")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-modify-the-incorrect-checking-parameters
+++ a/tools/testing/selftests/mm/cow.c
@@ -1692,7 +1692,7 @@ static void run_with_memfd_hugetlb(non_a
 		goto close;
 	}
 	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1704,7 +1704,7 @@ static void run_with_memfd_hugetlb(non_a
 	fn(mem, smem, hugetlbsize);
 munmap:
 	munmap(mem, hugetlbsize);
-	if (mem != MAP_FAILED)
+	if (smem != MAP_FAILED)
 		munmap(smem, hugetlbsize);
 close:
 	close(fd);
_

Patches currently in -mm which might be from gehao@kylinos.cn are

selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

