Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78538635D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788050695; cv=none; b=YYqlOOcmf9SuYWXfDBhCQpvnnzpNaYKte0FMQ1Yk5BmMgWlo15gwpIND3Ycsji5RoU1gbq3/nMtwHzRoMM1jmlb4JvKVymxBB57p5mHvOLjy6D/rLtplc3+jCuXrSqifYF3IxtXPfeTUT+yhxQS4SLeHtM/otZcWack/HuJ1K5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788050695; c=relaxed/simple;
	bh=CI/OgU2o/88BxlhQIT+G52h5nZhIcif5SrMBPXcgmbc=;
	h=Date:To:From:Subject:Message-Id; b=nutPJL8Nqu+0yKZPpa9lzwhaR08HT6Twwffqbr1kQzIXAo+3QiXT7w78M/Is7GiY/qvg2oALtMVb9mtZPgUzz8CGvVQIo1mpUR1IeMmxlaZcToFHen8qs9iOwSH9e21DkkKDgsXHq7Eb8R6/9QpwnyLDGoyFoj/sRo19R4qNpFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8rzautC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8rzautC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187BA1F000E9;
	Sun, 30 Aug 2026 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788050694;
	bh=RLQXIvGoyPf5GqjbWctcxMevRd0vrhFCW1gUAj1z9II=;
	h=Date:To:From:Subject;
	b=t8rzautCH+mb+mvwKwnJzXwADBy3ZayLxs/WhvDPg76r0pm1FVCmQQ4CQmMIqjbJj
	 O9ExED5gtTp2qpzd+aZbnfiXYaGaF9l2ZGgGewDRllLthGAwY9R+TeB9StdfP4PxSn
	 HY5AkF/1Hl62oS3wtYEgXjppiE/8k+Bwsq9RIs3g=
Date: Sat, 29 Aug 2026 17:44:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch added to mm-new branch
Message-Id: <20260830004454.187BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: consolidate error exits via kselftest helpers
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: khugepaged: consolidate error exits via kselftest helpers
Date: Mon, 17 Aug 2026 14:19:55 +0800

Replace the perror()+exit(EXIT_FAILURE) pattern with
ksft_exit_fail_perror() so failures are reported through the
kselftest framework, consistent with the rest of the file.

Link: https://lore.kernel.org/20260817061955.45454-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -337,21 +337,15 @@ static void *file_setup_area_common(int
 		ksft_exit_fail_perror("open()");
 
 	size = nr_hpages * hpage_pmd_size;
-	if (ftruncate(fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (ftruncate(fd, size))
+		ksft_exit_fail_perror("ftruncate()");
 	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
 		MAP_SHARED, fd, 0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 	fill_memory(p, 0, size);
-	if (msync(p, size, MS_SYNC)) {
-		perror("msync()");
-		exit(EXIT_FAILURE);
-	}
+	if (msync(p, size, MS_SYNC))
+		ksft_exit_fail_perror("msync()");
 	close(fd);
 	munmap(p, size);
 	success("OK");
@@ -426,7 +420,7 @@ static bool file_check_huge(void *addr,
 	case VMA_SHMEM:
 		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
 	default:
-		exit(EXIT_FAILURE);
+		ksft_exit_fail_msg("Unknown VMA type\n");
 		return false;
 	}
 }
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch

