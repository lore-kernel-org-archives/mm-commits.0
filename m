Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928459;
	b=gbcj3V5KZg2sB6Tv+HtTq7H/l6PsKzj92iXF9yPDhm1sNf2SaLjCTHwWnS0ezAEjgXyP
	 QKB75cMp8ddvvZS0kW4wjzjp4oVlr1J0GYPQh5A0UtwnctNeDqSctpnI8eNYHPP3nY6YR
	 FdjZoBlNA1CY2tL4iFSNifeoxB9CZ80ZfbX+zcbP7pHydVRWYB0itbazn7iKl2HCjS0Hc
	 A6Y21fSmvpYxQyyEkWZHp25KTu9Xw/BqIsOFNtHzRwFPqseZHYl45loH9q2+sNe5exGVv
	 yKx4V7FjDPZyYnwa5oM82iyobvfMwodCcxFNDkGXJgL104s3eAou142m1zLQQY2QAvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928459;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GvCM/cAPLsQkcBRyhPjZzPtPRHyc2SAMBACEwjJMOI0=;
	b=Jg5CS1lqYYORLko4offZePcFpeXWjKhUkZOay/nachQQst2PZR3cjJ/299uZdQf4jvhQ
	 vX5HpedFtcWwPDHfVlpUKkcjbgOknd3jFBFFF1WOTY8XKzE4CW7YOgdH1fjcCxMxfIKod
	 X0yoNj60eWbW6PjLJZ0fLjgh2VcVGX38s9zKavpOWPCxoffSt2lGak/Tba+Mk1/qCKH2a
	 CF/MitB48AvFcnBt8fcs3rAoFRWKPDFTFiWCAZAxp0YpTYr3+vqiHoTlViLisddF7hqMy
	 US4F5GgTGzHyfh4xf35CBhA7fjXV10FpMeFsiPcfMCVf17L2LH07DQVF7KTXq83+ojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ATYPkbQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07A1606A328
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ATYPkbQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE7D1F008A1;
	Fri,  6 Nov 2026 01:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928458;
	bh=GvCM/cAPLsQkcBRyhPjZzPtPRHyc2SAMBACEwjJMOI0=;
	h=Date:To:From:Subject;
	b=ATYPkbQW05m4v4WJgiQQoeV/qSFjslZiVgmlnErRMCRmL1QUF4TVcEgQJqVHHTp0X
	 5yMdCCofD+XCWDTr0WAlVqPBUFZI5vvUjfdGCcGh9B8BfFpXFJrY7+ntZr0D6uJfXE
	 WGhuLPiOEDjZwdu4tunDVocV+M5Q7aEaJmWWpRQM=
Date: Thu, 05 Nov 2026 17:27:38 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sarthak.sharma@arm.com,
	pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,
	liam@infradead.org,jannh@google.com,david@kernel.org,azpijr@gmail.com,
	josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch added to mm-new branch
Message-Id: <20261106012738.9EE7D1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: restore VMA_ACCOUNT_BIT if the unmap fails
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch

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
Subject: mm/mremap: restore VMA_ACCOUNT_BIT if the unmap fails
Date: Thu, 05 Nov 2026 14:02:06 +0000

If the unmap at the end of an mremap() move fails, the source VMA stays
without VMA_ACCOUNT_BIT.  Neither munmap() nor exit_mmap() uncharges it
then, so the charge for all of its pages stays in vm_committed_as after
the process is gone.

unmap_source_vma() clears the flag on the whole source VMA before the
unmap and sets it again on the remaining parts afterwards, but its error
path returns without doing so.

This was reproduced with fault injection: each failure on an anonymous
mapping left Committed_AS higher by the size of the whole VMA after
everything was unmapped.

Fix by setting the flag again on everything in the range of the original
VMA, on both paths, with a new helper.  A failed unmap may have split the
VMA already, so the helper walks the range.

Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-4-f8789de76849@toxicpanda.com
Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
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

 mm/mremap.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/mm/mremap.c~mm-mremap-restore-vma_account_bit-if-the-unmap-fails
+++ a/mm/mremap.c
@@ -1189,6 +1189,19 @@ static unsigned long prep_move_vma(struc
 	return 0;
 }
 
+/* Set VMA_ACCOUNT_BIT on all VMAs in the range [start, end). */
+static void vma_range_set_account(struct vma_iterator *vmi,
+				  unsigned long start, unsigned long end)
+{
+	struct vm_area_struct *vma;
+
+	vma_iter_set(vmi, start);
+	for_each_vma_range(*vmi, vma, end) {
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_ACCOUNT_BIT);
+	}
+}
+
 /*
  * Unmap source VMA for VMA move, turning it from a copy to a move, being
  * careful to ensure we do not underflow memory account while doing so if an
@@ -1246,8 +1259,10 @@ static void unmap_source_vma(struct vma_
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		if (accountable_move)
+		if (accountable_move) {
 			vm_acct_memory(len >> PAGE_SHIFT);
+			vma_range_set_account(&vmi, vm_start, vm_end);
+		}
 		return;
 	}
 
@@ -1271,28 +1286,10 @@ static void unmap_source_vma(struct vma_
 	 * | A |     | B |
 	 * |---|     |---|
 	 *
-	 * The VMI is still pointing at addr, so vma_prev() will give us A, and
-	 * a subsequent or lone vma_next() will give as B.
-	 *
-	 * do_vmi_munmap() will have restored the VMI back to addr.
+	 * So reinstate the flag on whatever is left of the range.
 	 */
-	if (accountable_move) {
-		unsigned long end = addr + len;
-
-		if (vm_start < addr) {
-			struct vm_area_struct *prev = vma_prev(&vmi);
-
-			vma_start_write(prev);
-			vma_set_flags(prev, VMA_ACCOUNT_BIT);
-		}
-
-		if (vm_end > end) {
-			struct vm_area_struct *next = vma_next(&vmi);
-
-			vma_start_write(next);
-			vma_set_flags(next, VMA_ACCOUNT_BIT);
-		}
-	}
+	if (accountable_move)
+		vma_range_set_account(&vmi, vm_start, vm_end);
 }
 
 /*
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

