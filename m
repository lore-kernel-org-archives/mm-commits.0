Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B863FF1
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730432290; cv=none; b=N/LktHXEJFhipYbMXZejG5xK9qTbSE5ofs/8UJTavlmlZQkRck7A9Wv2sYQnNNt889AfpjJ0Eh1uQONpGyBx+ipUUaZqzPDAfwDfILx1nIAIyZPMyrhcFG+tMZhs/hNlwXBPbMxxTRBnLyT4FBsKAbiFX9vTSYevRBXgQqm1Oa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730432290; c=relaxed/simple;
	bh=yvARSMnRKpfjJpn8x2oBTaeMlp66BwkqbaxdAqGP9Xw=;
	h=Date:To:From:Subject:Message-Id; b=jusL3+opgEoBsJNSqjzCLcxK5dQzsS1KpyIZzo2Qu0DAkytwcHBWDCoz2Jw7Z9ooDVziEGGyA6sDjcaZ3mqIcistVHKCJEntdg7lRwmByDPvpQsLN/zWBuWSKw8xv8n/VdbCNG65x3sWuhRjVDziKqsxn2ANrTqCba5YpI/v6NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z30HjG0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z30HjG0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9102C4CECD;
	Fri,  1 Nov 2024 03:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730432289;
	bh=yvARSMnRKpfjJpn8x2oBTaeMlp66BwkqbaxdAqGP9Xw=;
	h=Date:To:From:Subject:From;
	b=z30HjG0UexgI0HJ29hjkXSU73vk+czaYtrGLtR85EJ4gT80+kztlO9pCrEoNq0mYO
	 l9DXB4+xGsmtESCBl/+w7eKgHKVBW6SOqNBjqWjsmiKi0dVfqh6m4cb0jMUwEFIR3V
	 ZJp63geBLDPnjIni3ZEJuffN1QY4PuQY2dhIho6U=
Date: Thu, 31 Oct 2024 20:38:09 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-test-checking-storing-null-fix.patch added to mm-unstable branch
Message-Id: <20241101033809.C9102C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-add-a-test-checking-storing-null-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-test-checking-storing-null-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-test-checking-storing-null-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-add-a-test-checking-storing-null-fix
Date: Thu Oct 31 08:37:00 PM PDT 2024

work around build error (mas_root)

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-add-a-test-checking-storing-null-fix
+++ a/lib/test_maple_tree.c
@@ -1453,7 +1453,7 @@ static noinline void __init check_store_
 	mas_set_range(&mas, 2, 5);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	MT_BUG_ON(mt, mtree_empty(mt));
-	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
+//	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
 	mas_unlock(&mas);
 	mtree_destroy(mt);
 
@@ -1465,7 +1465,7 @@ static noinline void __init check_store_
 	mas_lock(&mas);
 	mas_set_range(&mas, 1, 3);
 	mas_store_gfp(&mas, &mas, GFP_KERNEL);
-	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
+//	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
 	mas_set_range(&mas, 0, ULONG_MAX);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	MT_BUG_ON(mt, !mtree_empty(mt));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

