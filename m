Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFC98488
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801737; cv=none; b=JABzwBjeAab9JX5y0OJZZIXAXQb3kiVits3F6IjeZl9VJhWuwWDI0WjKBGnT1N8YZhwcHz34YNBMLn/CXXSVDuCAEWZV5gaUq2BI5LzGjECN0MokX9cu/Vd5aE0dRk4fm+HM/4XgMKGn67ZSV6bxlSDie1z3cCGa9ZeOQ0nJfww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801737; c=relaxed/simple;
	bh=fB6WaOuIUcDs6bgquFEcvVWEF1TY4TQEMvn2Jf9DE60=;
	h=Date:To:From:Subject:Message-Id; b=f0xSn190wc3oHOhkDYSN7aEAr4ebQRbcniA1IzikzPRdaxPUDKrOjBvXt7ybp+6OOIDm2qY28Ewt7D/QZx65b6ihbhtkJFC3RWMK5lY7XQP+HUlNtluSM23XZQG3LPvAiBLmzjo7W9O0u0hCYAQy5+kBwPH/8olgdrltOoFembs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xk60YrPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xk60YrPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF96C4CEEB;
	Sat, 13 Sep 2025 22:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801737;
	bh=fB6WaOuIUcDs6bgquFEcvVWEF1TY4TQEMvn2Jf9DE60=;
	h=Date:To:From:Subject:From;
	b=Xk60YrPC/cf4T1VmOPM6J+4+fjmm236JrnOE4mX6JYeKru3Dnz2K4H7XpFDOPsz+s
	 4lSokEKtRHRE43HvutDJoVNbo+8FyZRbQcXDTU3X4ufxLYnUEuuW2VXaAeIQ+9gQyv
	 GpOK7J5EaJO3WKrM6XokIVycI5gsishtqeCey3SA=
Date: Sat, 13 Sep 2025 15:15:36 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch removed from -mm tree
Message-Id: <20250913221537.3BF96C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: mark zswap_stored_incompressible_pages as static
has been removed from the -mm tree.  Its filename was
     mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch

This patch was dropped because it was folded into mm-zswap-store-page_size-compression-failed-page-as-is.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: mark zswap_stored_incompressible_pages as static
Date: Thu, 21 Aug 2025 09:10:57 -0700

Only zswap.c uses zswap_stored_incompressible_pages, but it is not marked
as static.  This incurs a sparse warning that reported by kernel teset
robot.  Mark it as a static variable to eliminate the warning.

Link: https://lkml.kernel.org/r/20250821161750.78192-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-store-page_size-compression-failed-page-as-is-fix
+++ a/mm/zswap.c
@@ -45,7 +45,7 @@
 /* The number of pages currently stored in zswap */
 atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 /* The number of incompressible pages currently stored in zswap */
-atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

