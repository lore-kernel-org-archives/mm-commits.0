Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD34FB666
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647195; cv=none; b=ZpdgTMYyTH1dMp3VVRDpeYd0dV+AMxuuqqceAEImAfs0PXHLRlIuhExM8ClVQm2IVoTTVb2uWnwbHWXh+BK12fRdeJUCGg/ls/f6lYMWJCH4TlnKWN306A5wPhoNuNjvW0spBMQLSglSszIgGd9ckXOcMlTcOW/4GiT6oduoVkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647195; c=relaxed/simple;
	bh=HBET7j2nBtUTUs45LiV+NPagu/3g9nj8u9X8wKFy8Fk=;
	h=Date:To:From:Subject:Message-Id; b=cOTDIGesudE+kHYaBuDNYJvgrehODFW7TpMMxjqTLJR+vL3E5X05gwrmBp8YR2pAHDmioDalpvhdbTVtXX2rVULgAj5M76u5+iykCYxD+eTvZu69ApbP51R6RDvX5nWN2LnXUNeX8VXrMYwJ6D9KfGDCrSxPzFKxHBqmxl06YU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGtw38K0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGtw38K0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E384C4CEDD;
	Thu,  3 Apr 2025 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743647194;
	bh=HBET7j2nBtUTUs45LiV+NPagu/3g9nj8u9X8wKFy8Fk=;
	h=Date:To:From:Subject:From;
	b=RGtw38K0hfjLpS17u8sXpch5jz8PdRUf8AIn+jjHQ4+kkHOOK52rxzLTvzIvJcFRI
	 T37GngD1J8WWEhqRQxU1Per4foRObjjpnXm4N5sI/TS0E2v6wRUTrvnIq/zrA17nc7
	 myukqjLhZy0NatsGuT6io0fLVWesXRGzhIYpNoL4=
Date: Wed, 02 Apr 2025 19:26:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,ravi.bangoria@amd.com,peterz@infradead.org,mingo@kernel.org,mcgrof@kernel.org,liam.howlett@oracle.com,da.gomez@samsung.com,da.gomez@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-add-missing-cleanuph-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403022634.4E384C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: radix-tree-add-missing-cleanuph-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-add-missing-cleanuph-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-add-missing-cleanuph-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: radix-tree-add-missing-cleanuph-fix
Date: Wed Apr  2 07:24:02 PM PDT 2025

remove unneeded header guards, per Sidhartha

Cc: Daniel Gomez <da.gomez@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

radix-tree-add-missing-cleanuph-fix.patch

