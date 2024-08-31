Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483501D12F1
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725064015; cv=none; b=iZGNiSbDPW5mhUwoVf00y8QU/3mya7BcoCWlbW+5upoC4VGsff51ggnxCd0R3ePBlEfHmq0K4HWkUFbE45AIilXA0KwTcvTE5BcwdiVg2p58A7eI++zDU6Da867FYExgZh4XLs+zfeSBI7kmahpJgY624rD4PS2j419SG358DzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725064015; c=relaxed/simple;
	bh=t3NfKfLfsjYj+06MKSLTPmWtqNojadgca1CH/fL5Bg0=;
	h=Date:To:From:Subject:Message-Id; b=miRebcZjp3ifkdjcFgDNS3yZiNuN1LZHPn4A1HQ48ByZC5yYr0/5YKgjgL0PTLBkq2b2iPHO1AAfHBauEevd9UrHcsJtcXgPk9unXCfhTaKUzFognY4hzMD687nl0hZ4PsqJkT2vlVy+YzeaZFKjRSzMKW59oFex0vTrkTAuBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jUI/+9jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jUI/+9jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4102C4CEC2;
	Sat, 31 Aug 2024 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725064015;
	bh=t3NfKfLfsjYj+06MKSLTPmWtqNojadgca1CH/fL5Bg0=;
	h=Date:To:From:Subject:From;
	b=jUI/+9jXdklu6CAXPOEg4P914jpr5vxtjnsMBomkac/hNJOuT7RCQ7qtyi9mI7Mq4
	 7BQSp09jTXpJt6geawlE0TqyWQ8myQmL07ENrqYXozsurA8drBqvgsRuO1yE3jL+Lg
	 JObF05YNXBZS8ZUbvkUzT89SgPfBOluP8dusjjH0=
Date: Fri, 30 Aug 2024 17:26:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-convert-to-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240831002654.E4102C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: convert to folio_isolate_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-convert-to-folio_isolate_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-convert-to-folio_isolate_movable.patch

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
Subject: mm: compaction: convert to folio_isolate_movable()
Date: Thu, 29 Aug 2024 22:54:55 +0800

Directly use folio_isolate_movable() in isolate_migratepages_block().

Link: https://lkml.kernel.org/r/20240829145456.2591719-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-convert-to-folio_isolate_movable
+++ a/mm/compaction.c
@@ -1100,7 +1100,7 @@ isolate_migratepages_block(struct compac
 					locked = NULL;
 				}
 
-				if (isolate_movable_page(&folio->page, mode)) {
+				if (folio_isolate_movable(folio, mode)) {
 					folio_put(folio);
 					goto isolate_success;
 				}
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

