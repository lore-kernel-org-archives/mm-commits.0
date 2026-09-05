Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585AE3644A0
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788650177; cv=none; b=Dou4UlP7ujo5qRHwa4/w+S9QaSzhlrf0QwBNgm+LWem+MlDPd/5nLNiP7x7PrEArsGFg7vZilMlL/wpW5FmRsUMf0OFOC8VnAVAsPMZG1zl3EVCXILTFPeYnbupFd++WvsVhBOKyMcN4j5l7pbOQBiZuB56dhACOrqIOLYrOMsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788650177; c=relaxed/simple;
	bh=ElVrZ73HL/vpPr/BKDDi5hP7lvzdeevudifdwo5ZLd4=;
	h=Date:To:From:Subject:Message-Id; b=XJ+y8Z2lWLyGW/WqGAtQ3uYbjfwtX43sl3XhmKcUR+beYfbP/1mEObYcMs1zpG+9ANq2jQpvZzd1l+UTdQu0gOJxhsF/01MeKDWi+6wns44FBBdQngHYGcc4M1KnSS3inNK59XvU7K2G8MqkLmsVC+HzURBUwMAvGAUznqCoEVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FF8RhYth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FF8RhYth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE7F1F00A3A;
	Sat,  5 Sep 2026 23:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788650175;
	bh=UPuyX1/ZioGjeEq+0NY03B5rhGqdNkLxm2V1QZW13xk=;
	h=Date:To:From:Subject;
	b=FF8RhYthbrv9hOZNXmZbTfHZT8LFw42bcPXk84hhqXLaardQQyPj9Qhg2aweXYAM+
	 i3ApDLzyxC1hN/BD3qzod0pSw/wn+oNnn/mAqizMV+FPsiCCq+0f2IVLIAdvuHG0xb
	 mydkQk4fZ0ATcI1ziOuKN/uHv0NHVsFE8v25Ixt4=
Date: Sat, 05 Sep 2026 16:16:15 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-ksm-use-the-renamed-ksm-structure-names.patch added to mm-new branch
Message-Id: <20260905231615.AAE7F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: ksm: use the renamed ksm structure names
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-ksm-use-the-renamed-ksm-structure-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-ksm-use-the-renamed-ksm-structure-names.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: docs/mm: ksm: use the renamed ksm structure names
Date: Sat, 5 Sep 2026 10:40:34 +0200

The Reference section of ksm.rst asks mm/ksm.c for mm_slot, stable_node
and rmap_item.  Commit 21fbd59136e0 ("ksm: add the ksm prefix to the names
of the ksm private structures") renamed them to ksm_mm_slot,
ksm_stable_node and ksm_rmap_item.  Since then only ksm_scan is rendered
and the three structures are missing from the generated documentation.

Use the current names.

Link: https://lore.kernel.org/20260905084034.39521-1-kmehltretter@gmail.com
Fixes: 21fbd59136e0 ("ksm: add the ksm prefix to the names of the ksm private structures")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/ksm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/ksm.rst~docs-mm-ksm-use-the-renamed-ksm-structure-names
+++ a/Documentation/mm/ksm.rst
@@ -78,7 +78,7 @@ The frequency of such scans is defined b
 Reference
 ---------
 .. kernel-doc:: mm/ksm.c
-   :functions: mm_slot ksm_scan stable_node rmap_item
+   :functions: ksm_mm_slot ksm_scan ksm_stable_node ksm_rmap_item
 
 --
 Izik Eidus,
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch

