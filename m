Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811421;
	b=rqx2jXlZLcBQAymfceysu8T8vpFtyxThYmxWuVUdobvphqXy80ffdgtvDJDGlwo9wbYU
	 XT0Uq0oD5AVfcPJqSfGtJ8+GXlglDFoYcWf8RV1eUeIhH1KZ37YwiP3jx1inRqif1/xrO
	 KSlwUlHurRQzJW7kZqS9oAGgL1LewqUyO5eJYjQaqCQiZ9iGrYdjGTD+fzXNA/o+g3UGH
	 4CIzruSmyjz71Kj34MlByijwlCiCqr/fUWYowdRc1UFPW9z8sArp8bIx4iDR0DS+QRqlF
	 31BPazlnO7fx7W+E1t9Cdr3IgL19DxWBv43cKT01vZ1BIOg6e4m4/hRQHRK41tqvVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811421;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Q0SU5qa8XjkjTtbCwcsvIub6I6ugYQ/ytk/yzSfRIXo=;
	b=WIiel+2r9Ab/5DmMsAEQjvN1ti59Vi94ct8+tjUd6RAEeUMlqD66YZZj+nDS5+wSoM/g
	 nT0mmgv09wfh3P5s6CnhVfRzrmknlymf7F6iCIH8nLgGiWCkIKnU/4SbvYHwt3zXQTz2F
	 /o3nroq1sAODOlrpBdRtJ+zGO/ugx+BWno3jV7grfDNMUUO34syMrA1xU6NmJ7q4FhYgM
	 PvNHkUptwkIokTBMRCaGYeKMPL5YOKmhBkQigudCdeywxkJQnOS0sa6ul6aBsGWTwl1Al
	 jwdUT46K+ti8mw8ZMpEaQFf4Nre3V7MgPaG4fvwS2tTHsCWPk5badOldEN5ce3q8rAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1hxo+iut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63C606A335;
	Wed,  4 Nov 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1hxo+iut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9151F000C1;
	Wed,  4 Nov 2026 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793811421;
	bh=Q0SU5qa8XjkjTtbCwcsvIub6I6ugYQ/ytk/yzSfRIXo=;
	h=Date:To:From:Subject;
	b=1hxo+iutKJ312bOBznBd0g2+iEzycMpnoJjuN/Zv8aO4BWfDNo2wRQR6B4R4UEADk
	 2jl4FGtgRpGT34owuCvj1EysXw33u8qTEa6adsoxzp13fb3+DlcGONsBjswTd0YI+n
	 xCPJwS2EFjLc0PiL/KozpS5bm2HoeWeBZApfs9bQ=
Date: Wed, 04 Nov 2026 08:57:00 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,umangpokhriyall@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-validate-the-whole-range-before-changing-write-protection.patch added to mm-hotfixes-unstable branch
Message-Id: <20261104165701.0B9151F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: userfaultfd: validate the whole range before changing write protection
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-validate-the-whole-range-before-changing-write-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-validate-the-whole-range-before-changing-write-protection.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
Subject: userfaultfd: validate the whole range before changing write protection
Date: Wed, 04 Nov 2026 15:04:57 +0530

mwriteprotect_range() checks each VMA as it walks the range.  When a later
VMA is not registered for write protection, or is a hugetlb VMA the range
is not aligned to, the call fails after the earlier VMAs were already
changed.  When unprotecting, userfaultfd_writeprotect() then skips
wake_userfault(), so threads blocked on those pages are not woken although
the pages are writable again.

An unprivileged process can trigger this with a range that spans an
unregistered VMA.  It hasn't been seen in practice; it was found while
reviewing the userfaultfd range ioctls with an LLM.

Validate the whole range first, as mrwprotect_range() already does.

Link: https://lore.kernel.org/20261104093457.152245-1-umangpokhriyall@gmail.com
Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-validate-the-whole-range-before-changing-write-protection
+++ a/mm/userfaultfd.c
@@ -1105,21 +1105,26 @@ static int mwriteprotect_range(struct us
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
+	/*
+	 * Validate every spanned VMA before changing any of them, so an
+	 * invalid range is rejected without changing part of it.
+	 */
 	err = -ENOENT;
 	for_each_vma_range(vmi, dst_vma, end) {
-
-		if (!userfaultfd_wp(dst_vma)) {
-			err = -ENOENT;
-			break;
-		}
+		if (!userfaultfd_wp(dst_vma))
+			goto out_unlock;
 
 		if (vma_is_hugetlb(dst_vma)) {
-			err = -EINVAL;
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
-			if ((start & page_mask) || (len & page_mask))
-				break;
+			if ((start & page_mask) || (len & page_mask)) {
+				err = -EINVAL;
+				goto out_unlock;
+			}
 		}
+	}
 
+	vma_iter_set(&vmi, start);
+	for_each_vma_range(vmi, dst_vma, end) {
 		_start = max(dst_vma->vm_start, start);
 		_end = min(dst_vma->vm_end, end);
 
_

Patches currently in -mm which might be from umangpokhriyall@gmail.com are

userfaultfd-validate-the-whole-range-before-changing-write-protection.patch

