Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72B97493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xd4frKhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04EBC433C9;
	Mon, 11 Dec 2023 01:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257792;
	bh=CdruC8dnGVclgviPYu4CcnOZEYDt92pt0dUBKgygZo4=;
	h=Date:To:From:Subject:From;
	b=Xd4frKhqivauMHo3zszy5Bk944pgkG0slcar05YtAJrd5Sz4571pkDeBVmGC2vuQq
	 epfNO+e0kZKMHJqVHkki7/Zdz+U1k3O4fQWSnRM441tug4WIWVfwX2XVLVQhHKcOeE
	 WSF+tpD60B1VMVx5EurFVo/aLZrC9KJHC7EjnDs8=
Date: Sun, 10 Dec 2023 17:23:12 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-mm-include-asm-setuph-for-setup_arch_memorys-prototype.patch removed from -mm tree
Message-Id: <20231211012312.B04EBC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: mm: include asm/setup.h for setup_arch_memory()'s prototype
has been removed from the -mm tree.  Its filename was
     hexagon-mm-include-asm-setuph-for-setup_arch_memorys-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: mm: include asm/setup.h for setup_arch_memory()'s prototype
Date: Thu, 30 Nov 2023 15:58:16 -0700

Clang warns:

  arch/hexagon/mm/init.c:138:13: warning: no previous prototype for function 'setup_arch_memory' [-Wmissing-prototypes]
    138 | void __init setup_arch_memory(void)
        |             ^
  arch/hexagon/mm/init.c:138:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    138 | void __init setup_arch_memory(void)
        | ^
        | static

The prototype is in asm/setup.h, include it to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-3-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/mm/init.c~hexagon-mm-include-asm-setuph-for-setup_arch_memorys-prototype
+++ a/arch/hexagon/mm/init.c
@@ -12,6 +12,7 @@
 #include <linux/highmem.h>
 #include <asm/tlb.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/vm_mmu.h>
 
 /*
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

