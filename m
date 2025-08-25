Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B32D060B
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162750; cv=none; b=XHRFfy8WOhAayPjywCynl+mZV+Ulpy9oy+D/M5OqDzsOicJWIKbPADgQ0UzjVJ/CtxGbPQtHuraEu6OxAU+0xW2+d5t8GsEiatuAS4jA9mHSvr+l5DZ07H6kpDUc59fAxMVksGC7yNpOLc8Zxy59xvhxhOsY9wSpK2oc0/m9/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162750; c=relaxed/simple;
	bh=wPdBWg3OpLVkuhePR/tyQl1lM7XA0am28CCxJeqkLKk=;
	h=Date:To:From:Subject:Message-Id; b=T+wIj0+2h9eLZgxPBP9q6H6DMC4wWTi/nLD3chb48gXamsBVfRndR4VSlhRzIZkFZMssJJoYCC9WxR4KwmtUmqEX0MGdT3k7o3qqQYRZOicropGOjre0IiaqunicnnzTYk/ov+rP9kFEzPTh0NMx4Ejw+7Dzk1iTEEdX4AJYhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pAv7KcyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pAv7KcyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1915FC4CEED;
	Mon, 25 Aug 2025 22:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756162750;
	bh=wPdBWg3OpLVkuhePR/tyQl1lM7XA0am28CCxJeqkLKk=;
	h=Date:To:From:Subject:From;
	b=pAv7KcyY/igysi9rd8fznmvHPKn2tFB7qbi1HP7m9oGIp12A+LGFbRpBTb4akI4tZ
	 wAawT5ZcLcjx0x4TqKqWukFox6yFZsqDsXemlR3t8JdTgYgX+qsLchY5khaYBzbJzJ
	 Os1WrP/mMU/tqO5wCX3w1813p32Vzh0ZHAXEQGu8=
Date: Mon, 25 Aug 2025 15:59:09 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-damos_pageout-fix.patch added to mm-unstable branch
Message-Id: <20250825225910.1915FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: use do_div() on i386 for damon_pa_pageout() return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-damos_pageout-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-damos_pageout-fix.patch

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
Subject: mm/damon/paddr: use do_div() on i386 for damon_pa_pageout() return value
Date: Mon, 25 Aug 2025 07:41:33 -0700

Otherwise, __udidi3 linking problem happens on certain configs.

Link: https://lkml.kernel.org/r/20250825151205.36288-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-damos_pageout-fix
+++ a/mm/damon/paddr.c
@@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio
 	return false;
 }
 
+/* convert physical address to core-layer address */
+static unsigned long damon_pa_core_addr(phys_addr_t pa,
+		unsigned long addr_unit)
+{
+#ifdef __i386__
+	do_div(pa, addr_unit);
+	return pa;
+#else
+	return pa / addr_unit;
+#endif
+}
+
 static unsigned long damon_pa_pageout(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
@@ -190,7 +202,7 @@ put_folio:
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE / addr_unit;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout-fix.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold-fix.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

