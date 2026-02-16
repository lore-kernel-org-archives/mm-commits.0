Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175C320C490
	for <mm-commits@vger.kernel.org>; Mon, 16 Feb 2026 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771278479; cv=none; b=DElgfuokkoowqUID4hpQ1vgHbrm4DC43likmCtg80aWZ6271ZsTxOQ+yrft3L93kVbeonn59gkW+fYGU+za9pbz7EnkFcjvPCMJePDfbwHTkOENYNNhiHXlZcnxuzAWvY87/0Wu35XESVvO51/e+g4XZHYRg9ybWdWEfnqmC2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771278479; c=relaxed/simple;
	bh=0crOq3zrafpdgwRpdWlaNm1188DtbNhBl6Shc3fcpOg=;
	h=Date:To:From:Subject:Message-Id; b=lGdItbMcH+v0LZH6eftEFaD1SZMwu0EzQHGcd7TCgPw4Qo0OOLjMUIUzjYkiD2WOzHP2f0CyYNodhzPbBqVSFyjjFXIsLtjdEBWKGDZW0B2n7BHTHNhm1aOulUSzSfmwgbQKwkf6iksmFKFxGqsIsbJW1qLVpr10UsOIdL+2v2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOkoOPb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOkoOPb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87E6C116C6;
	Mon, 16 Feb 2026 21:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771278478;
	bh=0crOq3zrafpdgwRpdWlaNm1188DtbNhBl6Shc3fcpOg=;
	h=Date:To:From:Subject:From;
	b=YOkoOPb0e7B8u/bVnNtOuUEazGesHOeHuRF3lpvQtIhI0oP6ffReTaG1Ba/S88LxZ
	 v1HCyaiXNVALRQZtJgJ5BqukYmoSWwYVoaDdKOL8HRc9dygDk9LLyfH+g268oKOt6T
	 vyZDKLWfgZX8GEDaEBH5pnZZiuMmWGBXUurIVCxE=
Date: Mon, 16 Feb 2026 13:47:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ast@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch added to mm-hotfixes-unstable branch
Message-Id: <20260216214758.C87E6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change vma_alloc_folio_noprof() macro to inline function
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: change vma_alloc_folio_noprof() macro to inline function
Date: Mon, 16 Feb 2026 13:17:44 +0100

In a few rare configurations with extra warnings eanbled, the new
drm_pagemap_migrate_populate_ram_pfn() calls vma_alloc_folio_noprof() but
that does not use all the arguments, leading to a harmless warning:

drivers/gpu/drm/drm_pagemap.c: In function 'drm_pagemap_migrate_populate_ram_pfn':
drivers/gpu/drm/drm_pagemap.c:701:63: error: parameter 'addr' set but not used [-Werror=unused-but-set-parameter=]
  701 |                                                 unsigned long addr)
      |                                                 ~~~~~~~~~~~~~~^~~~

Replace the macro with an inline function so the compiler can see how the
argument would be used, but is still able to optimize out the assignments.

Link: https://lkml.kernel.org/r/20260216121751.2378374-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-change-vma_alloc_folio_noprof-macro-to-inline-function
+++ a/include/linux/gfp.h
@@ -335,8 +335,11 @@ static inline struct folio *folio_alloc_
 {
 	return folio_alloc_noprof(gfp, order);
 }
-#define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
-	folio_alloc_noprof(gfp, order)
+static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return folio_alloc_noprof(gfp, order);
+}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

