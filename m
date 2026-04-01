Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3286329395
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 20:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775076215; cv=none; b=fMYi40W3isE4XVpksh5qtwB42x7+46wZSFPlcoHTWxhK9xpC5S/zcX8dTEpbY9apZu236tJWXAIY2MFCp4sOExCbbODAqk1DG8ypFwm9rDurCD8HDns/Dn5F2nSMztlJchjVuGW+adkQa7tOUDwUqPiZC82SLmIvnbLx0clC6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775076215; c=relaxed/simple;
	bh=UgjDlo5FOff33DyXRk2o7PLxsdADH2Xybeb2VbhIwIc=;
	h=Date:To:From:Subject:Message-Id; b=rAXPnHPdm6wDeabpA+MDgRh61sn0vPurSJKhEkpSmolg08QEx43W/HtE3fPpIBNNK9RZVsvBpaFG0NJK8ci2VMRM0x9tbHpYGWnZglZcO3CL1141EebegQimP2G3n6+a+a90BTN6TBsFSnpuv136jz/ZAxONbIC/7mqhCDYGY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5CLYOeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5CLYOeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F792C4CEF7;
	Wed,  1 Apr 2026 20:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775076215;
	bh=UgjDlo5FOff33DyXRk2o7PLxsdADH2Xybeb2VbhIwIc=;
	h=Date:To:From:Subject:From;
	b=Z5CLYOeZa+3YBEmgSqR1I1jE70Yw89bfPuruccY094f8NG08LQsLz2JWAYpa1oY2P
	 RsPA/oYI7j2kj9/ryw7Yys1ybIfIxZrOnpDjPbX9y9dvvEEJwjLB48Ea6UDEEyAzhe
	 8VoLrN9PykDsaP+DB7oZ3nqCXoblVjw39rlA4u4w=
Date: Wed, 01 Apr 2026 13:43:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch removed from -mm tree
Message-Id: <20260401204335.4F792C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

This patch was dropped because it was folded into tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
Date: Tue, 31 Mar 2026 11:01:35 +0100

simplifications per Pedro

Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -1245,7 +1245,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 		SKIP(return, "mseal not supported, skipping.");
 
 	/* Map carveout. */
-	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
 			MAP_PRIVATE | MAP_ANON, -1, 0);
 	ASSERT_NE(carveout, MAP_FAILED);
 
@@ -1257,14 +1257,14 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 * |-----------|-----------|-----------|
 	 *      ptr         ptr2        ptr3
 	 */
-	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
 		    PROT_READ | PROT_WRITE | PROT_EXEC,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr2, MAP_FAILED);
-	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
@@ -1276,10 +1276,10 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 * |-----------|-----------|-----------|
 	 *      ptr         ptr2        ptr3
 	 */
-	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);
 
 	/* Make first VMA mergeable upon mseal. */
-	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+	ASSERT_EQ(mprotect(ptr, page_size,
 			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
 	/*
 	 * At this point we have:
@@ -1291,7 +1291,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 *
 	 * Now mseal all of the VMAs.
 	 */
-	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);
 
 	/*
 	 * We should end up with:
@@ -1303,7 +1303,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-khugepaged-fix-issue-with-tracking-lock.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

