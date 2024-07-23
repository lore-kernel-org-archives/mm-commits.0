Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3DB1428E5
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 23:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778454; cv=none; b=Waa1N8YHJ4YrjwzXEfJ8hWIvqaPmA/C69rNAgh39w+eX3fyReK0Uu1JrNtJOrtN3lkczLas/h3i8NclQXTbX7AVCVxhgPpXm4SyMiWYVXJ8o/VXvX7Klp0ce3FQuKtdJLl/G1EdmOT0bMc/SxSYOpsoFQWjA9kSu+ovH4LTlfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778454; c=relaxed/simple;
	bh=godyF1w+3/0oTvjqbZM7Bfak9OBn9d+fohKyenkd4F4=;
	h=Date:To:From:Subject:Message-Id; b=Bpv2DCuCpeq84PfZivL+8tgRu+dfMLVHro/IlXYJRHudHnNCFzetbEAaDQjDamYhPgINSBAGAbgxwpd3of8GOvBI3P+LhUUyaxZMrSUWXeuMByqEmcbe+BU/IMa3rzR/07WGgTiDgJxgaBpmy3iDdJcma3gX8yNVtfg0xpvPHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qSbm5y9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qSbm5y9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D540C4AF09;
	Tue, 23 Jul 2024 23:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778454;
	bh=godyF1w+3/0oTvjqbZM7Bfak9OBn9d+fohKyenkd4F4=;
	h=Date:To:From:Subject:From;
	b=qSbm5y9xbhTbj+/MscOUR2oMVpp6BYKtSNSdeXfitYqIS1cWDwfZdzZ/52dnqJC1p
	 W/yySHm+0g4PPKF4ErhkgDPOz5MJQH1M9QPsSu5JlP5fBnoaTxAQDBlwRYBzEpI900
	 fhVK4zjq6ZSWipP4XADYXRVAQfp1k18vGcAX0P1s=
Date: Tue, 23 Jul 2024 16:47:33 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,jdike@linux.intel.com,david@redhat.com,blaisorblade@yahoo.it,agk@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-mm-remove-redundant-assignment-of-max_low_pfn.patch added to mm-unstable branch
Message-Id: <20240723234734.6D540C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: um/mm: remove redundant assignment of max_low_pfn
has been added to the -mm mm-unstable branch.  Its filename is
     um-mm-remove-redundant-assignment-of-max_low_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-mm-remove-redundant-assignment-of-max_low_pfn.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: um/mm: remove redundant assignment of max_low_pfn
Date: Sat, 15 Jun 2024 03:41:50 +0000

Current calculation of max_low_pfn is introduced in commit af84eab20891
("[PATCH] uml: fix LVM crash").  It is intended to set max_low_pfn to the
same value as max_pfn.

But I am not sure why the max_pfn is set to totalram_pages, which
represents the number of usable pages in system instead of an absolute
page frame number.  (The change history stops there.)

While we have already calculate it in setup_physmem(), so not necessary to
do it again.

Also this would help changing totalram_pages accounting, since we plan to
move the accounting into __free_pages_core().  With this change,
totalram_pages may not represent the total usable pages at this point,
since some pages would be deferred initialized.

Link: https://lkml.kernel.org/r/20240615034150.2958-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/um/kernel/mem.c~um-mm-remove-redundant-assignment-of-max_low_pfn
+++ a/arch/um/kernel/mem.c
@@ -73,7 +73,6 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-	max_low_pfn = totalram_pages();
 	max_pfn = max_low_pfn;
 	kmalloc_ok = 1;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

um-mm-remove-redundant-assignment-of-max_low_pfn.patch

