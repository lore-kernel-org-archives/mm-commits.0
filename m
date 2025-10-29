Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FFB37A3C7
	for <mm-commits@vger.kernel.org>; Wed, 29 Oct 2025 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761774907; cv=none; b=oD6A/Iw0gK/7gGGy1kDYxqD7yDFTMjgP4DnOeLYp7QZWK3TqLl4AcFBj4ZcLjFTOIE04McFPYmTc/qyH+lud6RpA8DGnt4BEeqHkBhiO00CNlbtzhLZjq6EdEr2h1Se5RZAXTDNJvqr8X87teSxshXYsm42T2mRe82A4XAq3kiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761774907; c=relaxed/simple;
	bh=v52rSCylpv+MnZnpb1RxlaNc2g5UrjVs60j7NDcaTh4=;
	h=Date:To:From:Subject:Message-Id; b=D8CTXfpSR0dfrxy/EZTCxGx4Lhoicc9hOVVSa6aVnwbXtNPduOt78Tlh/5l/Py5PN0A6u0lwqFdl+fKjTqHgGNnJ78dBb0HgWq+VnEwoX0D6JHgvHkkr3bpjVwyVFuKG4BSm6xJfLtBPSu6MyB1NKaA9Q/6U+5F4h9mROU9FBlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7uBR9lS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7uBR9lS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907A8C4CEFD;
	Wed, 29 Oct 2025 21:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761774905;
	bh=v52rSCylpv+MnZnpb1RxlaNc2g5UrjVs60j7NDcaTh4=;
	h=Date:To:From:Subject:From;
	b=S7uBR9lSf+M7jh/iTBJj/xvz1CB38VLYNiaxm0iTmGpP8N618TLiFD5SMU0DpKev8
	 CbMXChf/qxWfIsumwp+/72lNTJWC+iq92Y08Ixr/z3BQ5B91q7TivlEMwbtgv7Jryu
	 XA/SNo/ycQ49v398ke572jxxD2JkDyM8suv/ySkI=
Date: Wed, 29 Oct 2025 14:55:05 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,linux@israelbatista.dev.br,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-type-of-state-in-struct-memory_block-fix.patch added to mm-new branch
Message-Id: <20251029215505.907A8C4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-change-type-of-state-in-struct-memory_block-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-change-type-of-state-in-struct-memory_block-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-type-of-state-in-struct-memory_block-fix.patch

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
Subject: mm-change-type-of-state-in-struct-memory_block-fix
Date: Wed Oct 29 02:53:40 PM PDT 2025

fix whitespace, per Randy

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory.h~mm-change-type-of-state-in-struct-memory_block-fix
+++ a/include/linux/memory.h
@@ -78,7 +78,7 @@ enum memory_block_state {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	enum memory_block_state state; /* serialized by the dev->lock */
+	enum memory_block_state state;	/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

