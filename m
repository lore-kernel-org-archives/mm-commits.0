Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD63CB54E
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789165763; cv=none; b=ZCiupuvxKtre0INfzeWOdxm6RVZD3pSSd9ixugQGKingFuZFZ2JhpuHoHpi978YDgtQpgmgkAMDWNwZ20h0TBYfiQTTTGCMLT2sPFrN7NUo1aWujvTpWx014rLXyutApmWr/G6EvCJKzxhReOXZXu02gVbl7Eb1w/wHZjr/dLSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789165763; c=relaxed/simple;
	bh=mqpYSyPbNLaoXnGYMJ7jbzPIk3k8jYE6uekT9X9AAhI=;
	h=Date:To:From:Subject:Message-Id; b=F9fizBGjMkRyMFDXCKkG6Usti9siMeAqFlZ+VQTWavN1bes4jRN4xkg7lrtpYlDWgqB3A5aSeu+unbjbPgE+1T3yZJQBtaq20YOjWVoFuOI8hmsmNl48Y056SapJJkLhE22+7Cnc3ybhh8G0kzQoBK0R82KO/U7qn/IO6Hv5nw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zYwOn3Ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zYwOn3Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19C61F000FF;
	Fri, 11 Sep 2026 22:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789165761;
	bh=CTkpMVuY0JEBBwB+JZ1TL6crDuP00e81MU4ybZft7ZI=;
	h=Date:To:From:Subject;
	b=zYwOn3Ox5VNyobNG+HuxBjJTzFntn29xUXtJpGnxnOIFTUE1xKvOoEBaL14hKUeAZ
	 ZiOxu/KFTUKgvN968ryYpEwUzuTTVokzdOJudfg0wWZJr5w2lspVdjn5QnU/R00kuD
	 3Yc6UWZiN7ja5Gkx2M8nqfkyHT3J4KfPGp6io38k=
Date: Fri, 11 Sep 2026 15:29:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch added to mm-new branch
Message-Id: <20260911222921.A19C61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: fix potential failure for merged VMA in guard-regions
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix potential failure for merged VMA in guard-regions
Date: Fri, 11 Sep 2026 15:29:03 +0100

check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags, but
this can fail if the mapping is merged with an adjacent VMA.

To avoid this potential failure, first allocate a temporary region with
extra pages at both ends, unmap it, and then map the test region within
the temporary address range, leaving an unmapped page on each side to
prevent VMA merging.

Link: https://lore.kernel.org/20260911142904.1825452-1-yeoreum.yun@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
 	char *ptr, *ptr2;
 	int i;
 
-	/* Map a region. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	/* Map then unmap placeholder to avoid adjacent merges */
+	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ASSERT_EQ(munmap(ptr, 12 * page_size), 0);
+
+	/*
+	 * Map a region for the test. Since the preceding temporary mapping
+	 * succeeded, this mapping should also succeed without merging with
+	 * adjacent VMAs.
+	 */
+	ptr = mmap_(self, variant, ptr + page_size, 10 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/* We shouldn't yet see a guard flag. */
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch

