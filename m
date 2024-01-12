Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73F818EA9;
	Fri, 12 Jan 2024 23:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kQ1Vnf0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FC1C43390;
	Fri, 12 Jan 2024 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101700;
	bh=CL0+m1ce15RbHJ4296qLAHkVhWphfRZ5Y2AWW9XAFn8=;
	h=Date:To:From:Subject:From;
	b=kQ1Vnf0cPGTdgyQSIiR4ZYhCCfJdV2d77Jtax/AVUxNTa8mThdZ3gu8taJm7jv18k
	 htSywIPzhsl1WPLogI07nD+9/k53acMjPMBg4VBREzxqKAmAdDn9x2w/h9h+GhIttr
	 wnMoDcea5K87zL9RefbejsIzGlmv43w6dOAN/KCg=
Date: Fri, 12 Jan 2024 15:21:39 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] efi-disable-mirror-feature-during-crashkernel.patch removed from -mm tree
Message-Id: <20240112232140.72FC1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: efi: disable mirror feature during crashkernel
has been removed from the -mm tree.  Its filename was
     efi-disable-mirror-feature-during-crashkernel.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


