Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1037493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qqUIrZ7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F43C433CA;
	Mon, 11 Dec 2023 01:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257804;
	bh=rHPNPmiawTkmeEbYNO6FgUvP0haUmunj/cWen5cEhRI=;
	h=Date:To:From:Subject:From;
	b=qqUIrZ7L0JXlZQkEVVnr/PPetZj5bVNf9rP2skDDOsl1/kxczd98VFw2dq7TqLQSv
	 1m40N5Jp9f8rRZkH00SgnmXuFN9aDNXguLbH1O5q/4OHl2Kbyyi0k5dWy7oncLWJvq
	 9mz5+2oFMBylr1D2fKr+Fl1lIqtKz3KtKXqP45J0=
Date: Sun, 10 Dec 2023 17:23:24 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch removed from -mm tree
Message-Id: <20231211012324.94F43C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: vdso: include asm/elf.h for arch_setup_additional_pages() prototype
has been removed from the -mm tree.  Its filename was
     hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vdso: include asm/elf.h for arch_setup_additional_pages() prototype
Date: Thu, 30 Nov 2023 15:58:28 -0700

Clang warns:

  arch/hexagon/kernel/vdso.c:49:5: warning: no previous prototype for function 'arch_setup_additional_pages' [-Wmissing-prototypes]
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        |     ^
  arch/hexagon/kernel/vdso.c:49:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        | ^
        | static
  1 warning generated.

Include the header that declares the prototype to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-15-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vdso.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/vdso.c~hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype
+++ a/arch/hexagon/kernel/vdso.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/binfmts.h>
 
+#include <asm/elf.h>
 #include <asm/vdso.h>
 
 static struct page *vdso_page;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

