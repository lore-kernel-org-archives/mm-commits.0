From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch added to
 -mm tree
Date: Mon, 23 May 2016 13:47:07 -0700
Message-ID: <57436c4b.0N/Kw1D1L60lQrm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbcEWUrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix possible css ref leak on oom
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: fix possible css ref leak on oom

mem_cgroup_oom may be invoked multiple times while a process is handling a
page fault, in which case current->memcg_in_oom will be overwritten
leaking the previously taken css reference.

Link: http://lkml.kernel.org/r/1464019330-7579-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-possible-css-ref-leak-on-oom mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-possible-css-ref-leak-on-oom
+++ a/mm/memcontrol.c
@@ -1604,7 +1604,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_may_oom)
+	if (!current->memcg_may_oom || current->memcg_in_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

