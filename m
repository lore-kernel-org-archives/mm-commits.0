Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A325C6EE
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242636; cv=none; b=t+HsSHn1Ud8pwVlBzPxKw/xoTkUU+t90k2o+r0zLuQYsaHEdVhYXIzsQMtF/GtrQZf0OJ7pJttHl3DW8myVyc+ZTB5CMsP+/GjXJK+JbrgX+bomdApL7/UwCcYhak5PeuZtX4JMA0kediBU1WHeGYnzibp7m1ndfIPPxONOBSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242636; c=relaxed/simple;
	bh=jdbNrXrw0qSlryaU6Jl0v0qGU/sMYgJSokfdZ/sJKYQ=;
	h=Date:To:From:Subject:Message-Id; b=Xvqml1F72ry5P4ikVbekPfq6RHw6xoLOwz/wAWJd2Sg195O89lzM6LhForwg4J5lLTvkfUODvso4LQ6mc9+0UzX+nDbFEGfgrTvuketbkDyPPwV39kMYLt1EITj/pfQjE/2es1zOS9CrVKud8ctwT82dPzVy+ZT9gOtJot6ulDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tp5Ub3de; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tp5Ub3de"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9AF1F000E9;
	Thu, 20 Aug 2026 16:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787242634;
	bh=xL4ttqaEhf66qB+ZsN9wf7aUWY5XATJAQ5D0iwmuvmg=;
	h=Date:To:From:Subject;
	b=tp5Ub3deKUOy+mB66JcndIZWGkrPaRJdu8+ZgBjjUdKtLXzOmtJhK8ZRAkDt5utDQ
	 vkzZJxWZKqXb9Hd8DvFvY1UjJ36mYfLsYPOKsc+ksHmYJEmkWSpRR/hqEjzHZX0Pp2
	 58wa+HpfRX7u+jXU8181+ZC7AQ+yO5mhEZcYwEuY=
Date: Thu, 20 Aug 2026 09:17:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch added to mm-unstable branch
Message-Id: <20260820161714.BF9AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
Date: Thu Aug 20 09:15:38 AM PDT 2026

fix comment typo, per Lorenzo

Link: https://lore.kernel.org/aob1goSSPH6sTN9y@gremlin
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
+++ a/include/linux/mm.h
@@ -2318,7 +2318,7 @@ static inline bool vma_flags_is_cow_mapp
 
 /**
  * vma_is_cow_mapping() - Is this VMA a CoW mapping?
- * @desc: The VMA to check.
+ * @vma: The VMA to check.
  *
  * See vma_flags_is_cow_mapping() for details.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

