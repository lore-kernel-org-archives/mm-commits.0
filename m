Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562979;
	b=42Z1kKyvdw0hVIEwvbpS85BUeiJQkCltDs8b3q3s5KnAzI/h7JilWIvh52S4cfY8939d
	 S5oCxyhqygkBge+o0FmOPQ9euGv9N/4oQ0LpOCGCMqGx1BZjk8fQuh47hFx/JDCgLb54y
	 ELKcwaujBAJiTFWuZnsGDBzmUIpHRQ5BO5jIIa1NUTcCZO1cxbYHdmmPsMFJHfbdciO4X
	 syYgryx1v3ypaUgHSKt00L9EiJ4dHoG3Eo2JSKt/TKGBjUC1RTJD5R8oAZUNk9+bAcMKB
	 km4Rpox7101okJoDFY44j9I+haIs2XX4svWAJArUzqP6ma7k3LAgRtQFj3xobIA3gNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562979;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=O8n14Yk1Wil/YzutbjPw6McNfXfMAan683Ngb07TXiU=;
	b=H0dMFEIqkI75TGOJAYLAb1E9oHhw3N2f5IamzGPu7ka4WKNemD8WRCcubwQkXIR9mDAQ
	 HN+A1sDlE30H+u3+q0btytARwhJG2dQYKlDI9+4fheeFreQORNpD8UOdAMzY3gXoo7Q1k
	 hwazrjfv8AlEhZbIseO3YA0tNZRB9W/m4mOlKmn3cZC0J3sdSv6SvMg8HV/O61zj7IAOq
	 BmBSFDr+lTAyrQinHUuQs/5WsOMU0cUSiVADn89gJfiePfZnKKUj31cAimVk2YuzJrZLL
	 +dmMzpaoFFonGZmh+ncL761faf+2TJFPw1xRm8lDbjIDQMLYMbD6fNe+nIqK+eqG5jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OjWwKPDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA485606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 23:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OjWwKPDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7E01F000D0;
	Tue, 24 Nov 2026 23:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562978;
	bh=O8n14Yk1Wil/YzutbjPw6McNfXfMAan683Ngb07TXiU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=OjWwKPDZ6IqEEyey1E9dP5wLk/lsrzaY3M5BGOeLGa7gXL/O2+7A6rkuND1nO5qIC
	 sk77f/mrhpL29huR65raNN1HfQ7VLvtavEdhIzsO9Econ0CEvIwVJpFg6Zy7Pbe8EQ
	 98d3caQ72ksOg5UYO6jSQDwHOnVS/kkeEAmvo4AM=
Date: Tue, 24 Nov 2026 15:29:38 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	kees@kernel.org,josef@toxicpanda.com,joey.gouly@arm.com,jannh@google.com,
	hughd@google.com,gourry@gourry.net,david@kernel.org,chengming.zhou@linux.dev,
	catalin.marinas@arm.com,bunk@stusta.de,azpijr@gmail.com,
	a.p.zijlstra@chello.nl,aaw@google.com,mason@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
Subject: + mm-mremap-respect-guard-gaps-on-in-place-expansion.patch added to mm-new branch
Message-Id: <20261124232938.CD7E01F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: respect guard gaps on in-place expansion
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-respect-guard-gaps-on-in-place-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-respect-guard-gaps-on-in-place-expansion.patch

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
From: Chris Mason <mason@kernel.org>
Subject: mm/mremap: respect guard gaps on in-place expansion
Date: Sat, 21 Nov 2026 16:02:32 +0000

Growing a mapping in place can let it use up the guard gap below a
stack, so that the stack can't grow any further, or overflows into the
mapping instead of faulting.

A mapping has to stay out of the gap of the next VMA unless the caller
fixed its address. But vma_expandable() only checks that the new range
doesn't intersect the next VMA, and it passes MAP_FIXED to
get_unmapped_area(), which skips the gap check there.

Fix the issue by stopping in-place growth at the start of the gap.

Growing a mapping into or within the gap of a stack or shadow stack now
fails with ENOMEM without MREMAP_MAYMOVE, or if the mapping can't be
moved.

Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org
Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536256259.412063.8859349312024671580.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Josef Bacik <josef@toxicpanda.com>

 mm/mremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-respect-guard-gaps-on-in-place-expansion
+++ a/mm/mremap.c
@@ -1509,10 +1509,12 @@ static unsigned long mremap_to(struct vm
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 {
 	unsigned long end = vma->vm_end + delta;
+	struct vm_area_struct *next;
 
 	if (end < vma->vm_end) /* overflow */
 		return 0;
-	if (find_vma_intersection(vma->vm_mm, vma->vm_end, end))
+	next = find_vma(vma->vm_mm, vma->vm_end);
+	if (next && end > vm_start_gap(next)) /* intersection, or in its gap */
 		return 0;
 	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
 			      0, MAP_FIXED) & ~PAGE_MASK)
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch
mm-vma-fix-uncharge-after-failed-stack-relocation.patch
mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch
mm-mremap-respect-guard-gaps-on-in-place-expansion.patch
mm-vma-make-brk-mappings-non-executable-under-mdwe.patch

