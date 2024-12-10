Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39F4A04
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733795087; cv=none; b=Lxe0hye2qg79mWk4lQN4rPW0767lB/8JQYVly6GFvFD7M+tKsCbH10Ej0H1NCrBGgEWl8q/e1tWADd6p6jc+kQLb63CFfEeqgKhPiZN+ai/pZK+jjujHVxL5GcL06Pbds56Wl1qFCeeYbt/euqIFckjhPOfwemCnEEnpBQK97EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733795087; c=relaxed/simple;
	bh=gAinZMRf/Suwt7IodcmmGzrCp6mZGLVpQ871Kwau6TM=;
	h=Date:To:From:Subject:Message-Id; b=OAfdu3H0VALMyrmrfc4qIYbExN9qep6EBw451uTVtJwD3B0zZZghAdrpS8I4qf7bD1sGN4m9rlNv/OKfVkgrbLSDd2j3m8w5Tc+jVwH3HJ2Mru59vFP9epsjie+B6L9nA13wWlKZ0TpbfbmuF59DmlsB83IXpAfNZ757s+UGH/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5LbePl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5LbePl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026BEC4CED1;
	Tue, 10 Dec 2024 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733795087;
	bh=gAinZMRf/Suwt7IodcmmGzrCp6mZGLVpQ871Kwau6TM=;
	h=Date:To:From:Subject:From;
	b=b5LbePl95woQb0vfGZtmMxsp+JkmLLfsrEz0BigK37y4gqE6GBPM1elRzcfgJgCTS
	 lyNg4tloA7/ad23RNz8Qku5RQHMAeJ8y4DhREwwN6PHKz2viRMLoVB4Up0+KfHG83l
	 FKp+SS2/DV6aSwXYGu6CKchOH4pufAsPdoBZOcGc=
Date: Mon, 09 Dec 2024 17:44:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,vgupta@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,mathieu.desnoyers@efficios.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,geert+renesas@glider.be,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + introduce-cpu_icache_is_aliasing-across-all-architectures.patch added to mm-hotfixes-unstable branch
Message-Id: <20241210014447.026BEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce cpu_icache_is_aliasing() across all architectures
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     introduce-cpu_icache_is_aliasing-across-all-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/introduce-cpu_icache_is_aliasing-across-all-architectures.patch

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

introduce-cpu_icache_is_aliasing-across-all-architectures.patch
mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch

