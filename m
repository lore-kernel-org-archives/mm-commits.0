Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1282D24A1
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 22:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086822; cv=none; b=EI1JBRZ3mOHWU6/eaFqV9cXNIYNWcsKpEVJd7A54T9iI4ugaNl4dm5b89XdirYZV2Bf4tH0/jCCFLObWfKv3hMt130VxqkqLmSJ99Gtky+6o8LbyNHooJQAdt55WCOrFRFP7bYc6D6t/R8tiZFZ95vzQ4Og7IaaYci+X2kMGvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086822; c=relaxed/simple;
	bh=TqqwglinxKBkKFh/xzCQrxFNG9L6wLb2l4SqUx3ov+c=;
	h=Date:To:From:Subject:Message-Id; b=j7n3e+VpCaMiu/MsFiBOelwRH3UTIZ2GfoUJogZQGJyX4/cpMB3CZz0o2HfxMIaOfKH7+awbMcUTXHbVU6XCTfJNbUF/Rz6t0JVjR46OuI/MAh8xvaN+Y3KtdXy2JInRSeyl2yNvI9saZOOL+w5tkjqW0scj6IVd/PbS1/CVpcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtpyjyOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtpyjyOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91179C4CEF1;
	Tue, 21 Oct 2025 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086821;
	bh=TqqwglinxKBkKFh/xzCQrxFNG9L6wLb2l4SqUx3ov+c=;
	h=Date:To:From:Subject:From;
	b=AtpyjyOa2wbD5ktCneJjp9NPVXIjvWCc8MslpFyCntuI8MJFjK/bQSV8b6Oj2hTjM
	 ErDk9eh2zVuTy/4wTul6Nf5OvHypQt7oiHaN+o5YOKrth17d2TxBvhm+IKG7JeOXg7
	 58V5FjtousB70TEQcygjA53oUB6PpXtyhiNaTdTE=
Date: Tue, 21 Oct 2025 15:47:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,rppt@kernel.org,guoren@kernel.org,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] csky-abiv2-adapt-to-new-folio-flags-field.patch removed from -mm tree
Message-Id: <20251021224701.91179C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: csky: abiv2: adapt to new folio flags field
has been removed from the -mm tree.  Its filename was
     csky-abiv2-adapt-to-new-folio-flags-field.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: csky: abiv2: adapt to new folio flags field
Date: Mon, 6 Oct 2025 14:13:37 +0200

Recent changes require the raw folio flags to be accessed via ".f".  The
merge commit introducing this change adapted most architecture code but
forgot the csky abiv2.

[rppt@kernel.org: add fix for arch/csky/abiv2/cacheflush.c]
Link: https://lkml.kernel.org/r/aPCE238oxAB9QcZa@kernel.org
Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv2/cacheflush.c         |    2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/csky/abiv2/cacheflush.c~csky-abiv2-adapt-to-new-folio-flags-field
+++ a/arch/csky/abiv2/cacheflush.c
@@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fa
 
 	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		return;
 
 	icache_inv_range(address, address + nr*PAGE_SIZE);
--- a/arch/csky/abiv2/inc/abi/cacheflush.h~csky-abiv2-adapt-to-new-folio-flags-field
+++ a/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -20,8 +20,8 @@
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

mempool-clarify-behavior-of-mempool_alloc_preallocated.patch
compiler-remove-arch_sel.patch

