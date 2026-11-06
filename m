Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928457;
	b=v9NTROKzk7tFA/SAsVj+w5L42NlGjzfc/f30BbYrv772seMB6IdJhelk3i0Ie7798NdN
	 BsbH3hBXip1mpNcNUe6pg/zGW1+W23l2HKdy92uEh9Qe99vjG2ZWGZ16tEp1WXOGlQmQO
	 CImNAtp1IqOJfrOxb9r/WLYVc7rgBKqCI8aUNTQb8XNP9RT78TBkxXyMnnm05nEYczVGM
	 vx1345kcCvinTBhtvXMMWPuRUWOvalq1egRyIVLRguEUqrOwTyTQRO0bmrC9v0D5UAnw8
	 quF3+DOV5ZW+t/dzzZA7TVYyX9GbOtkguO5rg6ZXxfRemDh3WeLlaJXeXDnUd7ju4wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928457;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NhzRNFDbCOA4+kmQAUgLXbVo0/8mWHpYBS8QMwFE/EI=;
	b=G7fIt3fvw2fXMOcHqeTT7N4Oe8q0O4i6P0dk7PWV5POUYaoQ1IJEv35ytS9t0x6Wc87q
	 841YuWsxAnrBgrYlZfJSmNTkE3HvmCR5g4FfEqQviQiVCKzP1qQ7/RmbyhTEAhL/nY9RH
	 UrSngTpdKMLzGz8gEX4toXaMj2d6gIYN3hGQgBrys1sfyGQKIDxTOhaCHhLX8v3O01ErE
	 14h8NVVNjI5Or0ccBMlewdv7UXlFK72sTAtN97eJZpMMgVaX3+9/N3gN/Ej1mrqNGGO4H
	 eD1Y+awJmh7mhFwRWnK5LW/7SvrvzxzxnlB4rEgW35W114vYesJ8VJoSdlA7HOxwoXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yg3uOdUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5386E606A32F
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yg3uOdUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6841F0089F;
	Fri,  6 Nov 2026 01:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928456;
	bh=NhzRNFDbCOA4+kmQAUgLXbVo0/8mWHpYBS8QMwFE/EI=;
	h=Date:To:From:Subject;
	b=Yg3uOdUekRj9kvetp0KztMUgkBrr7l2BQYGDSqJBLY6oYGHeuhvDJwQORcOEPf+Cd
	 zpDeF6bE7O5Gou8dGLJishynDVTbXB5JhTAfJZBD6dUsv4ESayxGlSmGXkj+acfWbp
	 dCJLt+1tfkyI5c0KRFZFDX+9eC3QyPlDxQVoAOkg=
Date: Thu, 05 Nov 2026 17:27:36 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sarthak.sharma@arm.com,
	pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,
	liam@infradead.org,jannh@google.com,david@kernel.org,azpijr@gmail.com,
	josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch added to mm-new branch
Message-Id: <20261106012736.BF6841F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: reaccount on unmap failure only if accounted
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/mremap: reaccount on unmap failure only if accounted
Date: Thu, 05 Nov 2026 14:02:05 +0000

When the unmap of the source range fails at the end of an mremap() move,
the length of the range is charged to vm_committed_as even if the VMA was
never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. 
Nothing ever uncharges these pages, so each such failure permanently
inflates the committed memory count.

This was reproduced with fault injection: each failure on a shmem mapping
left Committed_AS higher by the size of the moved range after everything
was unmapped.

Fix by charging the range again only when accountable_move is set.

Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-3-f8789de76849@toxicpanda.com
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-reaccount-on-unmap-failure-only-if-accounted
+++ a/mm/mremap.c
@@ -1246,7 +1246,8 @@ static void unmap_source_vma(struct vma_
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		vm_acct_memory(len >> PAGE_SHIFT);
+		if (accountable_move)
+			vm_acct_memory(len >> PAGE_SHIFT);
 		return;
 	}
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch
selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch
mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch
mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch
selftests-mm-test-mremap-with-an-old-size-of-0.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

