Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D223C00
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725064013; cv=none; b=XM8I9fVQqGapyNwNMGTYZdgiph4/Yrpv/zCe3mQAJzKhHRIyJCET3YNi6Y4H+rDKhtrtFRLu616GBuMYElqQS4dF/zFjAk/tmbZzqWxNiH1tgu8k1BHQnYE1xqxvzt15pStqU2qZtcK8E0KFIdVqFmPsW7F+hlopnd1tOw5RHxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725064013; c=relaxed/simple;
	bh=ol31ohehG6JS+U0Lkq0SxNXBhQILzDUCdV6OxiJ4k3c=;
	h=Date:To:From:Subject:Message-Id; b=k7G41Gb9XSfV0dqp8B7KMSIdFyLXFSuToG45BzN1XsuuGeH9/So+7MLornHk9qlAf8IjXAGgv1B0BMUWk3DlN06E3FuthC3sGPw3OQjN/yYJBymfpfNg/L2CKshi0PSbCoLMSdS3qHAk0Rrgn3VbHauxY0n8FhXFyowt7ToPtQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLdbA7s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLdbA7s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC3C4CEC2;
	Sat, 31 Aug 2024 00:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725064013;
	bh=ol31ohehG6JS+U0Lkq0SxNXBhQILzDUCdV6OxiJ4k3c=;
	h=Date:To:From:Subject:From;
	b=HLdbA7s2ywT5b8ovbAnUSY2HFI8O5BZA2xBeMQB0+Ot0REC7zCnmq8U3qLVXcsUAv
	 //K65W/V1hJWFrogx+9oAnG4zCjk1Cn9bIB0EvqxYeWbMPeSQHm+szTzxjBNHg9bef
	 nvGWQoGkFRXxRSqGNQOSlKHcD2E1iHnvQXiFwrgA=
Date: Fri, 30 Aug 2024 17:26:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-to-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240831002653.08CC3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: convert to folio_isolate_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-to-folio_isolate_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-to-folio_isolate_movable.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: convert to folio_isolate_movable()
Date: Thu, 29 Aug 2024 22:54:54 +0800

Directly use folio_isolate_movable() in isolate_folio_to_list().

Link: https://lkml.kernel.org/r/20240829145456.2591719-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-to-folio_isolate_movable
+++ a/mm/migrate.c
@@ -196,8 +196,7 @@ bool isolate_folio_to_list(struct folio
 	if (lru)
 		isolated = folio_isolate_lru(folio);
 	else
-		isolated = isolate_movable_page(&folio->page,
-						ISOLATE_UNEVICTABLE);
+		isolated = folio_isolate_movable(folio, ISOLATE_UNEVICTABLE);
 
 	if (!isolated)
 		return false;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-support-only-one-page_type-per-page-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch
mm-migrate-add-folio_isolate_movable.patch
mm-migrate-convert-to-folio_isolate_movable.patch
mm-compaction-convert-to-folio_isolate_movable.patch
mm-migrate-remove-isolate_movable_page.patch

