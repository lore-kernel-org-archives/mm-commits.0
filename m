Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA01F3D6479
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846803; cv=none; b=o4oGAmzvIbPL/oC4VmHxwaXIWgTIXZcnD0Nq7xoSsuHAjrhWwEOHDYeYmCglZjDeJHpb7IvdBfSS2jrrVvTE03CdVBb3azGrR592y4JWvCB2Mvd2vEu/8JGxD5ddgZwTou2LlgtTFHeYgdIF3HkRppMDKizl3Cq3XYCmA3w8wQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846803; c=relaxed/simple;
	bh=jUpyZ4wAmM40DaA5BoHRsNsXR0o0rqMOX8XFBpGmlYA=;
	h=Date:To:From:Subject:Message-Id; b=qGjT9eH+ZM7fuJkaINXVyWZPDccU58bvWxG5Ya19mq2jo8ToV3rBQ2A3525VHrJ7GVUoTGjtD02OIT8lWSbciRNHwaI2/rMIatjQ+7PQAVnsfGT5Ag5I7FUM2prkUZ+bqt2/ln8hBk08xzfx/U25E/KqzN1aQZFyxbuBDROFBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9NKIz+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9NKIz+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5823E1F000E9;
	Thu, 27 Aug 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787846802;
	bh=lhTnnszoL+Km2la0vf5r0e+liIPriiHZeI51AFTeuJI=;
	h=Date:To:From:Subject;
	b=p9NKIz+4YsVDxlnrcNpX6xNS88zhbOXtKY7ygMJtNx0dfRfz8QdYs7A8xffHtAGLe
	 MI8gDeZr4b8h0fmMKun88d4Z2VTXqQ/Ek6dM1O0W3DwXp9xO5QrXoHKpwuZVhqBhim
	 /YQSkEPp0jzm3mZY81Ao8dFk7RswX1T3m+i+9SA8=
Date: Thu, 27 Aug 2026 09:06:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,hao.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-anon_vma_trylock_write.patch added to mm-new branch
Message-Id: <20260827160642.5823E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused anon_vma_trylock_write()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-anon_vma_trylock_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-anon_vma_trylock_write.patch

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
From: Hao Li <hao.li@linux.dev>
Subject: mm: remove unused anon_vma_trylock_write()
Date: Thu, 27 Aug 2026 15:18:06 +0800

The last user of anon_vma_trylock_write() was removed by cc22b9978509,
leaving the helper unused.  Remove it.

Link: https://lore.kernel.org/20260827071845.17636-1-hao.li@linux.dev
Signed-off-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/internal.h~mm-remove-unused-anon_vma_trylock_write
+++ a/mm/internal.h
@@ -295,11 +295,6 @@ static inline void anon_vma_lock_write(s
 	down_write(&anon_vma->root->rwsem);
 }
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 	up_write(&anon_vma->root->rwsem);
_

Patches currently in -mm which might be from hao.li@linux.dev are

mm-remove-unused-anon_vma_trylock_write.patch

