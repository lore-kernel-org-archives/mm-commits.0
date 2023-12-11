Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF647493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gxFy2d6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A905CC433C8;
	Mon, 11 Dec 2023 01:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257797;
	bh=SjtC0Tgl6sL7KR9sNuDaHWiZTQAQZp5sZd9UEVENyW0=;
	h=Date:To:From:Subject:From;
	b=gxFy2d6ZO8xCKh0p6XnCQgsuUyHDJkKART2jrtjc32ve0O+Xm3XahxNFBgy7XXZZ4
	 I+0n2coDWFKaa6PtXA2saJMS6trUra516iDQY/PpOMBlZgZ4qq5BizLmM36H+BXi9B
	 ob31msdgByrNGcGneKJg+sxrs/N0wgjepyGcQydo=
Date: Sun, 10 Dec 2023 17:23:17 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-time-include-asm-timeh-for-prototypes.patch removed from -mm tree
Message-Id: <20231211012317.A905CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: time: include asm/time.h for prototypes
has been removed from the -mm tree.  Its filename was
     hexagon-time-include-asm-timeh-for-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: time: include asm/time.h for prototypes
Date: Thu, 30 Nov 2023 15:58:21 -0700

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/time.c:118:6: warning: no previous prototype for function 'setup_percpu_clockdev' [-Wmissing-prototypes]
    118 | void setup_percpu_clockdev(void)
        |      ^
  arch/hexagon/kernel/time.c:118:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    118 | void setup_percpu_clockdev(void)
        | ^
        | static
  arch/hexagon/kernel/time.c:135:6: warning: no previous prototype for function 'ipi_timer' [-Wmissing-prototypes]
    135 | void ipi_timer(void)
        |      ^
  arch/hexagon/kernel/time.c:135:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    135 | void ipi_timer(void)
        | ^
        | static

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-8-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/time.c~hexagon-time-include-asm-timeh-for-prototypes
+++ a/arch/hexagon/kernel/time.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 
 #include <asm/hexagon_vm.h>
+#include <asm/time.h>
 
 #define TIMER_ENABLE		BIT(0)
 
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

