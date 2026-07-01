Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE066279DCA
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782885183; cv=none; b=hmmM1CFPH9kd3rvnW+gMShr1C2bz1UjhYFtxE11zOokl7sBHB4hKGXdEX9WcKPSPzkpM93Z93ZzqA0o/LV8Lyn7USA7Ap0IcWxess2NdsP/NiBXKQ6aKiDfXaiI2/8TUikRpI4F/u/Tp8UKTyhvE5Tfh/41nnzNWFWhcz1Pt4cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782885183; c=relaxed/simple;
	bh=yeOZs1s3twvp4jk/CsugYG8bHW/59PWkrte4aek2MZo=;
	h=Date:To:From:Subject:Message-Id; b=g78CBV7vTJ9fygzJUPkPrCZIReocLGrwYbkiXqXxN1ADv6JwYrppNJJtxE1ZRlEB9Uh0AyB9I+mXU8CLt8OLO4b3HFxyUoQ3I6wD8DrKVeoAq9IpRoPyD31REaWaSxjYK7Zpc5ivFyCUoHTeykHzNL5dP5aH5I9ITPDQrPV/gcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Buu0Rw0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Buu0Rw0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8748D1F00A3A;
	Wed,  1 Jul 2026 05:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782885181;
	bh=XjOUTKpZKCTsPvQijHQhnF4YF2uMYWCwl1RThnlYNS8=;
	h=Date:To:From:Subject;
	b=Buu0Rw0lUyVxKmNNpbH8zuOFajJU65f7faNF1DkpqO6O+YErixWkab1m/EPNiE5kG
	 yUlP6r90ZifZ/U/FVL9f0n3s9XKJYiOFzjebkeiRZ8fLKhmUm4sQGJCpj9JO99hPUI
	 wWNq0hzOuMfjS6GaUPXHxAeM28QZqMs8vCyCtGA8=
Date: Tue, 30 Jun 2026 22:53:01 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch added to mm-new branch
Message-Id: <20260701055301.8748D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
Date: Tue Jun 30 10:52:22 PM PDT 2026

fix page_owner.c

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
+++ a/mm/page_owner.c
@@ -809,7 +809,7 @@ read_page_owner(struct file *file, char
 				spin_unlock_irqrestore(&state->lock, flags);
 				goto ext_put_continue;
 			}
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter)) {
 				spin_unlock_irqrestore(&state->lock, flags);
 				goto ext_put_continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

