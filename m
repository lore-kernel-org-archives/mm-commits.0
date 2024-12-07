Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C2110E0
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733550324; cv=none; b=Pz0q/vgq3eJ8ziGaVP+9LpIJ/FGcXVg0SyFa3Ay27X4FxSMY3g/ZM/5ACYUuauYgw5SDmjAmxWRtSOWheiC1TXJPmpvkRyJIgysSk1KdQDkdhnq15vVGcFVLCDc/+JLa1qKI8e/kr2JoCV/D2AKEdUBqlG2nD5cJlRM3OwbbPJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733550324; c=relaxed/simple;
	bh=ntl/Sq1XFIVnkMEXvfFSI8GNYWY036Jnf0y/o9KcNg0=;
	h=Date:To:From:Subject:Message-Id; b=oLsPLpU3WBMxyhWiaiI2Uze+yCHwQzHNf/TICERiw1Pj512KOyDN6sF/P8fDul+gO9Kpeza0Kwfuiq01EJkBRBzoFkhTAf4J0qpRoyDp2wqUbstC5579nCJ0A2Mu0BDoTQr2/AJcSDUCXKzc6RoQ35/sWMuPtFLpTD93Qnnp1Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xumMU+oB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xumMU+oB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C0C4CECD;
	Sat,  7 Dec 2024 05:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733550324;
	bh=ntl/Sq1XFIVnkMEXvfFSI8GNYWY036Jnf0y/o9KcNg0=;
	h=Date:To:From:Subject:From;
	b=xumMU+oB2dniffd9+pZUTfvKbMgHxfM+brgUb+xUkPnSEuhpkDnIy7chIXgkzGFyl
	 DlRb33i3OQIDOjaJ5En1kGJCK56MGBYffaBEFCAiZpMbhb94DGI4D1+9Z93cUpJB/d
	 aTn/RTaSUOvXkghu14Ov6vec2/OB61K2H2E5v+Kw=
Date: Fri, 06 Dec 2024 21:45:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-group-all-vma-related-files-into-the-vma-section.patch added to mm-unstable branch
Message-Id: <20241207054524.358C0C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: group all VMA-related files into the VMA section
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-group-all-vma-related-files-into-the-vma-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-group-all-vma-related-files-into-the-vma-section.patch

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
Subject: MAINTAINERS: group all VMA-related files into the VMA section
Date: Fri, 6 Dec 2024 19:16:00 +0000

There are a number of means of interacting with VMA operations within mm,
and we have on occasion not been made aware of impactful changes due to
these sitting in different files, most recently in [0].

Correct this by bringing all VMA operations under the same section in
MAINTAINERS.  Additionally take the opportunity to combine MEMORY MAPPING
with VMA as there needn't be two entries as they amount to the same thing.

[0]:https://lore.kernel.org/linux-mm/CAG48ez0siYGB8GP5+Szgj2ovBZAkL6Zi4n6GUAjzzjFV9LTkRQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20241206191600.45119-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/MAINTAINERS~maintainers-group-all-vma-related-files-into-the-vma-section
+++ a/MAINTAINERS
@@ -15060,18 +15060,6 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
-MEMORY MAPPING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Jann Horn <jannh@google.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/mmap.c
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
@@ -25028,6 +25016,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	https://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/madvise.c
+F:	mm/mlock.c
+F:	mm/mmap.c
+F:	mm/mprotect.c
+F:	mm/mremap.c
+F:	mm/mseal.c
+F:	mm/msync.c
 F:	mm/vma.c
 F:	mm/vma.h
 F:	mm/vma_internal.h
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
maintainers-group-all-vma-related-files-into-the-vma-section.patch

