Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5555893
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422313; cv=none; b=CxKmsTmhsdHn4BQt9SNLD+LUj1ssym5Rxsj3Dux/oJ64IcuemVtJ6VMOTMBlWFNO2vpLBEry/3ec9chNURRMY2PWicY9P8aUmfFGnId3qXMAK0GSCcSzYeTwCrQ55hVsduFkje7vr/ZrTgrtE7/U6Nc1G4qVa4VS9zSUbRyB7UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422313; c=relaxed/simple;
	bh=3qggiWM2ZG5rzu1xxy93vdZA5Wc+tIeD2UT7uC+66D8=;
	h=Date:To:From:Subject:Message-Id; b=jCUGTVTtYTx+vDm3KfDfcwG1WT0gdnEucSXQddisnftu+Vy923pmD3MyfUztIT/0WaiuZxN/sqTZ/WIlq9nwzpkPPGfWlIc2WSSgIejAnVHaszDX+0zPEX0zwQtYc+BU6A2pIGW55mQHM1ypoVVmVYAhahzmPEAU6ys0Q7n5ofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QywVyH8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QywVyH8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5FDC4CEC3;
	Wed,  4 Sep 2024 03:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422313;
	bh=3qggiWM2ZG5rzu1xxy93vdZA5Wc+tIeD2UT7uC+66D8=;
	h=Date:To:From:Subject:From;
	b=QywVyH8FrJm9wc/BJ5ltRH+dkIpFHCMkW79ssN+8WA8HdXgWEQQHcHxyC8YQmcg+3
	 wrtOZqSdizH/RGfj1MpxbxRL8LRWDL943WDuqSNlqM52xYUGElDfEpT0ACLf1TH1DU
	 uRFuh+wpFTb1U2B2CuZsPHKgcHrpXQK8DEdb4Q+g=
Date: Tue, 03 Sep 2024 20:58:32 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-support-only-one-page_type-per-page-fix.patch removed from -mm tree
Message-Id: <20240904035832.EE5FDC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-support-only-one-page_type-per-page-fix
has been removed from the -mm tree.  Its filename was
     mm-support-only-one-page_type-per-page-fix.patch

This patch was dropped because it was folded into mm-support-only-one-page_type-per-page.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-support-only-one-page_type-per-page-fix
Date: Wed, 28 Aug 2024 11:35:28 +0800

fix ubsan warnings

UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
left shift of 240 by 24 places cannot be represented in type 'int'
...

Changing significant bit to unsigned to fix it.

Link: https://lkml.kernel.org/r/2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-support-only-one-page_type-per-page-fix
+++ a/include/linux/page-flags.h
@@ -968,7 +968,7 @@ static __always_inline void __folio_set_
 {									\
 	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
 			folio);						\
-	folio->page.page_type = PGTY_##lname << 24;			\
+	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
@@ -985,7 +985,7 @@ static __always_inline int Page##uname(c
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
-	page->page_type = PGTY_##lname << 24;				\
+	page->page_type = (unsigned int)PGTY_##lname << 24;		\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-support-only-one-page_type-per-page.patch
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

