From: akpm@linux-foundation.org
Subject: + mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch
 added to -mm tree
Date: Mon, 11 Jan 2016 14:07:34 -0800
Message-ID: <569427a6.ijYqiy3sNZAci2DG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761203AbcAKWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:07:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davem@davemloft.net, hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: avoid vmpressure oops when memcg disabled
has been added to the -mm tree.  Its filename is
     mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: avoid vmpressure oops when memcg disabled

A CONFIG_MEMCG=y kernel booted with "cgroup_disable=memory" crashes on a
NULL memcg (but non-NULL root_mem_cgroup) when vmpressure kicks in. 
Here's the patch I use to avoid that, but you might prefer a test on
mem_cgroup_disabled() somewhere.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix
+++ a/mm/vmpressure.c
@@ -260,7 +260,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 		enum vmpressure_levels level;
 
 		/* For now, no users for root-level efficiency */
-		if (memcg == root_mem_cgroup)
+		if (!memcg || memcg == root_mem_cgroup)
 			return;
 
 		spin_lock(&vmpr->sr_lock);
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch

