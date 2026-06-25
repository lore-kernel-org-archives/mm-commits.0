Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510421624D5
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782361234; cv=none; b=GGM31KxM93gho8QSO2l9bApteUr3r7akQouysFW25ufq8Twsd3pFWcRjjwXjdlF8e5+LANYeJOUComMK6JH28M8uuLJ2xsW7GyCy+ToACWM3nfPG8c51Es5+Vti53tQjpijpXm0pWHsFEVuOV3R1P4qvuyP098LEC2nThwUE5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782361234; c=relaxed/simple;
	bh=Qz3szWpzAxqJmxO88DhyHXBj8CdKiefR7NOTBiI5h8o=;
	h=Date:To:From:Subject:Message-Id; b=uOhne6un7DmzziKjuwoHV6wSKnCDWGL9O2qV2d8UE0291LZNqavNnr+EO5mQ8uyZ3H1ZiHLJ1frx4FhGtq/PwFJAzBCQ+d51id7sVM3H1vm4GgqSH+U/NnJh+aEqweJkx20tGYQqAsT3sp2BiA3XLHIYbQJQEAyzLS4bc0S6qTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W5lZTu3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W5lZTu3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5031F000E9;
	Thu, 25 Jun 2026 04:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782361232;
	bh=E7DzPJuWg3JVZ1Kmq2zndTo+hKYQxy1HURtdwC8ByU4=;
	h=Date:To:From:Subject;
	b=W5lZTu3OGAqCUINNgdGu4cHUQZXKV2zkr114yAGa7FpZ0lynBpsxz0VgCsNx0T3g8
	 4irTLE117sJB51jSiT0Jv9EFPJDOYoLXZowqBZwjrtJwMCiTL41T+uLxAFVRQYgQ8u
	 7uezvQG9p4vXtEIzykH5p5q6vtT3/JjOGjN0q3E4=
Date: Wed, 24 Jun 2026 21:20:32 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,david@kernel.org,anthony.yznaga@oracle.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch added to mm-new branch
Message-Id: <20260625042032.BD5031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in comment
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch

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
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in comment
Date: Mon, 15 Jun 2026 17:01:31 -0700

A comment in <linux/hugetlb_cgroup.h> incorrectly refers to
CONFIG_MEM_RES_CTLR_HUGETLB, which has never existed in the kernel,
instead of CONFIG_CGROUP_HUGETLB.  Correct it.

Discovered while searching for CONFIG_* symbols referenced in code but not
defined in any Kconfig file.

Link: https://lore.kernel.org/20260616000135.62815-1-enelsonmoore@gmail.com
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment
+++ a/include/linux/hugetlb_cgroup.h
@@ -267,5 +267,5 @@ static inline void hugetlb_cgroup_migrat
 {
 }
 
-#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
+#endif  /* CONFIG_CGROUP_HUGETLB */
 #endif
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are

mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch
mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch

