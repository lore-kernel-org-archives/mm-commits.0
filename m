Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BDEC0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 03:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233197; cv=none; b=P5t7eqc/G0CpYFH5sde3T4TcBwsFbaYRiIR5HEljZoZTi6h6jYNpwxZTPRNiyP+GzXzE6FUL90QuQLCHr+h5Bny/w9md7I/TKyhu111hZRbUBA/VsNoufOnJsWDzwi+nCrRLO68F1z27Tyh452hl5fmnX90y1Xf2AYDlha0v0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233197; c=relaxed/simple;
	bh=tEZZPyFAdoTdsvvl1T/7cEv9jSQg8NHGMEBnXNPQSmg=;
	h=Date:To:From:Subject:Message-Id; b=ckCvHZo7JZhdgRaCJgiqMkcrgo2c/N+Yx7w1eZfeOVtYAJ2t6nlFrDdyW9q2WLAIrWak5MPlE9cxliVsMBbKJVvE6RY7Z94DhgdBypyH5RaVudZOpwAUXTHyORSi+Ehk/RLMQLh2j6sYE51fw1EaaiGgIq8Agmd3Yta4ftAS+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yn1DhYSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yn1DhYSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C541FC4CEE4;
	Thu,  6 Mar 2025 03:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741233196;
	bh=tEZZPyFAdoTdsvvl1T/7cEv9jSQg8NHGMEBnXNPQSmg=;
	h=Date:To:From:Subject:From;
	b=Yn1DhYSbwzvjrVQpo/oTGmB2NmHRE/rRTvDkMskK5ThF4a5voQMRBqjXViAttCXp8
	 NkuluJKMFQhuS5DSQY6sWMMmOn2FXOCo0JHHAvq0lp/f43VeuDXQHJYsW/6dWL9T3B
	 AXGOTh0d6oRC5j/6Le03NZNC4saIGGVA6Ju3EhhQ=
Date: Wed, 05 Mar 2025 19:53:16 -0800
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch removed from -mm tree
Message-Id: <20250306035316.C541FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch

This patch was dropped because it was folded into mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
Date: Wed, 19 Feb 2025 14:06:52 +0800

unmap_poisoned_folio(): remove shadowed local `mapping', per Miaohe

Link: https://lkml.kernel.org/r/20250219060653.3849083-1-mawupeng1@huawei.com
Fixes: 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
+++ a/mm/memory-failure.c
@@ -1585,8 +1585,6 @@ int unmap_poisoned_folio(struct folio *f
 	}
 
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-		struct address_space *mapping;
-
 		/*
 		 * For hugetlb folios in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch
mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch
hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch

