Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820533009DE
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960439; cv=none; b=JUI3MXbZI1KWpjBDzW0oEQsAOL6r/l2kgFJbBi0ngg6OulcCyFUfLqKO6r/hl48RMm9dD+f3+bw9ZXgzUTSMrfJL0MfKsTef+mL/J3O4nUmZ8jeALqJOXg0dHviqb/eshSXG3ibL2zzpFp+oIz2HxzpKHEupcpGPpmcmbXkoqCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960439; c=relaxed/simple;
	bh=ElX2oRgSh+70eSt/ElGDvF0TFTDY9Afdt4+HDFWf7aI=;
	h=Date:To:From:Subject:Message-Id; b=o/QvB9aaJJR6LohhSvo6wy8kK7+D5O99Hl9u/691lkDUapxUqxll0Sbrc5AICJW56XlmMPtaQEIGWcia+t5l9KpZdf05IPP6MCu0o1YlAz5MFKaMYVELTHw3+12qtED0RZ6muViWPs0qBMFvnq0YWktnBUvYKw1g0CAAqOGlIu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iPVbQc7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iPVbQc7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2453CC19422;
	Tue, 24 Feb 2026 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960439;
	bh=ElX2oRgSh+70eSt/ElGDvF0TFTDY9Afdt4+HDFWf7aI=;
	h=Date:To:From:Subject:From;
	b=iPVbQc7Qi4PTNTK8r2IwA4RGzB/iEabsXsIoV383XwDO85NUvpWK+No57VxyGqTkO
	 UnAJ/gsgrjIupMiNkRmD2e3ypuFwDjgWu7YuBepJvnr4HfgS+JTPtuVIe3OO+L380a
	 7W6YN03EnICxeU0koiEclabZtJdWqb3Ts7wKw7iI=
Date: Tue, 24 Feb 2026 11:13:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ast@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch removed from -mm tree
Message-Id: <20260224191359.2453CC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change vma_alloc_folio_noprof() macro to inline function
has been removed from the -mm tree.  Its filename was
     mm-change-vma_alloc_folio_noprof-macro-to-inline-function.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -339,8 +339,11 @@ static inline struct folio *folio_alloc_
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

mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

