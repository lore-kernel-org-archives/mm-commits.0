Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2AC38399;
	Fri,  9 Feb 2024 22:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517181; cv=none; b=cVhYnCdFGhCDrFL4GWtJM2cZLqUgd0no9qLYJDlGzyTVfJxXHLB3WSUWOGsU+4AAbvjYPUUKdiYrMzism6ylZOldBy3H16yBDLgM8UQ5gi8g3RpAhSW5ee/emFVCwys7wrtk4fxnFzyLd27nnXAu8PM+orlqVaouVipNSiksNrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517181; c=relaxed/simple;
	bh=a1NkKkTQKYqsJtZR77HF+fqLudSDQRWiNX3VppJ0R7o=;
	h=Date:To:From:Subject:Message-Id; b=hEweyRx/NMwK1RVtA5rp7lrUMCh/CX5NoBop4KTEPRRZEPweHHRCYDckei5sJ5Pu3qOhjYnBr6c2iDh/NLAqx6d47r5SntrqpPX1zny0PidYejle6fgNZtJLcUBXw6RPc7wc0X9PrOrz2Szu6YsdI4jr4EaTdu4AEA2J1rHBjl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CuvlNSiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CuvlNSiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1785C433F1;
	Fri,  9 Feb 2024 22:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707517180;
	bh=a1NkKkTQKYqsJtZR77HF+fqLudSDQRWiNX3VppJ0R7o=;
	h=Date:To:From:Subject:From;
	b=CuvlNSiOVwqFYuGTOg7kpGEXjyRa+K7/FtmL9QlUrILsnIg/OTZoW4edaGhN161um
	 Ta8Tz3BbEvOLhJU90/dfLzIUO/4DW7NY/Yq9M9R/lgx/7dkdSyAj8mPbf899E1mDRH
	 bts24/zUkB0ZMCuqgi/6Jx5B4dOwwEEIwy1Cwpq8=
Date: Fri, 09 Feb 2024 14:19:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch added to mm-hotfixes-unstable branch
Message-Id: <20240209221940.D1785C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memblock: add MEMBLOCK_RSRV_NOINIT into flagname[] array
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Mike Rapoport <rppt@kernel.org>
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

fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch
mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch

