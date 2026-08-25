Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F73793BD
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622952; cv=none; b=eNL84a49Av8JHX4ULp6y0Quj6f8k5/OVodm1DQkJdIZ/iSuI6eCRmsm58Q6eN9grVYNo4F9q3PIJn3Kc7p2bdAaXCmIGWEojMw073HAsLl6PyALq8UgCuuco9xRN6rdt7SLWEY/JR7LYVa5F+YuxGRo02so2aVQVNzIZHsaJsXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622952; c=relaxed/simple;
	bh=oLRRZTqQW1yeOMOJfv7dZ95V320tX65ZMNM3YmD/fd4=;
	h=Date:To:From:Subject:Message-Id; b=bmybsQpi2yClPr+HiqxsKrP+4TCCwX05qn9D+dYijuAGkuHLKgG3YmSBx6WsIw6dw7gFfJa+rHQ/s7/lF7hpqzchCtWiUh9EgSU8lmt3s+81Hl+ADI+D9d8aVlTgods52nq8PYsADNVYOXisqcRG5JM14s4cPSEVqbVX89MxID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Thpvt1hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Thpvt1hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291671F00A3A;
	Tue, 25 Aug 2026 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622949;
	bh=p/Qn9/8OGuEpp79DjHFK7DfBxiTVXVMG+AlqAwIVpA8=;
	h=Date:To:From:Subject;
	b=Thpvt1hjgUTIOh0Q7xzfozc8AaxJjf/A0DZ8DxQplRZp5MshPRNz/OQ9HPeAXOyji
	 Dzz3NlZUq7pqfHM6kyUFqimHcGyfEiviFGFU0fX0TKWoqaD0vkyKES+46kt8U87iG9
	 s7jQ0V5XIpyFthCOe2DI/AnMWdwEZk3Jd4XbVeHI=
Date: Mon, 24 Aug 2026 18:55:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,seohyun.kim@outlook.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch removed from -mm tree
Message-Id: <20260825015549.291671F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: synchronize lock and unlock target in anon_vma_clone
has been removed from the -mm tree.  Its filename was
     mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Kim <seohyun.kim@outlook.kr>
Subject: mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Fri, 14 Aug 2026 15:30:51 +0900

Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
active_anon_vma and is used when unlocking anon_vma after linking new
AVCs.  However, the anon_vma is locked using src->anon_vma, instead of
active_anon_vma, making the lock and unlock target inconsistent.

Use active_anon_vma for both locking and unlocking.

Link: https://lore.kernel.org/OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com
Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone
+++ a/mm/rmap.c
@@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_lock_write(active_anon_vma);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
_

Patches currently in -mm which might be from seohyun.kim@outlook.kr are


