Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832534;
	b=eGmDDK5T0OjCrfWPTg3fXVCZtEvHYiVlHvM3g6BNKorVo6Tc95Jk9wQ0KhmWqpvZznHU
	 c18E6vP3Njhgy/EUaVztTv3tIIEVRI+QkKZhfgoihyv60x0K45ly3ck+k7e8sxUR5eugL
	 LvqDJdSs2y+d3rcuZjFLOTOSlyGe2DRq7cO5pC+pA0gwn3+7XFaPBbHnICRw8qtOV15Hy
	 O8N2Q8m7ak4ajS7950RT1U3mFfEkJcnc1kMNR80c6hfZw6O7nXsC8wqLdihcDK+eeUd8C
	 qKIUC1GPjsHCyXjio1CExDyreKEmPvlPuGsHUE20p3lpYx2NGvo/lrEoCm6r1lccrWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832534;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JQ9apkM488aWZ7OkJDRzzYXo46s6ZLCL7Z2hMXJ30iw=;
	b=SZXAusxnRF7MVsmOkV8rpxlQBGp4AFZPB5yLvvFfYczhw5HeWESm9/00HwdBFj5pjt9i
	 AgCc2dRHf+4bosz9LrZIx+MrGqApyvwUYpHkZhHig8UTbsgDzqp9mm9LI4GodtrztvU4w
	 T2TGctqBM+PO0BcVsCP5slxWbU9tJxboSt8CsO0omnwugIFGv8n6bcVW4A4iaOYlvlrls
	 cj4q75B76nUmcnO1Lb1Ki9XN3vp+GRNkILHlAxp/fQ+GomMzQ4KtymyKwtGmtoM3O87Va
	 krjnJNoWlkTJWhMcah6bYnpTCnjgN85jzkD16z6HmgrO9dng0BQTrhnib1EaXifAQ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=coVnMWQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE49606A31F;
	Sat, 24 Oct 2026 09:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=coVnMWQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A5B1F01825;
	Sat, 24 Oct 2026 09:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832533;
	bh=JQ9apkM488aWZ7OkJDRzzYXo46s6ZLCL7Z2hMXJ30iw=;
	h=Date:To:From:Subject;
	b=coVnMWQFSuAjuwC1rbhCUCZ2hE/3EM0lIECqHF23KT3WcbEDYRtuQt38eomoyn4OU
	 35sQQoJ7rp05nHg96rsJC+bgCn7RWkulHwjWFR55AGjozgeL0a3FWDJjha2pnR/l1d
	 HUQfQVsslvi21j48m9mQENSGmelBZyg1TeqKDAaA=
Date: Sat, 24 Oct 2026 02:02:13 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,nickolai@csail.mit.edu,liam@infradead.org,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch removed from -mm tree
Message-Id: <20261024090213.97A5B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mremap: populate calculated fields in vrm state correctly
has been removed from the -mm tree.  Its filename was
     mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: populate calculated fields in vrm state correctly
Date: Mon, 19 Oct 2026 15:28:27 +0100

Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
introduced the vma_remap_struct helper to pass state sanely through
mremap() logic.

Part of this state is vrm->delta - equal to the absolute difference between
vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
respectively).

This value is used to correctly charge accounted VMAs.

When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
having performed the shrink of the VMA first, prior to any potential move
(e.g.  MREMAP_FIXED | MREMAP_MAYMOVE specified).

However it does not recalculate vrm->delta, which results in incorrectly
overcharging the VMA when both moving and shrinking a VMA.

The charge leaks to Committed_AS globally, meaning a mischievous user can
cause allocations to fail across the system in strict overcommit mode.

Resolve the issue by abstracting the update of vrm->delta to
vrm_populate_calculated() and invoking this from mremap_to() when
vrm->old_len is changed.

Additionally, update vrm->remap_type whose value depends on vrm->delta. 
The field is not read again after the shrink, but it is the logically
correct thing to do and protects against future changes which break this.

Link: https://lore.kernel.org/20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org
Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-populate-calculated-fields-in-vrm-state-correctly
+++ a/mm/mremap.c
@@ -887,12 +887,6 @@ again:
 	return pmc_progress(pmc);
 }
 
-/* Set vrm->delta to the difference in VMA size specified by user. */
-static void vrm_set_delta(struct vma_remap_struct *vrm)
-{
-	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
-}
-
 /* Determine what kind of remap this is - shrink, expand or no resize at all. */
 static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 {
@@ -905,6 +899,13 @@ static enum mremap_type vrm_remap_type(s
 	return MREMAP_EXPAND;
 }
 
+/* Populate calculated fields. */
+static void vrm_populate_calculated(struct vma_remap_struct *vrm)
+{
+	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
+	vrm->remap_type = vrm_remap_type(vrm);
+}
+
 /*
  * When moving a VMA to vrm->new_adr, does this result in the new and old VMAs
  * overlapping?
@@ -1523,6 +1524,7 @@ static unsigned long mremap_to(struct vm
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_populate_calculated(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
@@ -1795,8 +1797,7 @@ static int check_prep_vma(struct vma_rem
 	if (vma_is_hugetlb(vma) && !align_hugetlb(vrm))
 		return -EINVAL;
 
-	vrm_set_delta(vrm);
-	vrm->remap_type = vrm_remap_type(vrm);
+	vrm_populate_calculated(vrm);
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = addr;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

