Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039FF3290B0
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779214088; cv=none; b=KuB57iKi30pORRHnmNSughFBn0/tUtZBArAKwucOWNfpG3ja8AwcOn4mVLMpvxeiElkI6ewMq4xcYO3ajFnOEKPJkt/WZm+mZ10Fs3z8QyxwSK7t42Y+RoCH0aAnzfpCekrKku0+nDfOQU0BLL2O1L/oj1u2C6g6Dwaf2YDg6U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779214088; c=relaxed/simple;
	bh=Ys9d1746KCkF0UgW/aL7FssEMxzE6RswQRosj43P48o=;
	h=Date:To:From:Subject:Message-Id; b=Oew0rou8N/MxAEyWgH4f1GC97o9vJ+hSuJoSgLXvKlJIlJEb7Y15XN3NZWswzoJ8lDXNebg/JO/EsCgSUHgpSY9/LlRvXhWm4+SjEaKuhxpAP8T/KYBQaJDeiR16Zy6cLaiKvSWiXl71pJ38eeE8IRbEtKD+hVbhLsguGlV9Elo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ry3Yxdbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ry3Yxdbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869FEC2BCB3;
	Tue, 19 May 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214087;
	bh=Ys9d1746KCkF0UgW/aL7FssEMxzE6RswQRosj43P48o=;
	h=Date:To:From:Subject:From;
	b=Ry3YxdbxX9CRLRDVl5kqePkDDzSsf9XMPMOucmPI5LzaYCRE/7Ptvse4Wr1gWYWXp
	 jQp5oaBRpEJEp08ec92itZxLGIp2+HldZ2TL4bqlbYkNnCo0RE0YFyLkPciBFpzkUY
	 ehAP7Ta2EGJ9wkK7yJHeKjyCiHT6pBtj4RXGVoOI=
Date: Tue, 19 May 2026 11:08:07 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch added to mm-new branch
Message-Id: <20260519180807.869FEC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use physical page count for vrealloc() grow-in-place check
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch

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
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm/vmalloc: use physical page count for vrealloc() grow-in-place check
Date: Tue, 19 May 2026 17:42:15 +0530

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size.  After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages.  Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-2-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check
+++ a/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const v
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const v
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

