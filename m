Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E02C0F67
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 22:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162648; cv=none; b=I/+3man8jvqzDrx3fMknhhl36SRpq/GnnzZVIBT3/CKjpjmrD3ZCOScYTQX+g3HTeDTesxzhPEFjD6CUO9QBsCZS6CxZtA7M3v+I4ppVXmCiZcKdoS46cP+gUgdCdQp7Pw6ElUb/AZNcY+d1u5Tn3mbGM6PDaC4ru0V6wTxQaJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162648; c=relaxed/simple;
	bh=HxRU1GDFK0RSl37HKNox+i2L981IEdWesAsp2fCEj9E=;
	h=Date:To:From:Subject:Message-Id; b=If/LDx/HqBczb9VS8Kj3rl0Ex7BVwdKC0XGBgh6XyO1K3MRc4/xpK63beUaD3yZmT91q3KghPxZIn8rBw+jQT3bN+9xF13ZoqC/TUfWf/iIMTsDzy7NAKv081DNpBvHJVsL/WPa8RDJjadZ0CjSqCKPQkSU+z1u2BZh1QvM0UEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LhB8QF0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LhB8QF0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355E7C4CEF4;
	Mon, 25 Aug 2025 22:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756162648;
	bh=HxRU1GDFK0RSl37HKNox+i2L981IEdWesAsp2fCEj9E=;
	h=Date:To:From:Subject:From;
	b=LhB8QF0Rbb/uwfqx8aDdveKhYHQF/20u5CgGyw7env8tRIuneRcl0BqgPt06VKvDf
	 LGFfyzKgigiv/D3X8mt9LCViajgZUrAJmy9VCcuWvx5wcz4lw5FTcJyyKaxMEIhgnf
	 YqvQHsTVzomWf81EagfSeAulF/Ch0TUAre3314LY=
Date: Mon, 25 Aug 2025 15:57:27 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix.patch added to mm-unstable branch
Message-Id: <20250825225728.355E7C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: use do_div() on i386 for damon_pa_migrate() return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: use do_div() on i386 for damon_pa_migrate() return value
Date: Mon, 25 Aug 2025 07:46:24 -0700

Otherwise, __udivdi3 linking issue happens on certain configs.

Link: https://lkml.kernel.org/r/20250825151513.36488-1-sj@kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix
+++ a/mm/damon/paddr.c
@@ -274,7 +274,7 @@ put_folio:
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE / addr_unit;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

