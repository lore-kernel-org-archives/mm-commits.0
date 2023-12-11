Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A97493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qiRT3IPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997DCC433C7;
	Mon, 11 Dec 2023 01:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257795;
	bh=MeOZfXBCxLRUwYVSSUxajGBGlRZi/YP3N5lQDCfXPSQ=;
	h=Date:To:From:Subject:From;
	b=qiRT3IPZ95K+IAv/ykj4l7EqX/EaQ5t2ixPvBxVrhYoI4jJhK/n4v1z0VpxvtjBhN
	 IBIU+9MRoVInQX0MrilGTB1bTxJiisrVyqb/kJROe5jXrde475UHeqKOFDUCEBnbTU
	 O9JRFD49mAI74DYuhfbX3xAelqc2eD2QgMTrOEMo=
Date: Sun, 10 Dec 2023 17:23:15 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-vm_fault-include-asm-vm_faulth-for-prototypes.patch removed from -mm tree
Message-Id: <20231211012315.997DCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: vm_fault: include asm/vm_fault.h for prototypes
has been removed from the -mm tree.  Its filename was
     hexagon-vm_fault-include-asm-vm_faulth-for-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vm_fault: include asm/vm_fault.h for prototypes
Date: Thu, 30 Nov 2023 15:58:19 -0700

Clang warns:

  arch/hexagon/mm/vm_fault.c:157:6: warning: no previous prototype for function 'read_protection_fault' [-Wmissing-prototypes]
    157 | void read_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:157:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    157 | void read_protection_fault(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/mm/vm_fault.c:164:6: warning: no previous prototype for function 'write_protection_fault' [-Wmissing-prototypes]
    164 | void write_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:164:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    164 | void write_protection_fault(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/mm/vm_fault.c:171:6: warning: no previous prototype for function 'execute_protection_fault' [-Wmissing-prototypes]
    171 | void execute_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:171:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    171 | void execute_protection_fault(struct pt_regs *regs)
        | ^
        | static

The prototypes for these functions are defined in asm/vm_fault.h, so
include it to pick them up and silence the warnings.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-6-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/vm_fault.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/mm/vm_fault.c~hexagon-vm_fault-include-asm-vm_faulth-for-prototypes
+++ a/arch/hexagon/mm/vm_fault.c
@@ -12,6 +12,7 @@
  */
 
 #include <asm/traps.h>
+#include <asm/vm_fault.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

