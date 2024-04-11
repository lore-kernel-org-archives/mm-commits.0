Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DBF175A6
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712864909; cv=none; b=Whl/QfCdFtxNGizP+qAT0AzUlz5YBJKkyGPJrwTLZTcy/kfuTdcfGp08rMVOKrANm0r1kcy8D2fdprOLTIBxhV9I3zl6J5tAupwcHEMW1HkKiGLO+WB4BLqVktRkTrHdNfFWUjEtVxNxJId0hXjrtyRrtIqoiv2sNStJa29VSIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712864909; c=relaxed/simple;
	bh=ZRBD94spFNw4PX0h6SpODys5JLod1HTsjDE84nGFeOI=;
	h=Date:To:From:Subject:Message-Id; b=MOr0TQ4XhDLFJH7alUKOqSrBNNGmLD9sI6q5ojTnj3NlhKIiSk/3HsJDZ2soXSOXUNtAp3BRdun02ma3IPW8ckmHYQZwr9deoMP+JJMxYcUMGZChcxH4/IwS8GBiSVqU55GD0ZjRsgQQKaG6/23n1Rh/Q6AUaw7YwoNAoFTpUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khddNlgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khddNlgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE1DC072AA;
	Thu, 11 Apr 2024 19:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712864909;
	bh=ZRBD94spFNw4PX0h6SpODys5JLod1HTsjDE84nGFeOI=;
	h=Date:To:From:Subject:From;
	b=khddNlgcb/QqtFfSOSQc9oN5dymUvClx21ocBWxDD5x4m0vylzzxTCn1ne0scFK9m
	 VJWYNSEkM3/1MdqE0judyi567hYzM3zP62aS2HKuISUqpwBa0S1hdN6ZYcTJiu87cQ
	 ckPZ9DC274yAr4TmLHJ3sBz6LzfqJPV4jNNC5TUU=
Date: Thu, 11 Apr 2024 12:48:28 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,sj@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-swpin_refault-counter-fix.patch added to mm-unstable branch
Message-Id: <20240411194829.0BE1DC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-per-order-mthp-swpin_refault-counter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-swpin_refault-counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-swpin_refault-counter-fix.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm-add-per-order-mthp-swpin_refault-counter-fix
Date: Thu, 11 Apr 2024 13:46:36 +1200

fix build errors on CONFIG_TRANSPARENT_HUGEPAGE=N

Link: https://lkml.kernel.org/r/20240411014636.14023-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: SeongJae Park <sj@kernel.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-add-per-order-mthp-swpin_refault-counter-fix
+++ a/mm/memory.c
@@ -4141,6 +4141,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* We hit large folios in swapcache */
 	if (start_pte && folio_test_large(folio) && folio_test_swapcache(folio)) {
 		int nr = folio_nr_pages(folio);
@@ -4170,6 +4171,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 check_pte:
+#endif
 	if (unlikely(!vmf->pte || !pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
 		goto out_nomap;
 
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-add-per-order-mthp-swpin_refault-counter-fix.patch

