Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977182AD2C
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 09:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746350771; cv=none; b=uaTkcYRpYLQJ34KqvFq86eZWUosA8JyyfhJi4jzlpjNPxsyM0IA+M6QnNbajRPDRQ2Ko9jP8QJcGMT2Jub7Lz7AJMON5CTiDDK8+BaZKnu2ozrnwoLhdOqqZ6nWAco08Tw8WlJdXxI4coCz8B0LrCaZsyd7eOaWGEo5DyhgbnPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746350771; c=relaxed/simple;
	bh=ZEqpfZqQW1dgEMkmCiriatXI9cJJTE64Cjoar6A4eQY=;
	h=Date:To:From:Subject:Message-Id; b=lcKgiSVBJEFy4o4t7BhUHbXOR3uHky+AXoiqytL2qmVUg5J0lsm02gqzYzOyhmDUz84I0+xT7jV/rFbSOh/MQaCPj5UEqCeq3pcM0rZuHE6I9JA5KAh4vGFaoU/mbcWOgwycovWZIQeehvcaJLbDBXrOuE6nM6pvOAI+c0KbE4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sQdp1EgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sQdp1EgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32C8C4CEE9;
	Sun,  4 May 2025 09:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746350771;
	bh=ZEqpfZqQW1dgEMkmCiriatXI9cJJTE64Cjoar6A4eQY=;
	h=Date:To:From:Subject:From;
	b=sQdp1EgNNI3bUschtBEMdYA3R11qOwD9yRdB7wfkL6OU3iVBLSuIWrX7ToQM5d4jA
	 sGiZLtWB7SdGAJs06x4/RZ5oUpIK6SU1Xhasj7YcRcRCMSYGU76cnVApacnLMl2KEy
	 rySc09c5LNR0iPoWkgSB10pq3d3i23Kja7+Ruvp0=
Date: Sun, 04 May 2025 02:26:10 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zblock-allocator-fix-2.patch added to mm-new branch
Message-Id: <20250504092610.F32C8C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-zblock-allocator-fix-2
has been added to the -mm mm-new branch.  Its filename is
     mm-add-zblock-allocator-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-zblock-allocator-fix-2.patch

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
Subject: mm-add-zblock-allocator-fix-2
Date: Sun May  4 02:13:54 AM PDT 2025

export try_alloc_pages_noprof() to modules for CONFIG_ZBLOCK=m

Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-add-zblock-allocator-fix-2
+++ a/mm/page_alloc.c
@@ -7470,3 +7470,4 @@ struct page *try_alloc_pages_noprof(int
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
+EXPORT_SYMBOL_GPL(try_alloc_pages_noprof);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

