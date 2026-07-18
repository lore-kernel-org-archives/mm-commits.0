Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091748462
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784333616; cv=none; b=BN5NzwSMHbknCsRw5lg5mvRIYsJAOL2Ukh7ozj5OvCLTPaNKAO8DV6yLSMCGdWHA6e+cD1FuV8MmxgEsBjxdy/FKqoCeL0tsttoBNJv/yLMAWYRuc7KEr8n2l8jZHeAqc/7rOp02n6c+52R4hZMVARJAhXQFkm4JpXxl+n91ipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784333616; c=relaxed/simple;
	bh=rbGJfy1X5i70FOhTM+DSLhI9kqv7aK6Rf0SwD9ArnhI=;
	h=Date:To:From:Subject:Message-Id; b=EVdq6RGz4ouKPy4aHWzQj+Li5Lr07mJFKDnSC+/Oq3oPxXQInwF/WKvqA8pOONfIzG2enJoEELEy2RPeiR/3C/rnrhQxJ1N/mQtg073JO68cq1eyBmrk2gsypxZQDUMv7v3nLIVuU3nmHFwK6E4jMgy32zNUP5kltYQAbH1GkOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8Vp/jk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8Vp/jk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF4B1F000E9;
	Sat, 18 Jul 2026 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784333614;
	bh=6Ab1z+0xS1CMipB6vDZEdj9u9wVrjtH2GRepmhp1vtQ=;
	h=Date:To:From:Subject;
	b=U8Vp/jk5O4/8JumtiokWoPoEHyytO0pVh8saW4YOctCmRegT0Zzg3gnGFdawkvHxz
	 ooN/ypC9IYFOp6/unVGPoS9XFm7bOrPug279OWP6tfz8R5a0W5du6AVl+dQ9rDjI/4
	 f6UsvOR452ySgCCaVAtp9WjiRP93f8/sR3a9IWsk=
Date: Fri, 17 Jul 2026 17:13:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch added to mm-new branch
Message-Id: <20260718001334.5EF4B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Fix BUG_ON checking wrong variable in mremap_dontunmap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch

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
Subject: selftests/mm: Fix BUG_ON checking wrong variable in mremap_dontunmap
Date: Fri, 17 Jul 2026 15:02:51 +0800

In mremap_dontunmap_partial_mapping_overwrite(), mremap() stores its
returned remapped address into remapped_mapping, while the BUG_ON
incorrectly checks dest_mapping instead.

If mremap() fails, dest_mapping still holds a valid pointer obtained from
the prior mmap() call, making this BUG_ON never trigger at all.  Correct
the check to validate the actual mremap() return value stored in
remapped_mapping.

Link: https://lore.kernel.org/20260717070251.73212-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_dontunmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -313,7 +313,7 @@ static void mremap_dontunmap_partial_map
 	    mremap(source_mapping, 5 * page_size,
 		   5 * page_size,
 		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest_mapping);
-	BUG_ON(dest_mapping == MAP_FAILED, "mremap");
+	BUG_ON(remapped_mapping == MAP_FAILED, "mremap");
 	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");
 
 	BUG_ON(check_region_contains_byte(source_mapping, 5 * page_size, 0) !=
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch
selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch

