Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1E9279DDA
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756856554; cv=none; b=MWgG6z4ZkYNbCrFaJW9TrGwdCwnaKc/1OsJrNYwxdPJh7KXmce34gjK3fMgzXjcsxTlKGk17K5r+7yTKElnF1+qSrtmNlqP5gFnn9/nnYI2Nqir8xwT4Z17Y8Vu84Ejg1ASLgG121rnbF3QJYWoESLHJTjgMCb2tBEKjPC4aXJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756856554; c=relaxed/simple;
	bh=8sXiqOLioGui4X1iv9ziKfy6ZWL5ws9Y0icnyMm9Wew=;
	h=Date:To:From:Subject:Message-Id; b=IhCZRm87KMxPyCs2IVf5DNqgdcp0d0TGUdZMapIdSJoW36Nnxj72+12wumrxw9Sr6bhNXLntLMEIkVYkWjYju5xB79OZPCfGfemOFxOU0uLXgxSkf/gPMY7oqT30JwrDbYkEiNnLCCBp9v0hle0knOI3vfW9YzF1oBWq9O3MUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1klA8+Xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1klA8+Xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57953C4CEED;
	Tue,  2 Sep 2025 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756856554;
	bh=8sXiqOLioGui4X1iv9ziKfy6ZWL5ws9Y0icnyMm9Wew=;
	h=Date:To:From:Subject:From;
	b=1klA8+Xds5d/LzBvu9jdqkjZAcb7NTgz630kCu6LLPO+x/l4uPetXiw42ZDGf41Zf
	 fvEM8y9HZo65AVpoWpUro3LJqGv4N+1Pr3kVlQd2qaw3/eavcn5VFtPS/H7lzmwNMs
	 BmtTKEGhQS7MvQhm8At0Sw4YW4P3N4rr/9O7ZI1E=
Date: Tue, 02 Sep 2025 16:42:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch removed from -mm tree
Message-Id: <20250902234234.57953C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check content to see whether mremap corrupt data
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: selftests/mm: check content to see whether mremap corrupt data
Date: Sun, 31 Aug 2025 02:27:01 +0000

After mremap(), add a check on content to see whether mremap corrupt data.

Link: https://lkml.kernel.org/r/20250831022701.2595-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-content-to-see-whether-mremap-corrupt-data
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
 	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
+	for (i = 0; i < pagesize * 4; i++) {
+		if (pte_mapped[i] != (char)i)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+
 		if (i % pagesize == 0 &&
 		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
 			thp_size++;
+	}
 
 	if (thp_size != 4)
 		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch

