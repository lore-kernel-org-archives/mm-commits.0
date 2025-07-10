Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391362905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126196; cv=none; b=OoO+5WUpnu+gFgI5aPjRKxdeY46LiOH0m8+qxZPTOjH5vVGqHlmV5OrQzRefcPihRl59gX7DFxgu9tafHdkRq0kfWqLjCJXX2oj4xixdz6GcMJeO4pHUvRgJvCgAyYnOXnZSpYD+VFcdbPOjJhqSESxejKATBmW8ZKKv/wEoZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126196; c=relaxed/simple;
	bh=hge5DrDwbU7GAt7et5r0CdCJJrMCmXZl8D5W1fyedsA=;
	h=Date:To:From:Subject:Message-Id; b=TK3igLl2ZKcG4NHHgJkrmEGbiikdw9ebdaNvslYC1Xqal6dlzBJ8phe+HEdvk2CX6e4KHc9bGRT2HUkpgE54NnIn2cCm7Tjd0XXo+xYaaZgsanDwGj+bAFN0ISgLyrmHlVshA0/4rY1BTCPsghjKh6WP3qZ2zsrl0hPIQHdAIaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opg7mtP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opg7mtP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F39C4CEE3;
	Thu, 10 Jul 2025 05:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126196;
	bh=hge5DrDwbU7GAt7et5r0CdCJJrMCmXZl8D5W1fyedsA=;
	h=Date:To:From:Subject:From;
	b=opg7mtP9VvDkmKLBu42/X6RU2RiYzrY5hMKGiSTQ0p6rBnLgvVrhJjxGI2D19wg56
	 ZkqJxK1FRCex4FnWWJZoY7spwXiwxwjYh5dHGJTDDvcsBb43zpZBMl8eEmUE9wXWQj
	 oAIQT4B7Uj3vmL7iqEIY1PV30Svz5KRMvW0c2naQ=
Date: Wed, 09 Jul 2025 22:43:15 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch removed from -mm tree
Message-Id: <20250710054316.04F39C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ksm: refer to special VMAs via VM_SPECIAL in ksm_compatible()
has been removed from the -mm tree.  Its filename was
     mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: ksm: refer to special VMAs via VM_SPECIAL in ksm_compatible()
Date: Thu, 29 May 2025 18:15:46 +0100

There's no need to spell out all the special cases, also doing it this way
makes it absolutely clear that we preclude unmergeable VMAs in general,
and puts the other excluded flags in stark and clear contrast.

Link: https://lkml.kernel.org/r/c8be5b055163b164c8824020164076ee3b9389bd.1748537921.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible
+++ a/mm/ksm.c
@@ -679,9 +679,8 @@ static int break_ksm(struct vm_area_stru
 
 static bool ksm_compatible(const struct file *file, vm_flags_t vm_flags)
 {
-	if (vm_flags & (VM_SHARED   | VM_MAYSHARE   | VM_PFNMAP  |
-			VM_IO       | VM_DONTEXPAND | VM_HUGETLB |
-			VM_MIXEDMAP | VM_DROPPABLE))
+	if (vm_flags & (VM_SHARED  | VM_MAYSHARE | VM_SPECIAL |
+			VM_HUGETLB | VM_DROPPABLE))
 		return false;		/* just ignore the advice */
 
 	if (file_is_dax(file))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

