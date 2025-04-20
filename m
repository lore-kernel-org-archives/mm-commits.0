Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360E018A6D7
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745192821; cv=none; b=p99GzTdgmgB5fQxS8F/Xc/h+BmWkYtrF4wM6/5TPevV9CUWllfSLLcvlDFjx83iSjfLdoXlLNzqUff0vJedh/ILqwdyVP2fDJBU2ax07lX64KhdRIhmbKgRojrXJnVCIcDzyoHswIT1qXv+Cgfyd5SQRB0lIir5O0DC+3DZdHsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745192821; c=relaxed/simple;
	bh=RNhncM0V9GpedyLesdhoMoggNSWN3eREndgw8ijXRow=;
	h=Date:To:From:Subject:Message-Id; b=fQaIYNbgVwIPq7T80Asao6BqOZbCZ0WMy7atMjF55rUPYxIRVbqQIywotxBlytbb3gXpk6FelhWdc/vxAYwKoQB+11C+IMbWJTPTiplUjFxNf6Rd5j+TRyg3hbSmO1kSlszxPBi4vEx9+VcRf4PixycVv59sbqsAT7ZK4FDCJNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTjYdSAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTjYdSAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913AEC4CEE2;
	Sun, 20 Apr 2025 23:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745192819;
	bh=RNhncM0V9GpedyLesdhoMoggNSWN3eREndgw8ijXRow=;
	h=Date:To:From:Subject:From;
	b=fTjYdSApGC5IKH7VdVrrpbyU8uYsEVUODKGGIduLruA0o6ge3eSVGL1Iwu5o7CYNo
	 9Hcg/xOfOzhU6eFhMv+slxD9//OqyxihObmTtPTJUfDP6Q/8vfjd8Dj2tI3SqcOm1R
	 kwFoWCu+kCFV//DdoNHzQ4BmNq4OaBmPy7qhXpxc=
Date: Sun, 20 Apr 2025 16:46:58 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch added to mm-unstable branch
Message-Id: <20250420234659.913AEC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix typo in comment in page_address_in_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/rmap: fix typo in comment in page_address_in_vma
Date: Fri, 18 Apr 2025 17:56:00 +0800

Fix a minor typo in the comment above page_address_in_vma():
"responsibililty" → "responsibility"

Link: https://lkml.kernel.org/r/20250418095600.721989-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-typo-in-comment-in-page_address_in_vma
+++ a/mm/rmap.c
@@ -774,7 +774,7 @@ static bool should_defer_flush(struct mm
  * @vma: The VMA we need to know the address in.
  *
  * Calculates the user virtual address of this page in the specified VMA.
- * It is the caller's responsibililty to check the page is actually
+ * It is the caller's responsibility to check the page is actually
  * within the VMA.  There may not currently be a PTE pointing at this
  * page, but if a page fault occurs at this address, this is the page
  * which will be accessed.
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

