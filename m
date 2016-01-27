From: akpm@linux-foundation.org
Subject: + vmpressure-fix-subtree-pressure-detection.patch added to -mm
 tree
Date: Wed, 27 Jan 2016 10:37:49 -0800
Message-ID: <56a90e7d.i6UHBncl+O1hZLPT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862AbcA0Shu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 13:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmpressure.c: fix subtree pressure detection
has been added to the -mm tree.  Its filename is
     vmpressure-fix-subtree-pressure-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmpressure-fix-subtree-pressure-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmpressure-fix-subtree-pressure-detection.patch

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
Subject: mm/vmpressure.c: fix subtree pressure detection

When vmpressure is called for the entire subtree under pressure we
mistakenly use vmpressure->scanned instead of vmpressure->tree_scanned
when checking if vmpressure work is to be scheduled.  This results in
suppressing all vmpressure events in the legacy cgroup hierarchy.  Fix it.

Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket pressure")
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmpressure.c~vmpressure-fix-subtree-pressure-detection mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-fix-subtree-pressure-detection
+++ a/mm/vmpressure.c
@@ -248,9 +248,8 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 	if (tree) {
 		spin_lock(&vmpr->sr_lock);
-		vmpr->tree_scanned += scanned;
+		scanned = vmpr->tree_scanned += scanned;
 		vmpr->tree_reclaimed += reclaimed;
-		scanned = vmpr->scanned;
 		spin_unlock(&vmpr->sr_lock);
 
 		if (scanned < vmpressure_win)
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

vmpressure-fix-subtree-pressure-detection.patch

