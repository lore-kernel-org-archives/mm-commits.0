Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5660E5B201;
	Tue, 16 Apr 2024 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307029; cv=none; b=ed94OtU/Nfv6X06kCoxuy2l1L6svwY6ot2LRLMhenFr2Jyoe3s1bFywml4UksUxjhqSUn93ffUUY8Cjwj7GC2rC3muuvhbnSXQCQUtgYle7qmqzyNAJPgnCLFVGgxkAoISUp5c0l4mFkafRV92tfnxkP+0tO9KIlwvPooWTukLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307029; c=relaxed/simple;
	bh=8piIvp9DwY5D3LMxYx9Eb0JCpljZa8FUJNxPELh98As=;
	h=Date:To:From:Subject:Message-Id; b=kbP+RJws+84fDnG+rUPrCFk7eaD4JcdClaw1zpFmbEqs7FX5QIgdJ/xtKkd33hA2f8OfNVqLz8eJIVNBJ/+Zb1Q3v3sVbC0LkxA8OaKXfSMi271Lp++CKMxhRl3IPg2+7vGtfFTLF8PJw5eHvJAhUpVaXfkink8E09O+P8luFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uqpi3CQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uqpi3CQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91612C113CE;
	Tue, 16 Apr 2024 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307028;
	bh=8piIvp9DwY5D3LMxYx9Eb0JCpljZa8FUJNxPELh98As=;
	h=Date:To:From:Subject:From;
	b=Uqpi3CQpENTTnt6FxIMfecvBxGaYKiHs82LNr75ylo7Alhp1Nb6PL680CmYJksvpf
	 Fzt+JhCifCXkv37HjHeLtj6ww9ghQu9TdeLlHUvV3MEZMZ9ocKZpHe/EBdmml96gxm
	 c86Deh/awnZRddookMBpurd70t8E3fg6sv2haRME=
Date: Tue, 16 Apr 2024 15:37:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch removed from -mm tree
Message-Id: <20240416223708.91612C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch

This patch was dropped because it was folded into mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
Date: Fri, 12 Apr 2024 10:57:54 +0800

extend comment per Oscar

Link: https://lkml.kernel.org/r/20240412025754.1897615-1-linmiaohe@huawei.com
Fixes: a6b40850c442 ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2
+++ a/mm/memory-failure.c
@@ -159,6 +159,10 @@ static int __page_handle_poison(struct p
 	 * dissolve_free_huge_page() might hold cpu_hotplug_lock via static_key_slow_dec()
 	 * when hugetlb vmemmap optimization is enabled. This will break current lock
 	 * dependency chain and leads to deadlock.
+	 * Disabling pcp before dissolving the page was a deterministic approach because
+	 * we made sure that those pages cannot end up in any PCP list. Draining PCP lists
+	 * expels those pages to the buddy system, but nothing guarantees that those pages
+	 * do not get back to a PCP queue if we need to refill those.
 	 */
 	ret = dissolve_free_huge_page(page);
 	if (!ret) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch
fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch

