Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2FA2C2AD0
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047094; cv=none; b=FhO1JZnJj5nEJxHwi1Ar2imwuQhxpffb5AVYY7vf5K17wrf1UdrDHlq6CfAHZk4v17/eAt0VH9RyIcN40WwUquvtkbgtJxJa33QJgBYrvStnZQy3m4Kbl2AJ3cVuaEo6rL7gDc3Pje7fOWdi/JUf2NxLzHc1RYODTV9pvGFJh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047094; c=relaxed/simple;
	bh=LZnVnSho8mJ1/LPRSCatiKirJp9H68k3ea0FkHyG+Y0=;
	h=Date:To:From:Subject:Message-Id; b=KD6Iv8AhjO0Kxze5lH5ZueVvtON8ZX7bUeGOjl4PyywTqnAWqzYZ8LN2aUHeDQ1E+LwnVtWeHkf1M9djdybjgBNvapvOmmoM0V9voGkA0CtN8z1yxaS+UM/AB/QCramQpoX2nvKIFI2VaaCoFvg91ahAP3MHS0xofxCN2TnmNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CLyfiMWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CLyfiMWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E159C4CEE7;
	Wed, 30 Apr 2025 21:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047092;
	bh=LZnVnSho8mJ1/LPRSCatiKirJp9H68k3ea0FkHyG+Y0=;
	h=Date:To:From:Subject:From;
	b=CLyfiMWV6fbEt04VDzk47JhKTM3X/QjZrpJ3lBs3t+lMVRHRzMQZuJt6/pFQejrnF
	 tI61ncfu/MTZV+JrpOihZhiIG/FVbo9WB22o/iuOJjMY0/O2ejwS4cvUAac/k33rAh
	 v2HHPJBuqTHN1sOwoj7bC7MlKQaWAYsaVzNniGSQ=
Date: Wed, 30 Apr 2025 14:04:51 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,kasong@tencent.com,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch added to mm-new branch
Message-Id: <20250430210452.5E159C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
has been added to the -mm mm-new branch.  Its filename is
     filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
Date: Wed Apr 30 02:03:35 PM PDT 2025

s/VM_WARN_ON_FOLIO/VM_WARN_ON_ONCE_FOLIO/, per Kairui

Cc: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
+++ a/include/linux/pagemap.h
@@ -941,7 +941,7 @@ static inline struct page *folio_file_pa
  */
 static inline bool folio_contains(struct folio *folio, pgoff_t index)
 {
-	VM_WARN_ON_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

