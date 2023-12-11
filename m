Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE37493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AU5zM45N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A834DC433C7;
	Mon, 11 Dec 2023 01:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257802;
	bh=ysWL7Ut5SCsLR1NaosI6hW92U83+1nPFZk5RUs6puAQ=;
	h=Date:To:From:Subject:From;
	b=AU5zM45NIXDzxtfqjcEUsuWzBfnMj0qGDn4WtHbDOzhO7D9eb8vn5fcQ6tHcnNdxf
	 KmSiNwMB1yr6PC13gyvIARabssnSqvlpd3Ah6rhsAZGYpwLd0yezsVxPXuh5kR6fqS
	 q9Ji/Fo+7o7qNXSyay3686cGnC405ZxvM/gUEuSA=
Date: Sun, 10 Dec 2023 17:23:22 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-process-include-linux-cpuh-for-arch_cpu_idle-prototype.patch removed from -mm tree
Message-Id: <20231211012322.A834DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: process: include linux/cpu.h for arch_cpu_idle() prototype
has been removed from the -mm tree.  Its filename was
     hexagon-process-include-linux-cpuh-for-arch_cpu_idle-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: process: include linux/cpu.h for arch_cpu_idle() prototype
Date: Thu, 30 Nov 2023 15:58:26 -0700

Clang warns:

  arch/hexagon/kernel/process.c:43:6: warning: no previous prototype for function 'arch_cpu_idle' [-Wmissing-prototypes]
     43 | void arch_cpu_idle(void)
        |      ^
  arch/hexagon/kernel/process.c:43:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     43 | void arch_cpu_idle(void)
        | ^
        | static

This prototype is declared in include/linux/cpu.h, include it in
process.c to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-13-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/process.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/process.c~hexagon-process-include-linux-cpuh-for-arch_cpu_idle-prototype
+++ a/arch/hexagon/kernel/process.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/cpu.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task.h>
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

