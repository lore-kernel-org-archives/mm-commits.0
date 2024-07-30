Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488FF190074
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380094; cv=none; b=n8EsHqK0YxLegft0T9LAhWbaYg9pF3DRq+ZI39lZI1k80eL1A6Z2SeTtFLXZIb+Gj0NFJH1i7Vy6smmRJkOyMyw00iPjZ54WjDHp0lkjwv9iMBnfe4RixSlGN16r9+mVmzSGxEYNX+VI65ilw1mduiNyLWi9q+EE5v+MQs2V9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380094; c=relaxed/simple;
	bh=2evlVgbHXd+Kailao1f3134CTE/OIigCFMkF3ZJmV9E=;
	h=Date:To:From:Subject:Message-Id; b=KnA6URS6Tt97ILfOFg0DOhfsU2iCIlWVzn7e5HhftutLc8kfjpBlTfvDXafvys+5goGZqEpTdaN984Sg85+x1Lw1RSXMjXfm3Rjl5JMtFt1t/nZSNgW9E+wYWZqlYzxoRO0FSSLil6Xaz5zZP04TqXXlXF9PBuxKBedh3CEy89I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zwAjWi0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zwAjWi0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE48CC32782;
	Tue, 30 Jul 2024 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722380093;
	bh=2evlVgbHXd+Kailao1f3134CTE/OIigCFMkF3ZJmV9E=;
	h=Date:To:From:Subject:From;
	b=zwAjWi0KlhDP81YA3eldG79y5HuSxP2//5MWdjCXryYfzkQmK78X6wp6MKgDWW+fk
	 v8pFM+gsoOMwxoCMZztNC11SnHG4KaoqW9j4XRwsmMGzHn2xuI2LmrilXnNj1Unpta
	 8LGOMmDK6Pqf3vZ8CbhFaFxYlGEIM6Iq2W1EYCUQ=
Date: Tue, 30 Jul 2024 15:54:53 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-implement-vrealloc-fix-3.patch added to mm-unstable branch
Message-Id: <20240730225453.AE48CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vrealloc: consider spare memory for __GFP_ZERO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-implement-vrealloc-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-implement-vrealloc-fix-3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vrealloc: consider spare memory for __GFP_ZERO
Date: Tue, 30 Jul 2024 20:49:42 +0200

Zero spare memory when shrinking a buffer with __GFP_ZERO.

Link: https://lkml.kernel.org/r/20240730185049.6244-3-dakr@kernel.org
Fixes: 1f39ee9615a8 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc-fix-3
+++ a/mm/vmalloc.c
@@ -4077,12 +4077,15 @@ void *vrealloc_noprof(const void *p, siz
 		old_size = get_vm_area_size(vm);
 	}
 
+	/*
+	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
+	 * would be a good heuristic for when to shrink the vm_area?
+	 */
 	if (size <= old_size) {
-		/*
-		 * TODO: Shrink the vm_area, i.e. unmap and free unused pages.
-		 * What would be a good heuristic for when to shrink the
-		 * vm_area?
-		 */
+		/* Zero out spare memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + size, 0, old_size - size);
+
 		return (void *)p;
 	}
 
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-vmalloc-implement-vrealloc-fix-3.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

