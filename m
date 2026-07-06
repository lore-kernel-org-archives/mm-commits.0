Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817F33EEAE2
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377152; cv=none; b=K9Cgyl4RN3fzZmA37wm+ePxVj8+bDbEFXeVEp/BNMf/pctUFv2laFG+foe4YFFrT/8yu4GPHm4NkezVpyj5zxO/BzOQDwsRbO0KIEomY8MHBsfP1MQVZg0Fq9V2qJTyyuu/BqdPFAU3Jkhy/Qnq5DXTdsw/XCiWO0rd+FgE6Ivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377152; c=relaxed/simple;
	bh=kZzWpVWffIxHVyX60YTC6yHgR7yqtUoLE0cLZdyujKI=;
	h=Date:To:From:Subject:Message-Id; b=fMnQYiCe1OrwqKiOsEPlEaJdVyLIOXtQC+BCsTO0nJOBnmmfHwPrAluj1caWwLEKnxtqWki0p3ny41EClzGWA4e7CE5O+S3aS/moI7jBUOopP/zDDegUa1XQODkGzAW4sDYxm0ScaDNLRMZPLv3WXNqJfpJ8fLbOWNBahBi39OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NSjsKBXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NSjsKBXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F441F000E9;
	Mon,  6 Jul 2026 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377151;
	bh=3u5AlJMQoNIo4IP/2+FGX3kv2aaKxM1MMup2XOQ6ieA=;
	h=Date:To:From:Subject;
	b=NSjsKBXy1Z/DFfbCeEYs0RUb+eG9SI5pykr4ImbE4Oi1/ppAZGPWh3THIgp9Aw83e
	 +yRIwGfOOyvz1HUmNxoh7Py4dDze6gk61dy7EIEMLYDi8d+k+8/O5GuF4hPKvCQMk5
	 YdrfGu3Oy/mJW309r5AclPJN6TwuPMha+xhEMkmc=
Date: Mon, 06 Jul 2026 15:32:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch added to mm-new branch
Message-Id: <20260706223231.28F441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
Date: Fri, 03 Jul 2026 09:47:48 -0400

page->private should not be set in tail pages.  Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed it
without a proper reason[1].  Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order
+++ a/mm/huge_memory.c
@@ -3591,6 +3591,13 @@ static void __split_folio_to_order(struc
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
+		/*
+		 * page->private should not be set in tail pages. Warn once
+		 * if private is unexpectedly set. Do it before swap.val assignment
+		 * since private overlaps with swap.val.
+		 */
+		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
+
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

