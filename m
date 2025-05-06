Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B666356E78
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746494177; cv=none; b=XL2opljtAFlHyJlia1w0DGfzFsvMD7Sfuq53ffIzdDTjhrDJLOFzJSWjfKmQepPIk8RY3FS/vTVOGGorKVE8M0COAC+xLT9Gy0TURE2kOFTLcyI+kfbd35WIYCWeGc0zwTLlBz4gZ7ec3bglmuZAUOOSMAXpxEM9mXaDb6pIfIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746494177; c=relaxed/simple;
	bh=daVWrogjcK/sY2WqpNGGksyTToepjtLZ5m510kkA/X8=;
	h=Date:To:From:Subject:Message-Id; b=BQSw0EaViiu84A8QUwnN0hDfQuYj5bu4rU2Qowz1jm2m0U81Wlx8KLIY/+TilnZA333og4J6WAtYsbYciXb+6zys6AiFIX4/5rbQhEWHJE7dokbn1NexOCEDKVvo8QUTs1edOE1AAzhUidvEqrhI3q5cO4qL760K+5OoDnz/YEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gSYuLrIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gSYuLrIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FBDC4CEE4;
	Tue,  6 May 2025 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746494175;
	bh=daVWrogjcK/sY2WqpNGGksyTToepjtLZ5m510kkA/X8=;
	h=Date:To:From:Subject:From;
	b=gSYuLrIScEiPWEAMKBBjMiV2dcEAgBzGi8IdqMUx0hWjBfvBivKjZ3SMHPOJIiwZT
	 ZI/pNRDgkqUFJN8jvzi6HZ+twhUiCM39oQ5dLO34zI9+Jmnht8UddzI6Ggd92e9W1l
	 3aOECtfcnHnfMRn46yuv+9KXtTczwGUIEO9N5yUw=
Date: Mon, 05 May 2025 18:16:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,minchan@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jyescas@google.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-config_page_block_order-to-select-page-block-order-fix.patch added to mm-new branch
Message-Id: <20250506011615.81FBDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-config_page_block_order-to-select-page-block-order-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-config_page_block_order-to-select-page-block-order-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-config_page_block_order-to-select-page-block-order-fix.patch

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
Subject: mm-add-config_page_block_order-to-select-page-block-order-fix
Date: Mon May  5 06:12:33 PM PDT 2025

tweak Kconfig text

Cc: David Hildenbrand <david@redhat.com>
Cc: Juan Yescas <jyescas@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/Kconfig~mm-add-config_page_block_order-to-select-page-block-order-fix
+++ a/mm/Kconfig
@@ -1028,10 +1028,10 @@ config PAGE_BLOCK_ORDER
 	  ARCH_FORCE_MAX_ORDER.
 
 	  This option allows overriding the default setting when the page
-	  block order requires to be smaller than ARCH_FORCE_MAX_ORDER.
+	  block order is required to be smaller than ARCH_FORCE_MAX_ORDER.
 
 	  Reducing pageblock order can negatively impact THP generation
-	  successful rate. If your workloads uses THP heavily, please use this
+	  success rate. If your workloads uses THP heavily, please use this
 	  option with caution.
 
 	  Don't change if unsure.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-config_page_block_order-to-select-page-block-order-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

