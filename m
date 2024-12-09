Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6671F5F6
	for <mm-commits@vger.kernel.org>; Mon,  9 Dec 2024 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706766; cv=none; b=SzioQns8gJUOTrqrHzCldlz3PquiK6Kh6vawqTENSeyN7HMrby6P3zGm6f4YwqGviJkAGxx6hw2ApcDVSDCyps43yfr5wtJl+972Msj0i0o89sH/ME96dfD93XbG37QGUXg+MSDNeqtfycBzAxVcM9fjWPVZt+nK8+8wyod9NFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706766; c=relaxed/simple;
	bh=ylEONhRE+QBQiXOOqT5WWJkbHVxu/OvTFtBQtIgzKkM=;
	h=Date:To:From:Subject:Message-Id; b=SNngJhBvuPucKRhWGDyppmEOpjQ3XC2gxupUtpujjEns/OUuL2gUNhZ6tNu3BrxSXtAmH9S/dUIbFOr4RKQdpSjvBesdcl+Ld60TaJUEAIOstygtI/yIgEP+F/X8vKIVtk/qEV692hjRD+7RMa8XMMQB/gjnGGKEMjpYhLyw+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMjIqTgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMjIqTgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFA9C4CED2;
	Mon,  9 Dec 2024 01:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733706766;
	bh=ylEONhRE+QBQiXOOqT5WWJkbHVxu/OvTFtBQtIgzKkM=;
	h=Date:To:From:Subject:From;
	b=yMjIqTgiC/BmyYBUzl8U6FrplLIZf18woTtmxSfujJEvM1fx4vlEqiaeMFNYkECBy
	 qKJ6mN3A25HsN+nWOV229eMboiVltiUOw0cySn1OF1wmXmu7O1at/kR6vZxhNBjEzw
	 aQaZ2i9TFLtHdQc4Wynml0kI1ohz3ezOFm+YzdIQ=
Date: Sun, 08 Dec 2024 17:12:45 -0800
To: mm-commits@vger.kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mempolicyh-remove-unnecessary-header-file-inclusions.patch removed from -mm tree
Message-Id: <20241209011246.0FFA9C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempolicy.h: remove unnecessary header file inclusions
has been removed from the -mm tree.  Its filename was
     mempolicyh-remove-unnecessary-header-file-inclusions.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Junjie Fu <fujunjie1@qq.com>
Subject: mempolicy.h: remove unnecessary header file inclusions
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


