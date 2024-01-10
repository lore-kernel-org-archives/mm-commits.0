Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8299BD50F;
	Wed, 10 Jan 2024 05:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yKqjvfFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371E8C433C7;
	Wed, 10 Jan 2024 05:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704863681;
	bh=dK+2BCkz89Badvs2b1qCjazOJ5HsZ6cKpZSR0uByXEc=;
	h=Date:To:From:Subject:From;
	b=yKqjvfFur8z+htKxOvxr0r7rox6bOa+M16J4qjQbV/Y6pxaFbaU32PAXSlns7Vgsl
	 XWv00quQD1/19WgviYORuTKdpzTUrCIZovM1CCy0DBeNW/YU+wdOcqqnB5/PK4LPig
	 /wbqYMRgFcvgNdvnsZKk7qyY2xmCIWnSFXHgqD3o=
Date: Tue, 09 Jan 2024 21:14:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + efi-disable-mirror-feature-during-crashkernel.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110051441.371E8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: efi: disable mirror feature during crashkernel
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     efi-disable-mirror-feature-during-crashkernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/efi-disable-mirror-feature-during-crashkernel.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: efi: disable mirror feature during crashkernel
Date: Tue, 9 Jan 2024 12:15:36 +0800

If the system has no mirrored memory or uses crashkernel.high while
kernelcore=mirror is enabled on the command line then during crashkernel,
there will be limited mirrored memory and this usually leads to OOM.

To solve this problem, disable the mirror feature during crashkernel.

Link: https://lkml.kernel.org/r/20240109041536.3903042-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/mm_init.c~efi-disable-mirror-feature-during-crashkernel
+++ a/mm/mm_init.c
@@ -26,6 +26,7 @@
 #include <linux/pgtable.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -381,6 +382,11 @@ static void __init find_zone_movable_pfn
 			goto out;
 		}
 
+		if (is_kdump_kernel()) {
+			pr_warn("The system is under kdump, ignore kernelcore=mirror.\n");
+			goto out;
+		}
+
 		for_each_mem_region(r) {
 			if (memblock_is_mirror(r))
 				continue;
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

efi-disable-mirror-feature-during-crashkernel.patch

