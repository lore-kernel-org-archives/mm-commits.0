Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A1B30102F
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763755201; cv=none; b=osKBA4UsTGpwLsqfj5uijxjx38XmXfCsJkn4xpIkegPiWlx+gqKYgFLJ9+Iucn4ON5wc7i68DQ3ud76cq1WDUetrnGDwxYr8m6BORlWdwiiXmj9vM3RRodBm2i9WQZQkEzrhAIZYw4X/E2Nv1zRqQUOLXsrSna+j+R8Ly2nnmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763755201; c=relaxed/simple;
	bh=Wqp7Yfsab5DnblR/7+iTW8wPcnGv5AFbJe6yV/lFZLQ=;
	h=Date:To:From:Subject:Message-Id; b=VOakJr5Qp/PTuNjz174AEe4G/8WpMM6Lf0C0ejPr5tiwU5d61V0MMsFM1lFH4QwcTm8lZzcmpRxnKtj3Wvlg4KvrJHvsswglIB/rbzzmwuZuaueQsLqU8W1XxViyTPrcAEZFfiGF/WaZAzAdipGx3jebJOEYmYz31+J8dVgeiAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BfaObwf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfaObwf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384FDC4CEF1;
	Fri, 21 Nov 2025 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763755201;
	bh=Wqp7Yfsab5DnblR/7+iTW8wPcnGv5AFbJe6yV/lFZLQ=;
	h=Date:To:From:Subject:From;
	b=BfaObwf6YRgFpaZe9QEpwSb3y9GXEoShDWtTdXPTp0J90zguKhU2zkv6kVCCmGmB3
	 TEjE+AMMi1k5VCci+gxKbqMjPTcOFDl3f3cM2furpZABxpNcV00cSZA00jrhpMgi5R
	 TbDdJJCHlUNeyXKHJ76bx1xTy9O4pVkyUjdtz/0E=
Date: Fri, 21 Nov 2025 12:00:00 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,akpm@linux-foundation.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch added to mm-unstable branch
Message-Id: <20251121200001.384FDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
Date: Fri, 21 Nov 2025 14:48:59 -0500

sysctl bits are mostly-read values.

Link: https://lkml.kernel.org/r/20251121194859.265259-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,7 @@ bool hugetlbfs_pagecache_present(struct
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
-extern int sysctl_hugetlb_shm_group;
+extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
_

Patches currently in -mm which might be from gourry@gourry.net are

hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch

