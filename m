Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD893B6C13
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439013; cv=none; b=AUV/zOO4gysUtQoYY02E4sdElZtnlGEGpF3/1ZOaSQ2Ecchr6JLwRLZTvYMvxZ0FxhlCm5V4LwuT8LI8C6WRwY6rUiLKaYY//SiuNqTbU/NQJW4VX37rVnpqQJYP0grCI/MCeMelaSgHsdS9byG9qnM+lMlN0b4apcIeMZuhfiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439013; c=relaxed/simple;
	bh=nNFRHU7cGbcCik6cImtm/3FVGQt4kJCx+mkDS96KtEA=;
	h=Date:To:From:Subject:Message-Id; b=oGiFIeYKMwYuLaFvnhH+MozZdTrzlC+Lk2sWanZnefsHh8vWsLtTBj9uB144/774g0V+PiNs+P2POMN42NmrDztY/sEExbQxFc/UjnxgaWMaFguAMvxYKIqWIbWz49nB92w4EFnSUZOg3ul8eO8exlmMBY8SjoeqZ7Q3aRJWAk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZuzVNEnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZuzVNEnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3041F00898;
	Tue,  2 Jun 2026 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439011;
	bh=GckvL5XuIHyCllUizW1cL9Mh+sA7ChYYntJf8nvcT1g=;
	h=Date:To:From:Subject;
	b=ZuzVNEnEzB5lNABKmlPzvT3ogHw1dR+Xgv3fZXw6To5vX4qy7hgbmehauc91SfQ2c
	 ROV6w8cygeA+mg1TuNeZB+lIrPqewLnfLOn0qAYyaZc7DNsRkvzeYjyw2ySmy5KKUZ
	 cOq6FGflVbVn4UoZMcwauk+FR5cIper86ExJWOxc=
Date: Tue, 02 Jun 2026 15:23:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ljs@kernel.org,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch removed from -mm tree
Message-Id: <20260602222331.BE3041F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix mmap() return value check in run_migration_benchmark
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix mmap() return value check in run_migration_benchmark
Date: Tue, 12 May 2026 18:13:05 +0800

mmap() returns MAP_FAILED on error, not NULL.  The current check uses
!buffer->ptr, which evaluates to false when mmap() fails (since MAP_FAILED
is (void *)-1, not 0), so the error path is never taken.

Link: https://lore.kernel.org/20260512101305.139509-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2738,7 +2738,7 @@ static inline int run_migration_benchmar
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (!buffer->ptr)
+	if (buffer->ptr == MAP_FAILED)
 		return -1;
 
 	/* Apply THP hint if requested */
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch

