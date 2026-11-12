Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794461448;
	b=v7338lH0LprilwpJoqexkd0cjovMd8Pd4pAIQx88470y7A7gtEnYtPd+MnHCkl3ptyKh
	 0V+FfXQqtj0opPnkJsus78Ye61dPFz3/JRql0pXnfP3Et5Ge5WEGuoSo6zKbDqFm/SkYX
	 2Tkb6L7PPU/HZpTNF86Ywh8B5y7KslYCpuBLNU5FGgGrMTOqkeIiEr8ZHS2lYQLh4PwuH
	 pW8YSdjXCF85NQDRO/53aBioaUhAf0J7DCNpcKe2JLFkLe6s7dhXBoaHeLwfyx+bjUWhh
	 vj02ZJfaCqXXh+sQsUu6Pvi/dERy4wKA2eN7+L+Ps8bQOtqKYVJIEpXL29lpLKlJAxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794461448;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UCDMdzOT5HntZxmIO8JIMYarKA6EY49b0m+OL3KjF+o=;
	b=NBMUQHjBiT2LjTuDIwxNRq0AmU17IDcA57/C1dHgX6RhN7YWQlEuGRsEK+peNz9APEdU
	 pbGVDayJP5KgrZH7jcOPj5VUO/56AXAXfxlePZlHn+7gjNZxC6b/sjK1dBhTJApAkaUgT
	 B6qO0W7IMTsOS5dfugDmn/LLpndNOZFsow/52A6+IQtiXA5YL8iOzuRvQbIsFAT5b1qDx
	 lif3TSXXmPHQty4TvV0hqgBTV+TAgD9U8i8lXnCdf03kZVh1CMV6aeX52DYEWAA1+hjuo
	 6odCcn0aOKRL1fNjk/vphpRS/j84rb7M46MaRNAhOcK/IyxQoq55xk05wApd2epfX1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gTL0AADf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63487606A321
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 05:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gTL0AADf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2361F00A05;
	Thu, 12 Nov 2026 05:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794461447;
	bh=UCDMdzOT5HntZxmIO8JIMYarKA6EY49b0m+OL3KjF+o=;
	h=Date:To:From:Subject;
	b=gTL0AADfZ+QIVfr9tGaKqoRGl6D4a34YP3uu5pVDIxiJChIQNiukmyQg9Q4i4/+cg
	 lIeypSbQJ2Wnk8TindJxFl7m4knTbKT++Y0vHXt8lsBjY+1GioK87QOh5yTZA21dA7
	 KzNeUPp2ltIK8y5uP37VaJVmnqW5i2dGi0O9nkG8=
Date: Wed, 11 Nov 2026 21:30:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,
	chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch added to mm-new branch
Message-Id: <20261112053047.BE2361F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
Date: Wed Nov 11 09:28:37 PM PST 2026

read_pmd_pagesize() was renamed to pmd_psize()

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2135,7 +2135,7 @@ static void uffd_move_pmd_test(uffd_glob
 static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
 					     uffd_test_args_t *targs)
 {
-	unsigned long pmd_size = read_pmd_pagesize();
+	unsigned long pmd_size = pmd_psize();
 	unsigned long nr_pages_per_pmd;
 	unsigned long bytes = gopts->nr_pages * gopts->page_size;
 	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

