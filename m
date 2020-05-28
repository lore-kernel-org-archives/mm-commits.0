From: akpm@linux-foundation.org
Subject: +
 memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging.patch added to -mm
 tree
Date: Wed, 27 May 2020 17:13:15 -0700
Message-ID: <20200528001315.oWjxWHv7l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgE1ANR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: memcg: Fix memcg_kmem_bypass() for remote memcg charging
has been added to the -mm tree.  Its filename is
     memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zefan Li <lizefan@huawei.com>
Subject: memcg: Fix memcg_kmem_bypass() for remote memcg charging

While trying to use remote memcg charging in an out-of-tree kernel module
I found it's not working, because the current thread is a workqueue thread.

As we will probably encounter this issue in the future as the users of
memalloc_use_memcg() grow, and it's nothing wrong for this usage, it's
better we fix it now.

Link: http://lkml.kernel.org/r/1d202a12-26fe-0012-ea14-f025ddcd044a@huawei.com
Signed-off-by: Zefan Li <lizefan@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging
+++ a/mm/memcontrol.c
@@ -2852,7 +2852,12 @@ static void memcg_schedule_kmem_cache_cr
 
 static inline bool memcg_kmem_bypass(void)
 {
-	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+	if (in_interrupt())
+		return true;
+
+	/* Allow remote memcg charging in kthread contexts. */
+	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
+	     !current->active_memcg)
 		return true;
 	return false;
 }
_

Patches currently in -mm which might be from lizefan@huawei.com are

memcg-fix-memcg_kmem_bypass-for-remote-memcg-charging.patch
