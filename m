Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A896A7F7D1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104109; cv=none; b=utP2GWJB/VJiF1wGTkjxtadGVcgKGcrWPw7ZakNQFku6VjbcneU+rOzEvrLile5r0UX5AKXPCd19W7yekfH6QZ0h2l4PALA0+Ffe0hztMYU/kB2RWiDFR9PlAU8mEm0F/cvWhPyenqFLMWjAI83aNiSouKEBT9XNnUzH1qjWjeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104109; c=relaxed/simple;
	bh=yUS0fNnWHVXuv18EaO2WIuYskhDtVIBn8LIxEWkhsoE=;
	h=Date:To:From:Subject:Message-Id; b=QCPBZOb8ni9z6LTESxKr7UrfYscdKYNhjGjxRJp6O7xYW/FWLK7r5GL54oOygnr7N0BV2FUFa9XPq4jCuId5zpgpouLMZJYOUqEhcU8Td3lx5IrCd1v9c4pTI0/FneT5RYybgMTSkshE80Nl4zACgwPTApmBptlHSNiMhIynv3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Avjan7JK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Avjan7JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28FC113CD;
	Fri, 26 Apr 2024 04:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104109;
	bh=yUS0fNnWHVXuv18EaO2WIuYskhDtVIBn8LIxEWkhsoE=;
	h=Date:To:From:Subject:From;
	b=Avjan7JK395QgAQ53Fz5UbnKF5L58wn2+3HP5BUQ7RXREFwBtuQ5VzPRoh//rI0Hi
	 1HibMzBbZ9MnljJlrKAljy4xAfv2AQCK4N9PLKaa5A5pOkkHyIVgW5DtTiFrLpt5TM
	 I976ekw0xy0h3R7FLCPXeELaUusTEwBElEmnQUrM=
Date: Thu, 25 Apr 2024 21:01:48 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,ioworker0@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch removed from -mm tree
Message-Id: <20240426040149.7E28FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: add the missing folio_test_pmd_mappable() for THP split statistics
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: add the missing folio_test_pmd_mappable() for THP split statistics
Date: Fri, 29 Mar 2024 14:59:33 +0800

Now the mTHP can also be split or added into the deferred list, so add
folio_test_pmd_mappable() validation for PMD mapped THP, to avoid
confusion with PMD mapped THP related statistics.

[baolin.wang@linux.alibaba.com: check THP earlier in case folio is split, per Lance]
  Link: https://lkml.kernel.org/r/b99f8cb14bc85fdb6ab43721d1331cb5ebed2581.1713771041.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/a5341defeef27c9ac7b85c97f030f93e4368bbc1.1711694852.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics
+++ a/mm/huge_memory.c
@@ -2934,6 +2934,7 @@ int split_huge_page_to_list_to_order(str
 	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	bool is_thp = folio_test_pmd_mappable(folio);
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3112,7 +3113,8 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+	if (is_thp)
+		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
 
@@ -3174,7 +3176,8 @@ void deferred_split_folio(struct folio *
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(&folio->_deferred_list)) {
-		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		if (folio_test_pmd_mappable(folio))
+			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

