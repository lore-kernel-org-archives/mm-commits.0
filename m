Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B054D312803
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 20:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777150691; cv=none; b=SrM3KnAD3+PjZnWdfIh9B7O4C2jrU+5ekOLwLfL7zPeaTQazzCdO/BB8W/Xo8CpIXUoIviub9q0j4qIlqmnNbznEo4VBgEwUntAU/v6e7g/yZUa3Z7liwxLaJsaNN+AijMzH4+OTV6bJ8DpT122vjGmRENbpCKPjkp5ZLL0vyPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777150691; c=relaxed/simple;
	bh=iSU0FjK1UxdzM8KapK1bkQdaA4sjtOVFjueVDl4wyVc=;
	h=Date:To:From:Subject:Message-Id; b=NQlkW5OTH/lA27SFEwCtxoLSy525C5ZgIBCzbGJ/ZTJiwKIyW6HFffVWDZ/Gs1WxI8hEJSmt/YzEYDvCITlTXY3cyYP9NX9yfh2NGInV5z02VlzvSetbQyEOHQZJzdJciukoKICq/crB6peXYfO1J2tSVivWNeK+DExGAegfiBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnQWgStl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnQWgStl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438CFC2BCB3;
	Sat, 25 Apr 2026 20:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777150691;
	bh=iSU0FjK1UxdzM8KapK1bkQdaA4sjtOVFjueVDl4wyVc=;
	h=Date:To:From:Subject:From;
	b=SnQWgStlVEMvcN7NTDXTtEKrA3EB7T529k2FqCVMMlq2i0q+xkC7YxYVg9h4oCldL
	 KROlXgSWv+v7RTSqYleve5TWde94ng0PQMq6mE6ng2Rct4tN+lizIjFZA7/L/r9xq0
	 xehvQD3Jy/+7kM4mjD+5gIwGVAw5nKMYcC49nOiE=
Date: Sat, 25 Apr 2026 13:58:10 -0700
To: mm-commits@vger.kernel.org,msalter@redhat.com,david.laight.linux@gmail.com,chmh0624@gmail.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch added to mm-new branch
Message-Id: <20260425205811.438CFC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/asm-generic/fixmap.h: reimplement nasty macros in C
has been added to the -mm mm-new branch.  Its filename is
     include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/asm-generic/fixmap.h: reimplement nasty macros in C
Date: Sat Apr 25 01:42:28 PM PDT 2026

Min-Hsun Chang reports[1] "the macro __set_fixmap_offset() uses a
hardcoded identifier ________addr, which can lead to variable name
shadowing if a caller happens to use the same name in its scope."

As is usual with macro messes, the answer is to reimplement everything in
C.

Reported-by: Min-Hsun Chang <chmh0624@gmail.com>
Closes: https://lore.kernel.org/20260307092119.20733-1-chmh0624@gmail.com [1]
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h |   34 ++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/include/asm-generic/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c
+++ a/include/asm-generic/fixmap.h
@@ -71,25 +71,33 @@ static inline unsigned long virt_to_fix(
 #endif
 
 /* Return a pointer with offset calculated */
-#define __set_fixmap_offset(idx, phys, flags)				\
-({									\
-	unsigned long ________addr;					\
-	__set_fixmap(idx, phys, flags);					\
-	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
-	________addr;							\
-})
+static inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
+{
+	__set_fixmap(idx, phys, flags);
+	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
+}
 
-#define set_fixmap_offset(idx, phys) \
-	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
+static inline unsigned long
+set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
+{
+	return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
+}
 
 /*
  * Some hardware wants to get fixmapped without caching.
  */
-#define set_fixmap_nocache(idx, phys) \
-	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE)
+static inline void
+set_fixmap_nocache(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
+}
 
-#define set_fixmap_offset_nocache(idx, phys) \
-	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE)
+static inline void
+set_fixmap_offset_nocache(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
+}
 
 /*
  * Some fixmaps are for IO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
proc-rewrite-next_tgid-fix.patch

