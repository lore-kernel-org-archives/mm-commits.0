Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7809179CF
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746685914; cv=none; b=hIdqFkmZAGneta9hzI5JMmcWKxuOcDGn1Ed6Ws7toefcQow69UOYjRAq9uG3/UDO435IeZMJDfcted6iswk7LzyeO2i1+ykPRpoZJL1CTsWvp4c8p97DcKdJ1OqNdZR1gwblNLlpGA/iB4p0GiBga0sJjNKaIi3la0peyloWvz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746685914; c=relaxed/simple;
	bh=jDGeAO7CPR6pMP833xjbsAVh11f0ji8CsFN3aC+Ec4I=;
	h=Date:To:From:Subject:Message-Id; b=uxm9zv9BTrMVTLYPwZpHAWTY/aXhmgR1Xz9tQOBBHFkyN3QX66XXo3iBXPhVgfLGe109PZ5el4tVec9t0S2ZlNZPOU/wBYOEyQrLmon7eQq8C3KA2xXqZa1sKCalVI2lbpvBnGu1bWVwKSoqVLkkfCzdm2GtnWKwHvMEMN/QnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGbg500W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGbg500W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D095CC4CEEB;
	Thu,  8 May 2025 06:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746685913;
	bh=jDGeAO7CPR6pMP833xjbsAVh11f0ji8CsFN3aC+Ec4I=;
	h=Date:To:From:Subject:From;
	b=GGbg500WlrtmQotsuMa4ua9Te/GBkuXznDqM5ST7ZjhlRzvGXG4rH52JsmoJa4aA1
	 SAXrJENj3/sMqRLgR2y8gKIL2TtYIffiXaVDAVFFPYmWZn1XAyx0QjkNZbC6xIZXQk
	 IOe75nP/zmviB6xuj6Q+2T8y3khgP6Z9C2Ukgyn8=
Date: Wed, 07 May 2025 23:31:53 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,linux@roeck-us.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-disable-image-size-check-for-test-builds-fix-fix.patch removed from -mm tree
Message-Id: <20250508063153.D095CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86-disable-image-size-check-for-test-builds-fix-fix
has been removed from the -mm tree.  Its filename was
     x86-disable-image-size-check-for-test-builds-fix-fix.patch

This patch was dropped because it was folded into x86-disable-image-size-check-for-test-builds.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-disable-image-size-check-for-test-builds-fix-fix
Date: Sat Apr 19 01:54:50 PM PDT 2025

fix comment snafu

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504191813.4r9H6Glt-lkp@intel.com/
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds-fix-fix
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -473,7 +473,6 @@ SECTIONS
  */
 #ifndef CONFIG_COMPILE_TEST
 /*
-/*
  * The ASSERT() sync to . is intentional, for binutils 2.14 compatibility:
  */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-config_page_block_order-to-select-page-block-order-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

