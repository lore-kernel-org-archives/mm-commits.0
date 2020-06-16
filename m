From: akpm@linux-foundation.org
Subject: +
 mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 12:46:07 -0700
Message-ID: <20200616194607.-3cCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgFPTqI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@redhat.com, jay.xu@rock-chips.com


The patch titled
     Subject: mm/cma.c: fix NULL pointer dereference when cma could not be activated
has been added to the -mm tree.  Its filename is
     mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianqun Xu <jay.xu@rock-chips.com>
Subject: mm/cma.c: fix NULL pointer dereference when cma could not be activated

In some case the cma area could not be activated, but the cma_alloc be
used under this case, then the kernel will crash caused by NULL pointer
dereference.

Add bitmap valid check in cma_alloc to avoid this issue.

Link: http://lkml.kernel.org/r/20200615010123.15596-1-jay.xu@rock-chips.com
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated
+++ a/mm/cma.c
@@ -425,7 +425,7 @@ struct page *cma_alloc(struct cma *cma,
 	struct page *page = NULL;
 	int ret = -ENOMEM;
 
-	if (!cma || !cma->count)
+	if (!cma || !cma->count || !cma->bitmap)
 		return NULL;
 
 	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
_

Patches currently in -mm which might be from jay.xu@rock-chips.com are

mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch
