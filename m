Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F224A24
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 06:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733551228; cv=none; b=OWpzfy2dXnzU3tjrj2aUGv7zcYs+BxZaCKt/0l+rjaPmgUZ0lrqarVFZEnww0thApmjJyXVhSXcDFUW0povc88Qt59l7/HKz2gIPATICpD6+hrhDBrhPcL2UtEyx1Qe3WqCNojudkftvkv0r7ZVBL/8FytXHHhKudyIk0OLKloE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733551228; c=relaxed/simple;
	bh=3rzVusNNDRxhtJ1blcLXE5opT50L0PBVP3c889IlsA4=;
	h=Date:To:From:Subject:Message-Id; b=mmnJ9OmVUnuAelc/r8yT0aQsZjYXPfeHGkr4YT8hzCYYtyN1hGIyNcKqrs2Pd6lOykO9jDtnhGiFdPIpvbfwuPS3wC3fwok+aZOVTvhupe+44nO7JU+ia/CzAZpiaaRMSiH4BwwtWGv0opkoW+K9VPIKQVKCZRQ9l4h/ZQeNX/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BK/RmpI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BK/RmpI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F66C4CECD;
	Sat,  7 Dec 2024 06:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733551227;
	bh=3rzVusNNDRxhtJ1blcLXE5opT50L0PBVP3c889IlsA4=;
	h=Date:To:From:Subject:From;
	b=BK/RmpI1U5b7n+y0uY3zOlHrJc9zzYXbpQnRDpG2bXjDHEqTkwKgINq1481n1qxxm
	 IqQ0+VONtwUoO8B9XMcljRiUnHwTjmvaAdVduh7lz8tE+B1ulBxwtMZcTDqa4ECLZf
	 minRSHn0s/NFrpjlxxc2pkVtOp4E/gTL6kArIgpU=
Date: Fri, 06 Dec 2024 22:00:26 -0800
To: mm-commits@vger.kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicyh-remove-unnecessary-header-file-inclusions.patch added to mm-unstable branch
Message-Id: <20241207060027.99F66C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy.h: Remove unnecessary header file inclusions
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicyh-remove-unnecessary-header-file-inclusions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicyh-remove-unnecessary-header-file-inclusions.patch

This patch will later appear in the mm-unstable branch at
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
From: Junjie Fu <fujunjie1@qq.com>
Subject: mempolicy.h: Remove unnecessary header file inclusions
Date: Fri, 6 Dec 2024 23:53:49 +0800

Originally, linux/mempolicy.h included linux/pagemap.h because
vma_migratable() was implemented inline within the header, requiring
mapping_gfp_mask() function to implement vma_migratable().  Now that
vma_migratable() is only declared in linux/mempolicy.h and its
implementation has been moved to mempolicy.c, the inclusion of
linux/pagemap.h in the header is no longer necessary.

Additionally, since mempolicy.c includes internal.h, and internal.h
already includes linux/pagemap.h, so there is no need to modify
mempolicy.c after removing the direct inclusion of linux/pagemap.h from
linux/mempolicy.h

Link: https://lkml.kernel.org/r/tencent_08B979048FE091821B290B18AE97E70DC507@qq.com
Signed-off-by: Junjie Fu <fujunjie1@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mempolicy.h~mempolicyh-remove-unnecessary-header-file-inclusions
+++ a/include/linux/mempolicy.h
@@ -12,7 +12,6 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
-#include <linux/pagemap.h>
 #include <uapi/linux/mempolicy.h>
 
 struct mm_struct;
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mempolicyh-remove-unnecessary-header-file-inclusions.patch

