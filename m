Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2197E0E8
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779737694; cv=none; b=k/cLQ4uu2fyTHkwMzG70wsIxPa2/4ew+8j+m9+H9L5Jlm0R8nXyx56TLqCANFOAaT5v2DGH9IeRHqKZuVFEPU0obr2xoFm/XhQ3fY23P1VUfKYgRxsH90DVRsFDQDRWky8H0I28KXdPgTbQQtkXJKIuswyuYuls013RpTVKkyrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779737694; c=relaxed/simple;
	bh=nkmhQbYKlW1KT16mjAtFFeU/86lKZz70MGCFASvJ8SE=;
	h=Date:To:From:Subject:Message-Id; b=TGP0cGYKjdP0z2T0YH1+uecRPjILdZVs11y9uB+rB5HihtIgnQaxrgd0NUCuvPaz6tExCQDlr8FzM5NYLX98PnCEqkRtIZwUeo2S7PSmY/FyEyu0TybHr5qtaXzNeRyk6ZhezNUZNHCxq8LDzeUsfdLu56IDRX4BNlobED2U9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rylej4YS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rylej4YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870951F000E9;
	Mon, 25 May 2026 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779737692;
	bh=CipufnEoggsRFdw8arb5GHHGVnMUXADElPLci7T7KE0=;
	h=Date:To:From:Subject;
	b=rylej4YS6p9AehqSkeJ8UnOHT7YsIBWB52lUmCvHRAdWElHTxDg3kLIBhy/8PW/5x
	 /WXcZjG0Vk9jpp9ulYSowvWg09zTTx26Uqmk26od+uAcSh5nAcMtg+MwAV86I6tr4a
	 WyZkNDhdNTrfSVANbTEikon+hEfXjSAUvX8j6LbA=
Date: Mon, 25 May 2026 12:34:52 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch added to mm-unstable branch
Message-Id: <20260525193452.870951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
Date: Mon, 25 May 2026 16:17:47 +0530

pcpu_get_vm_areas() creates VM_ALLOC areas without setting nr_pages.
Add an nr_pages check to fall back to get_vm_area_size() for these
areas.

Link: https://lore.kernel.org/aff47da5-4fd5-481d-be18-e1eb99639490@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
+++ a/mm/vmalloc.c
@@ -4673,7 +4673,7 @@ long vread_iter(struct iov_iter *iter, c
 			 * the mapping without updating area->size. Other
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
-			size = (vm->flags & VM_ALLOC) ?
+			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
 				       (vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

