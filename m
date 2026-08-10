Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C35D346AE8;
	Mon, 10 Aug 2026 22:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401471; cv=none; b=CUPKoro/WDpl/d0U8Sbt/m6foO54kPJ8ZtcFxZZ/k9tcevSyY2walowxpuQ/eWTzrna0OigmojN0TLDq3NgFVzOGhxObFvSo5bUmPwVGsz91y3IloDZAaOb+FQL2GJJ+Hc//+4sJ+OxTxAZt/iUI2ezYLIZ0CT0QMh3+STlTkCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401471; c=relaxed/simple;
	bh=A+s2iLx81WzsdXsT4rm1vrlEL8ObAD72I6gMQ8gxNUs=;
	h=Date:To:From:Subject:Message-Id; b=J/ycWo3YQSHcFQchJkADA9ZxdIOJhzHHpaZTDzwRavaBwmKWAMLChMpUhIDkN6j+nYapuT09bJr8YFJ2+KXy8reqjku6ymoPjgrtYgA+nJuwe/4uIFkJLSowy+bjosVr5X/0m9pH/2QZrcbtOBDKRKfPCeMf93aReZAuNtFPwZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qvu2MzkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qvu2MzkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D851A1F000E9;
	Mon, 10 Aug 2026 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786401470;
	bh=+tF+MgWT3SEa8TMaVAxXkcKdpPvkE5rjXcIBxD2GGC0=;
	h=Date:To:From:Subject;
	b=Qvu2MzkYj/ceEkAJJQRyYSV/fXhqC5ioLu9XQ2tqufVbfa+rC3xFlGsvdgXOtn8+V
	 LZo9vOBlSTpIzk3AokP9hXbKFBMJc66bk1SOYe92l1kPj3wIHVqJW7Q0bIZNuxb44r
	 YDOeoVALOsxvwXy20okKGxuQpiI0eDQMnV9CxfDY=
Date: Mon, 10 Aug 2026 15:37:49 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch added to mm-hotfixes-unstable branch
Message-Id: <20260810223749.D851A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch

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
From: Sourav Panda <souravpanda@google.com>
Subject: mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
Date: Sun, 9 Aug 2026 04:32:50 +0000

Changes in v5:
- Replaced defaulting nodemask to &node_states[N_MEMORY] with safely reading
  cpuset_current_mems_allowed using a seqcount retry loop, ensuring fallback
  allocations comply with task hardwall cpusets as suggested by Usama Arif.

Link: https://lore.kernel.org/20260809043250.2917406-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5
+++ a/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,12 +31,21 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	nodemask_t local_node_mask;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (!nodemask)
-		nodemask = &node_states[N_MEMORY];
+	if (!nodemask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nodemask = &local_node_mask;
+	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch
mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

