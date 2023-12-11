Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E08AD4A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+0tW5dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8B8C433C7;
	Mon, 11 Dec 2023 01:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257801;
	bh=VRV8DgaOKGFX7VmIoDbMMks7vfqBQObdvD0//s7sxDw=;
	h=Date:To:From:Subject:From;
	b=L+0tW5dWwmeRGFGw0Z4jBBqPGFQmKUQpf1ZEZbalF1lTPYRUvm6TLPYkuvxT3/j8H
	 o0Ww0qfUt3gQmmX6+Bt15bvIAUiKJZFYCGe/YL7cSldOmHP4MNV3qWXA9LW6pBHktL
	 7pb8wc57mbDcIvYXiuNq7gTHFAM5pSAVsiocd3iM=
Date: Sun, 10 Dec 2023 17:23:21 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-reset-include-linux-rebooth-for-prototypes.patch removed from -mm tree
Message-Id: <20231211012321.9F8B8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: reset: include linux/reboot.h for prototypes
has been removed from the -mm tree.  Its filename was
     hexagon-reset-include-linux-rebooth-for-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: reset: include linux/reboot.h for prototypes
Date: Thu, 30 Nov 2023 15:58:25 -0700

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/reset.c:9:6: warning: no previous prototype for function 'machine_power_off' [-Wmissing-prototypes]
      9 | void machine_power_off(void)
        |      ^
  arch/hexagon/kernel/reset.c:9:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      9 | void machine_power_off(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:15:6: warning: no previous prototype for function 'machine_halt' [-Wmissing-prototypes]
     15 | void machine_halt(void)
        |      ^
  arch/hexagon/kernel/reset.c:15:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     15 | void machine_halt(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:19:6: warning: no previous prototype for function 'machine_restart' [-Wmissing-prototypes]
     19 | void machine_restart(char *cmd)
        |      ^
  arch/hexagon/kernel/reset.c:19:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     19 | void machine_restart(char *cmd)
        | ^
        | static
  3 warnings generated.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-12-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/reset.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/reset.c~hexagon-reset-include-linux-rebooth-for-prototypes
+++ a/arch/hexagon/kernel/reset.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/reboot.h>
 #include <linux/smp.h>
 #include <asm/hexagon_vm.h>
 
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

