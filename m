Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0DA155726
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732878830; cv=none; b=VXMzEmcfmfKa842sjdVeqxDJ1yBpI/yTdDumGivdEGXZWqAES1W30hNo0p0LoDAWTOjOVIdoOMuxXdCqUUmqj0gDmvHTc3ez7tKTWZV1a53cgugl9vbepD6lVfqsMx7EDzyovaKMMJZbke9e+lyLY5VrUeC63fj1PJ8y8b6+j+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732878830; c=relaxed/simple;
	bh=RuF89v330+n1SbkRYbLr1aDyO8l0ysbbnclAWutE/P0=;
	h=Date:To:From:Subject:Message-Id; b=G5oV2+MRYccZ73C29olWPERzW2CtqKwLuOLP/y2WXN/XtaDN+hL5UragF+cWyosuH0j9Q+vLrlAP72nAm1ic8O9j33e1uYF8CFr5DlA0i4NvoZnsX2kjyrrpmfCFSXW7DrrpRVl+z2a5QjEZqqtFdjl56dkP4ZQf1xm7sg6yfY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OaY837Jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OaY837Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59975C4CECF;
	Fri, 29 Nov 2024 11:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732878829;
	bh=RuF89v330+n1SbkRYbLr1aDyO8l0ysbbnclAWutE/P0=;
	h=Date:To:From:Subject:From;
	b=OaY837JoYmr0NHXR2qJAZMAiXv4VjvkjAcGI0yhgnElrxMBrCEF/itabgDTV77CQe
	 eaIGuLrhhy/QC6SabG+T0+aqoKnSZZGQCLsDPxinYkbEtv3XIz8sDBGN5FBKQ8UP3r
	 7SQuogHVBEgqW5tYKJaouKJCUn3Bsl7iuYD0AnK8=
Date: Fri, 29 Nov 2024 03:13:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-typo-in-mmap_state-macro.patch added to mm-hotfixes-unstable branch
Message-Id: <20241129111349.59975C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct typo in MMAP_STATE() macro
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-correct-typo-in-mmap_state-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-typo-in-mmap_state-macro.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: correct typo in MMAP_STATE() macro
Date: Mon, 18 Nov 2024 17:54:14 +0000

We mistakenly refer to len rather than len_ here.  The only existing
caller passes len to the len_ parameter so this has no impact on the code,
but it is obviously incorrect to do this, so fix it.

Link: https://lkml.kernel.org/r/20241118175414.390827-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-correct-typo-in-mmap_state-macro
+++ a/mm/vma.c
@@ -35,7 +35,7 @@ struct mmap_state {
 		.mm = mm_,						\
 		.vmi = vmi_,						\
 		.addr = addr_,						\
-		.end = (addr_) + len,					\
+		.end = (addr_) + (len_),				\
 		.pgoff = pgoff_,					\
 		.pglen = PHYS_PFN(len_),				\
 		.flags = flags_,					\
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-v3.patch
docs-mm-add-vma-locks-documentation-fix.patch

