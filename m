Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E2130594F
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308387; cv=none; b=LTqOpelRM+w++VTNNxDJQA8ub0ZoZtXfogtA1uDu8ymF9c0DiJ8tzu4gwffokGWX8syDJKsTe56Qw9ZzisntEAlYIWQXm863i2pTtshRavBgaJE0ebO7jfCvOjGCEOKgkDSONqs1cq9mS6WW5n7pSqK7YBBSBVw3H+EH8ZgOcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308387; c=relaxed/simple;
	bh=8PJksq1DN0zY5W7hEdFIezlkfIjHSzb0V3TmX6c0vQ4=;
	h=Date:To:From:Subject:Message-Id; b=k0OqUGeQ1Ip8XZblWuiLVMxAfs9JhadeZyYygBcgA/CsPCbl5z3CF7bzNaBtOZscVAfi/0+TgqL69u0uIb1moEXysbenCYGQsTQbhUEnyr3yo+6iNr8IKV/NluvoEbqH4LA+mIhJwusDs+HmuAfbRE77eVdcbMignHVQ/ARyaJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Az8huLUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Az8huLUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622C3C4CEF5;
	Tue,  9 Dec 2025 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308386;
	bh=8PJksq1DN0zY5W7hEdFIezlkfIjHSzb0V3TmX6c0vQ4=;
	h=Date:To:From:Subject:From;
	b=Az8huLUqMr4noWzTssU4c1zL3biYo2HqVMJmrWmB1mxT7omAgQVJyqwUjTx29IzsV
	 5CJlkXOAdUUsGHgFF2wLXufYohmJbuwRy45+m7tsxWf2EvJL4IJzcYoU8yNxytGDoX
	 GBWnUpPq/azX1r8asUyWzmHaFAhkx4Ko0kcgFsFo=
Date: Tue, 09 Dec 2025 11:26:25 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-folio-split-stats-counting.patch removed from -mm tree
Message-Id: <20251209192626.622C3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix folio split stats counting
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-folio-split-stats-counting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix folio split stats counting
Date: Wed, 26 Nov 2025 16:06:18 -0500

The "return <error code>" statements for error checks at the beginning of
__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
the end of the function.  Fix these by replacing them with "ret = <error
code>; goto out;".

Link: https://lkml.kernel.org/r/20251126210618.1971206-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio-split-stats-counting
+++ a/mm/huge_memory.c
@@ -3942,16 +3942,20 @@ static int __folio_split(struct folio *f
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (new_order >= old_order)
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		return ret;
+		goto out;
 	}
 
 	if (is_anon) {
_

Patches currently in -mm which might be from ziy@nvidia.com are


