Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490B267386
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820517; cv=none; b=FTZBQbpxnP276X879RODNC6dqUICLaWm/dF/AsO/wN/+JtlbEJ/iyks50nTwqwKibZW7gIcfIIEITUORra2OlgJjunTvDRhD/q8LHLfDHdEOPYo0SWw303BhqU8BGbBIs2K48aMJmmivYRdWqdfabcYC7hQWcd9HY5Xe3QwdLTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820517; c=relaxed/simple;
	bh=2ifRYI7e6ddH0SrsJ7BGJdkdZ/3oMyf8gkqstiG7g1c=;
	h=Date:To:From:Subject:Message-Id; b=Xq4vlfumXA9nnbTdgp28ju5jLZeSiSRqTgJ0ebedd8UK9zhP75d3T6Nk7VTCGvV82CmUQaKGmB0RCSe21ot2gKmo8AviK+atqi8m+EOE+fVb47y6SZbkdn9fqDB9a2YxqT6TYl9Lnmn9h+vxlIll/3Ub7tr2tHK00Dg5QuBcaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fOXydpw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fOXydpw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B2CC4CEEF;
	Tue, 29 Jul 2025 20:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753820517;
	bh=2ifRYI7e6ddH0SrsJ7BGJdkdZ/3oMyf8gkqstiG7g1c=;
	h=Date:To:From:Subject:From;
	b=fOXydpw/p55kcye+d69231QArnBIlh6Wu198rH5Lrs0M7EIUu9U7nYvexSlWWMhrt
	 7C7VxVM6lvPUnaO1a7bqjxNdmL11zddQOoESk1M6NoCB9K4OhPdlI9oM5aerYfSibG
	 v/4AI+Pa2XC5cl48IR34GkdpH3vZ6/HCuLtLr60M=
Date: Tue, 29 Jul 2025 13:21:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch added to mm-unstable branch
Message-Id: <20250729202157.39B2CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fixup very disguised vmalloc flags parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fixup very disguised vmalloc flags parameter
Date: Tue, 29 Jul 2025 13:48:50 +0100

The declare_vma() function in arm64 arch code liberally mixes the concepts
of VMAs and near-identically named vmalloc data structures, so I
accidentally changed the 'vm_flags' field' that is assigned to a 'vma'
thinking it was... the vm_flags field of a vma, which it turns out, it
isn't.

Revert the type from vm_flags_t to unsigned long.

Given vm_flags_t == unsigned long, there is no change in any behaviour
before or after this patch, but in future this will matter.

Link: https://lkml.kernel.org/r/e74dd8de-7e60-47ab-8a45-2c851f3c5d26@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~mm-correct-type-for-vmalloc-vm_flags-fields-fix
+++ a/arch/arm64/mm/mmu.c
@@ -721,7 +721,7 @@ void mark_rodata_ro(void)
 
 static void __init declare_vma(struct vm_struct *vma,
 			       void *va_start, void *va_end,
-			       vm_flags_t vm_flags)
+			       unsigned long vm_flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch
mm-correct-type-for-vmalloc-vm_flags-fields.patch
mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

