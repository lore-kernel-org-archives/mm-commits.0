Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74FFAD4A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zKeb6TaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC980C433C9;
	Mon, 11 Dec 2023 01:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257799;
	bh=yt4wWtz/TiCyvz2YSK/S1F9ZToCI+mYMzxoxzzgjqrc=;
	h=Date:To:From:Subject:From;
	b=zKeb6TaL1JFrT5M7prBtb8gpNuIhHD4k8eSiuqMT1H1Du/nt1FppnQNMjgPqMeqjo
	 sTokyFmjzaRglCK2/GKEqwmLbOfRrAj/dqP01LfOpH9FGfuENbqCt/ppDTrcqLZcSt
	 GNK5bNJogTOrHyrCOd/p8Ymew4JlhnMBEW95hF5Y=
Date: Sun, 10 Dec 2023 17:23:19 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-time-include-asm-delayh-for-prototypes.patch removed from -mm tree
Message-Id: <20231211012319.AC980C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: time: include asm/delay.h for prototypes
has been removed from the -mm tree.  Its filename was
     hexagon-time-include-asm-delayh-for-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: time: include asm/delay.h for prototypes
Date: Thu, 30 Nov 2023 15:58:23 -0700

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/time.c:209:6: warning: no previous prototype for function '__delay' [-Wmissing-prototypes]
    209 | void __delay(unsigned long cycles)
        |      ^
  arch/hexagon/kernel/time.c:209:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    209 | void __delay(unsigned long cycles)
        | ^
        | static
  arch/hexagon/kernel/time.c:224:6: warning: no previous prototype for function '__udelay' [-Wmissing-prototypes]
    224 | void __udelay(unsigned long usecs)
        |      ^
  arch/hexagon/kernel/time.c:224:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    224 | void __udelay(unsigned long usecs)
        | ^
        | static

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-10-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/time.c~hexagon-time-include-asm-delayh-for-prototypes
+++ a/arch/hexagon/kernel/time.c
@@ -17,6 +17,7 @@
 #include <linux/of_irq.h>
 #include <linux/module.h>
 
+#include <asm/delay.h>
 #include <asm/hexagon_vm.h>
 #include <asm/time.h>
 
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

