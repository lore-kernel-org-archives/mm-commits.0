Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300CE29E11D
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801297; cv=none; b=d99rFIfQcirn/qeBBGVjiUeCzjtb6dM28LKjy5/Uffd2KuT7bxBLsxLJRbW65V/xjVSwvlJGvIwPmb8O3yNe/zkIV+9yBfkHgOc2MK2LkAJ6W2MOPOGzuNGKV7BmX/hwXPhm10SJ3NWIfG7DAs8SM4wEfOM4ZdbAPG3d0Rmc2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801297; c=relaxed/simple;
	bh=vYsylEz3bzgwkJvtPcgo87VDBzat98AppN8FioXsX4w=;
	h=Date:To:From:Subject:Message-Id; b=TmbO7ua1y3P+M78rC/r42yMWaYP7Za8itPEs0sDDABg/8VrDV64NzNkzdZ7VvcrbYyly3f2k74dKpcmgN93zs72KVxecEbHZFZkK9uNjLjZnlflSmL0fXa+YOennVYiJcZV50lRtqR96wLQpmLHT2+VmbH23yW5+T2dfGE1W9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UdNz59m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UdNz59m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A032C4CEEB;
	Sat, 13 Sep 2025 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801294;
	bh=vYsylEz3bzgwkJvtPcgo87VDBzat98AppN8FioXsX4w=;
	h=Date:To:From:Subject:From;
	b=1UdNz59mbl+f/eTjNfEEoOTLIfObAtTSeA/tqnyBRSMRKH+/rsTN1H4rAc746I096
	 pPPzAvjLeFUQvvhcke6IyGdiUlvPuoynfOlZ+ngEtyBWxL12pasg21dMraiOcizJ4P
	 SZtPSNHGAyFLvtSfZcsdcmYAhMM1wUQ/ibvfxauc=
Date: Sat, 13 Sep 2025 15:08:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch removed from -mm tree
Message-Id: <20250913220814.9A032C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch

This patch was dropped because it was folded into mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
Date: Tue Aug 26 04:06:31 PM PDT 2025

don't include mm.h due to include file ordering mess

Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/arcregs.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,8 +146,6 @@
 
 #ifndef __ASSEMBLER__
 
-#include <linux/mm.h>
-
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

