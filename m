From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-use-mem_cgroup_is_root-api.patch added to
 -mm tree
Date: Mon, 10 Feb 2020 21:34:11 -0800
Message-ID: <20200211053411._cAUKwWw2%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbgBKFeM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:34:12 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmpressure: use mem_cgroup_is_root API
has been added to the -mm tree.  Its filename is
     mm-vmpressure-use-mem_cgroup_is_root-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmpressure-use-mem_cgroup_is_root-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmpressure-use-mem_cgroup_is_root-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmpressure: use mem_cgroup_is_root API

Use mem_cgroup_is_root() API to check if memcg is root memcg instead of
open coding.

Link: http://lkml.kernel.org/r/1581398649-125989-2-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmpressure.c~mm-vmpressure-use-mem_cgroup_is_root-api
+++ a/mm/vmpressure.c
@@ -280,7 +280,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 		enum vmpressure_levels level;
 
 		/* For now, no users for root-level efficiency */
-		if (!memcg || memcg == root_mem_cgroup)
+		if (!memcg || mem_cgroup_is_root(memcg))
 			return;
 
 		spin_lock(&vmpr->sr_lock);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
mm-vmpressure-use-mem_cgroup_is_root-api.patch
