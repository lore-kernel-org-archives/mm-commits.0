Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC392288D5
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758233004; cv=none; b=NDtqLuEnXXw0jQ6zjPaOC7Hi9sjY1ozSQYX2QQe3dxOW6orFmrcZWxKBZkqX8+DCYoMRn87xhWFfcNZMnEGCF+Ys5dlFafQrLRpV9QNNqL68rDPIII2YHYl9UyVZBA+lDTZA/zBpSOqM3Nx3yaDf/Z5yjn1XYETAfeXE6hb52fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758233004; c=relaxed/simple;
	bh=397fNHgAVqE1n4Qr6N5c7LWpyrhzl+hAtPRKzEhXXbY=;
	h=Date:To:From:Subject:Message-Id; b=Wb1beSVu3d337Fyl1qhTB2CzY6N4uxf9LQnTs1fjpfnrNRJjPlKPS/HmfLWfW2eIlg40qOjHbb8WUOy+vRLPRzbDR94DjDTdqWRAL8jJ9tR9kVEgjrZBIXICoh/NCew7tFor/usQM29WdynDO4jpqazUwIEayHvPTB+LQQ4u2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eMsp0Fxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eMsp0Fxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867F9C4CEE7;
	Thu, 18 Sep 2025 22:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758233003;
	bh=397fNHgAVqE1n4Qr6N5c7LWpyrhzl+hAtPRKzEhXXbY=;
	h=Date:To:From:Subject:From;
	b=eMsp0FxgUTXqUprOY3VROz8C/tvneir95MjtBvFQW/SrHqS2q0gM342Z7CMQLP7xA
	 FUpezz8EN+Ek807BuPtrtoHcOnn48uoqrxOQZcpOtVBNOAmaz1yXIHLXZKhUVYVW8u
	 JGWJODAEyjiX9wXTL52bLrr0xU9hKyGSKgd8XeWU=
Date: Thu, 18 Sep 2025 15:03:22 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch added to mm-new branch
Message-Id: <20250918220323.867F9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

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
Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix
Date: Thu Sep 18 03:01:31 PM PDT 2025

redo comment, per David

Link: https://lkml.kernel.org/r/17d1b293-e393-4989-a357-7eea74b3c805@redhat.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-folio_test_private-check-in-pageout-fix
+++ a/mm/vmscan.c
@@ -701,8 +701,8 @@ static pageout_t pageout(struct folio *f
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
-		 * Is it still possible to have a dirty folio with
-		 * a NULL mapping? I think not.
+		 * We should no longer have dirty folios with clean buffers and
+		 * a NULL mapping. However, let's be careful for now.
 		 */
 		VM_WARN_ON_FOLIO(true, folio);
 		return PAGE_KEEP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

