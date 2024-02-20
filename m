Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778BF153506;
	Tue, 20 Feb 2024 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467751; cv=none; b=AchgZs7Dx8xOIWSIcfZU64cJ8MnAnneuyl0mA9CsP3Zyx44G4Tu1WOmwy/S/bRGpEcCQWpdvg/n/Q+c26gQU0nysivLPjDAg93wCgOjkCFZz1EOeT814WNrYrRensqNAwl/UtNTRyaz8XqLn7WcrsbuL+YsnmipHoUS2YwromqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467751; c=relaxed/simple;
	bh=H9z9SSPiFgMUErNgLfjRxWmuACCEEUlZdg+SKxndks0=;
	h=Date:To:From:Subject:Message-Id; b=eIQg59xtlxuHS3E2KpDr6HcGog9cfyT7PmreVZ94hNr+VPm6AUarkIAS6IciL79E2nZfh0wHtHap8uxbjdmqO2xp+kyDK3sG6oqeScWX61k2VC7oc+mf+Tt6zBxrXbdshsUuw7bJOz2jLiuPl6JQFek7a/RIJa36wDHS324lX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzpJ1J3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzpJ1J3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10246C433C7;
	Tue, 20 Feb 2024 22:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467751;
	bh=H9z9SSPiFgMUErNgLfjRxWmuACCEEUlZdg+SKxndks0=;
	h=Date:To:From:Subject:From;
	b=AzpJ1J3Nk9yOwjhkj5GbymQTlGgppFCHc+WxaMKtf9Or9aghGCNNEQVMvo8uPlg5Z
	 x/eqzNN9whwBlwhkHDyqA3X9WhvRtEbIXcOXLsp6w5xFu+Mt/NmmYZ00yg5e3svphC
	 iNU9PIUsglZh7ZW06nIaKd504WYfZ53/U06MT2Q0=
Date: Tue, 20 Feb 2024 14:22:30 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch removed from -mm tree
Message-Id: <20240220222231.10246C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memblock: add MEMBLOCK_RSRV_NOINIT into flagname[] array
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memblock: add MEMBLOCK_RSRV_NOINIT into flagname[] array
Date: Fri, 9 Feb 2024 08:39:12 +0530

The commit 77e6c43e137c ("memblock: introduce MEMBLOCK_RSRV_NOINIT flag")
skipped adding this newly introduced memblock flag into flagname[] array,
thus preventing a correct memblock flags output for applicable memblock
regions.

Link: https://lkml.kernel.org/r/20240209030912.1382251-1-anshuman.khandual@arm.com
Fixes: 77e6c43e137c ("memblock: introduce MEMBLOCK_RSRV_NOINIT flag")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memblock.c~mm-memblock-add-memblock_rsrv_noinit-into-flagname-array
+++ a/mm/memblock.c
@@ -2249,6 +2249,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
 	[ilog2(MEMBLOCK_NOMAP)] = "NOMAP",
 	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
+	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch
mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

