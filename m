Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7C7388E55
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772576432; cv=none; b=SFr5rg35uo1ijnrUiYuR6qwveGV7jUtLbnHkL0sQeLAMvBVW6i7zLfwimxeD423yI3sZfC1eOASUDTCP7qCoOHZ9O1Y9sGaIw3c6T09oPOV3A9WZKw4H7GGNUf236KddgSCeaKF/YvNuZ9kCNp+g+b4ozKJmTtccUQKaNHza+Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772576432; c=relaxed/simple;
	bh=eOCfR3XPSIDbdbGKx882417bJtbqPYT3WIgr3A35Tes=;
	h=Date:To:From:Subject:Message-Id; b=SNT6bF/UkvyTkTJm+AUzgr1l/Wun5m5qLj/vYlAKlcvW2zFG1lwggekDwNo2GlyNxLwwgM82xlSWSJeHEQmXp5jcsYS0kL45rawsc0+IodlsyzSAVGcfUHCKjTR7M6LPTk6rqUIE3lxOTxtw07fvOPU5YgA6q8a5IJUsHxrAfqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Se/m8qAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Se/m8qAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05590C116C6;
	Tue,  3 Mar 2026 22:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772576432;
	bh=eOCfR3XPSIDbdbGKx882417bJtbqPYT3WIgr3A35Tes=;
	h=Date:To:From:Subject:From;
	b=Se/m8qAQEiktjbm5y+/28a9p2X9lYA6WASpaX05J5+UzKh5TNQlM9AplBy92XIDSY
	 9p5lsRKwvQbn2oOkYp98nNnbTmT93WPQiQMyGd5jbJOBPQUCW87iKS6gdzvcTzOFXj
	 ddGdEbcQB5OkWFdlIUtwLxnw3L/YrTtgIjFd1u98=
Date: Tue, 03 Mar 2026 14:20:31 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-docs-slub-is-the-only-remaining-slab-implementation.patch added to mm-new branch
Message-Id: <20260303222032.05590C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: docs: SLUB is the only remaining slab implementation
has been added to the -mm mm-new branch.  Its filename is
     kasan-docs-slub-is-the-only-remaining-slab-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-docs-slub-is-the-only-remaining-slab-implementation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: kasan: docs: SLUB is the only remaining slab implementation
Date: Tue, 3 Mar 2026 13:04:16 +0100

We have only the SLUB implementation left in the kernel (referred to as
"slab").  Therefore, there is nothing special regarding KASAN modes when
it comes to the slab allocator anymore.

Drop the stale comment regarding differing SLUB vs. SLAB support.

Link: https://lkml.kernel.org/r/20260303120416.62580-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 ---
 1 file changed, 3 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-slub-is-the-only-remaining-slab-implementation
+++ a/Documentation/dev-tools/kasan.rst
@@ -75,9 +75,6 @@ Software Tag-Based KASAN supports slab,
 Hardware Tag-Based KASAN supports slab, page_alloc, and non-executable vmalloc
 memory.
 
-For slab, both software KASAN modes support SLUB and SLAB allocators, while
-Hardware Tag-Based KASAN only supports SLUB.
-
 Usage
 -----
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
kasan-docs-slub-is-the-only-remaining-slab-implementation.patch

