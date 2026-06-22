Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672B31326A;
	Mon, 22 Jun 2026 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782147933; cv=none; b=EaAi0k+XgKKyzQroZYuhAn07bxBJQtLhGbfnkmgOTQ3as3XoEwOoInxrl1jR4e4iSFmmwMmqgWOfd6V3q3ArKcllknpsOJk5N5v/lgnkS9q54Npu+KnvPVMJAnLfLgn+n0bJ2OQygEvbvnJsTGfygP+yDmeT79xNbmM4tM2iUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782147933; c=relaxed/simple;
	bh=jqwYCpLupMQPrXMQoJMwt33kyxypwk6469wvnGadTE8=;
	h=Date:To:From:Subject:Message-Id; b=u+z1Ond3DqbivuWBdGkKZACc4fGE2hjv96t2WrvF47iRddP7ruqFA98p6slRr6tpVqSpwIEF8Y/y2aByyhV9PAXgfKoSGIsq7+l19GNnWAXgiZp/qDSXOwKX8Nl3MLuPGN7JWQDTbUfp+uk6sPue9r6FcoUujdIlr8T/tWFaMgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cgQnItSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cgQnItSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D891F000E9;
	Mon, 22 Jun 2026 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782147931;
	bh=pOrVFAm99gvh4cWAzHDQ8dVva5Kqq1rhR8W056gB/xU=;
	h=Date:To:From:Subject;
	b=cgQnItSb13MKBJ1VQ7dKzA30h4FMoHxblpLxOn0DWqJNEOqLXM2roEb5U4BuKgifJ
	 CQygJBOXCud35IUphDTC70Qshco5UsaULDGPzJ4oTCgP0POL/mb5xYeeE1Mmd3DEnd
	 WAdlnqX3M2H2fkQ+f03PqUKZyjjt/orr8wouE/5c=
Date: Mon, 22 Jun 2026 10:05:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jiaqiyan@google.com,jackmanb@google.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch added to mm-hotfixes-unstable branch
Message-Id: <20260622170531.92D891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: handle free_pages_prepare() properly in compaction_free()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: handle free_pages_prepare() properly in compaction_free()
Date: Mon, 22 Jun 2026 11:30:42 -0400

free_pages_prepare() can fail but compaction_free() does not handle the
failure case.  Failed pages should not be added back to cc->freepages for
future use, since they can be either PageHWPoison or free_page_is_bad()
and might cause data corruption.

Link: https://lore.kernel.org/20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com
Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-handle-free_pages_prepare-properly-in-compaction_free
+++ a/mm/compaction.c
@@ -1875,15 +1875,14 @@ static void compaction_free(struct folio
 	int order = folio_order(dst);
 	struct page *page = &dst->page;
 
-	if (folio_put_testzero(dst)) {
-		free_pages_prepare(page, order);
+	if (folio_put_testzero(dst) && free_pages_prepare(page, order)) {
 		list_add(&dst->lru, &cc->freepages[order]);
 		cc->nr_freepages += 1 << order;
 	}
 	cc->nr_migratepages += 1 << order;
 	/*
-	 * someone else has referenced the page, we cannot take it back to our
-	 * free list.
+	 * someone else has referenced the page or free_pages_prepare() fails,
+	 * we cannot take it back to our free list.
 	 */
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch

