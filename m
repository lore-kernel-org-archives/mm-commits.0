Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADA312B169
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577527; cv=none; b=nQ7obFirQB7LSb0hpb5BCd+PPr983hb0IrS+MoK54kZ4f0RZwNNu1VBrmYn/XeppMkobQFOJUxYt+kk2jT9ZI9KEz1/DLgKnorrUCERu3zgabJ/rcY+iWvWY6V4266WMM6tOP25mU19gw+SQGNFiKTnH5JRZhFpMAf72hVn47qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577527; c=relaxed/simple;
	bh=OrDLomIOagIMUvcu47U9lLPPPUjQYclnTt2QegGhivY=;
	h=Date:To:From:Subject:Message-Id; b=uyVXfaz/SxZ36lp6Hyhu4qa7bt3csPHxsKkXHgjC74Ctm5PwRb4bLbLKnnYcnIqJYbk9dtEvQBzWwAbiovRoDhBkghzBLQ3t0v81CLA3c0YQP553v8vvo1VXXedMX4EBEyzcc3/tdr13zQQ81nNDDxigLpX6rsubgvvsAMSfq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUdCO4SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUdCO4SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47A4C4CECD;
	Thu, 19 Dec 2024 03:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577526;
	bh=OrDLomIOagIMUvcu47U9lLPPPUjQYclnTt2QegGhivY=;
	h=Date:To:From:Subject:From;
	b=nUdCO4SGkj+EbPi2p9Xw5sU5iMD3tzv23xszjYMTudeM87TKf336uS78m7ZxDW+ca
	 lm/RnbBtruY2OvX47mptfDSCEPXhmCDC+QqXlUrp/F+HgTxw1jmxPlvKA3dQZkyT30
	 e+yq8UXE2UjC1/3VsSRN+jbyyUJqQeDCHwDADKI0=
Date: Wed, 18 Dec 2024 19:05:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,vgupta@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,mathieu.desnoyers@efficios.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,geert+renesas@glider.be,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] introduce-cpu_icache_is_aliasing-across-all-architectures.patch removed from -mm tree
Message-Id: <20241219030526.B47A4C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce cpu_icache_is_aliasing() across all architectures
has been removed from the -mm tree.  Its filename was
     introduce-cpu_icache_is_aliasing-across-all-architectures.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: introduce cpu_icache_is_aliasing() across all architectures
Date: Mon, 9 Dec 2024 13:23:25 -0500

In commit eacd0e950dc2 ("ARC: [mm] Lazy D-cache flush (non aliasing
VIPT)"), arc adds the need to flush dcache to make icache see the code
page change.  This also requires special handling for
clear_user_(high)page().  Introduce cpu_icache_is_aliasing() to make MM
code query special clear_user_(high)page() easier.  This will be used by
the following commit.

Link: https://lkml.kernel.org/r/20241209182326.2955963-1-ziy@nvidia.com
Fixes: 5708d96da20b ("mm: avoid zeroing user movable page twice with init_on_alloc=1")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig                 |    1 +
 arch/arc/include/asm/cachetype.h |    8 ++++++++
 include/linux/cacheinfo.h        |    6 ++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arc/include/asm/cachetype.h a/arch/arc/include/asm/cachetype.h
new file mode 100644
--- /dev/null
+++ a/arch/arc/include/asm/cachetype.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ARC_CACHETYPE_H
+#define __ASM_ARC_CACHETYPE_H
+
+#define cpu_dcache_is_aliasing()	false
+#define cpu_icache_is_aliasing()	true
+
+#endif
--- a/arch/arc/Kconfig~introduce-cpu_icache_is_aliasing-across-all-architectures
+++ a/arch/arc/Kconfig
@@ -6,6 +6,7 @@
 config ARC
 	def_bool y
 	select ARC_TIMERS
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_PREP_COHERENT
--- a/include/linux/cacheinfo.h~introduce-cpu_icache_is_aliasing-across-all-architectures
+++ a/include/linux/cacheinfo.h
@@ -155,8 +155,14 @@ static inline int get_cpu_cacheinfo_id(i
 
 #ifndef CONFIG_ARCH_HAS_CPU_CACHE_ALIASING
 #define cpu_dcache_is_aliasing()	false
+#define cpu_icache_is_aliasing()	cpu_dcache_is_aliasing()
 #else
 #include <asm/cachetype.h>
+
+#ifndef cpu_icache_is_aliasing
+#define cpu_icache_is_aliasing()	cpu_dcache_is_aliasing()
+#endif
+
 #endif
 
 #endif /* _LINUX_CACHEINFO_H */
_

Patches currently in -mm which might be from ziy@nvidia.com are


