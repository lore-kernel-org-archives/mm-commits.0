Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8824BA53
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417606; cv=none; b=AefsRU6z0zgNGSbwQumGlJ1SmQa96uR7Qbwpn9YK97seGYJ115MdJwz+cXL2CvhIeSF9jP7LGvV4qNpQPP6G8lNOPt1HrjkcBhoKH0tsG/Vp9eyvegAliEQf0Izt8ivz9laB+pZZlZej3oOXpgJDHP75ix5SUzfe+M/eyBtuOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417606; c=relaxed/simple;
	bh=7aW4EoW59BD9Kvlg3ez6EPj9LypfrHxogEj0u9FO6fE=;
	h=Date:To:From:Subject:Message-Id; b=JMTQ0APonjuX2k7PEsgVjAODIpU01k63VBbKD2oNSaYFA8cyYEEtmWci4VRLi95+e/490MnG7AbO9SLDQLxQkHigBSz9Oa3uEEgqzh6CSfSKWaz5+0tLvukI9FOIb4VJWZPS5sy7SwjKoHpiOeToOOUI9nPrJ0kF5D44iOokcJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PdZwoeqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PdZwoeqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142C2C4CEE2;
	Sat, 12 Apr 2025 00:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417605;
	bh=7aW4EoW59BD9Kvlg3ez6EPj9LypfrHxogEj0u9FO6fE=;
	h=Date:To:From:Subject:From;
	b=PdZwoeqqOMj3Rdfsfbj3KSqABcwluFdniFUZg1X/i8eESUsIyNAFqWHo2hs66y3wI
	 n+fdLGSH68cyjvtsfZIw3vg0UvEP/ZymbkxZX6Ihv4c59P9Zr7Ot1LjN2JGe5zOXVr
	 TJp77GdxxfZgQ9xDbewT4UGeySiPkcyQjWCg+7kg=
Date: Fri, 11 Apr 2025 17:26:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,ravi.bangoria@amd.com,peterz@infradead.org,mingo@kernel.org,mcgrof@kernel.org,liam.howlett@oracle.com,da.gomez@samsung.com,da.gomez@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] radix-tree-add-missing-cleanuph-fix.patch removed from -mm tree
Message-Id: <20250412002645.142C2C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix-tree-add-missing-cleanuph-fix
has been removed from the -mm tree.  Its filename was
     radix-tree-add-missing-cleanuph-fix.patch

This patch was dropped because it was folded into radix-tree-add-missing-cleanuph.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: radix-tree-add-missing-cleanuph-fix
Date: Wed Apr  2 07:24:02 PM PDT 2025

remove unneeded header guards, per Sidhartha

Cc: Daniel Gomez <da.gomez@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/cleanup.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/testing/shared/linux/cleanup.h~radix-tree-add-missing-cleanuph-fix
+++ a/tools/testing/shared/linux/cleanup.h
@@ -1,7 +1,2 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _TEST_CLEANUP_H
-#define _TEST_CLEANUP_H
-
 #include "../../../../include/linux/cleanup.h"
-
-#endif /* _TEST_CLEANUP_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

