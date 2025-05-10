Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3233A94F
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837755; cv=none; b=RdT9kUm52BMXUDr5qNP3dX+s0fWCU5+srlaBTZa0Ms0kvBFBRBtwoby7oWLiymr0NHLPXxH46VMGnBbExX6m5ffvU4wBhMcnlgYtLFCCZHqiVsRi/MK5gZ8LZOYfeAHL/fp8hJ0wbhOseo8hsnSh9Vi45Wl6qXDs0o3C+RzONPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837755; c=relaxed/simple;
	bh=iGN79tVQ9shJGWC9FDXN9Z72Y6TK0fWAD0zqqTALJLA=;
	h=Date:To:From:Subject:Message-Id; b=LfUElbTm68EI8NR6hvBpaRIq/WzdrqY+qPVagcYOxj+TNKiBvJaq3ZGy+/dtmswb2J9G4D+b5AEOz13qmzzTo2hAMue+JHqCp9hFDUVUWiq+oNxPz+FnxgZ0ElzuukhxBq/auKRXsCEE2yoXCqvTUpy3jiwXUOd9qXuHARFbYU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=imaR29Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="imaR29Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A099C4CEE4;
	Sat, 10 May 2025 00:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837755;
	bh=iGN79tVQ9shJGWC9FDXN9Z72Y6TK0fWAD0zqqTALJLA=;
	h=Date:To:From:Subject:From;
	b=imaR29GoPuLKbd6oUXnIkigO3ONTObXMhHKGWlat/LDcZxUwxsThRZ1gpj4tDT2qz
	 5rnTExC7pUneZmQyLqol7CVtc6YqPRXiE1pWJX+ilOPU117lE3aNZyCh0XHZvoP5bo
	 bPx9+0vYjTeKWnlj23qSEb68n8eDqOl+/pn7uDIA=
Date: Fri, 09 May 2025 17:42:33 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,baohua@kernel.org,anshuman.khandual@arm.com,379943137@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-obsolete-pgd_offset_gate.patch added to mm-unstable branch
Message-Id: <20250510004235.3A099C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove obsolete pgd_offset_gate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-obsolete-pgd_offset_gate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-obsolete-pgd_offset_gate.patch

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
From: Feng Lee <379943137@qq.com>
Subject: mm: remove obsolete pgd_offset_gate()
Date: Fri, 9 May 2025 14:32:30 +0800

Remove pgd_offset_gate() completely and simply make the single caller use
pgd_offset().

It appears that the gate area resides in the kernel-mapped segment
exclusively on IA64.  Therefore, removing pgd_offset_k is safe since IA64
is now obsolete.

Link: https://lkml.kernel.org/r/tencent_503130C3CD56569191396268CF4D12F09A06@qq.com
Signed-off-by: Feng Lee <379943137@qq.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: bibo mao <maobibo@loongson.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 ----
 mm/gup.c                |    5 +----
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-obsolete-pgd_offset_gate
+++ a/include/linux/pgtable.h
@@ -1164,10 +1164,6 @@ static inline void arch_swap_restore(swp
 }
 #endif
 
-#ifndef __HAVE_ARCH_PGD_OFFSET_GATE
-#define pgd_offset_gate(mm, addr)	pgd_offset(mm, addr)
-#endif
-
 #ifndef __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)	(pte)
 #endif
--- a/mm/gup.c~mm-remove-obsolete-pgd_offset_gate
+++ a/mm/gup.c
@@ -1102,10 +1102,7 @@ static int get_gate_page(struct mm_struc
 	/* user gate pages are read-only */
 	if (gup_flags & FOLL_WRITE)
 		return -EFAULT;
-	if (address > TASK_SIZE)
-		pgd = pgd_offset_k(address);
-	else
-		pgd = pgd_offset_gate(mm, address);
+	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd))
 		return -EFAULT;
 	p4d = p4d_offset(pgd, address);
_

Patches currently in -mm which might be from 379943137@qq.com are

mm-remove-obsolete-pgd_offset_gate.patch

