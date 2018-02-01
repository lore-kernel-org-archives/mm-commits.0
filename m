From: akpm@linux-foundation.org
Subject: [merged] memcg-memcontrol-make-local-symbol-static.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:34:28 -0800
Message-ID: <20180201193428.XynYKHt78%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754605AbeBATee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisadr@gentoo.org, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: make local symbol static
has been removed from the -mm tree.  Its filename was
     memcg-memcontrol-make-local-symbol-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christopher Díaz Riveros <chrisadr@gentoo.org>
Subject: mm/memcontrol.c: make local symbol static

Fixes the following sparse warning:

mm/memcontrol.c:1097:14: warning:
  symbol 'memcg1_stats' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20180118193327.14200-1-chrisadr@gentoo.org
Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-memcontrol-make-local-symbol-static mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memcontrol-make-local-symbol-static
+++ a/mm/memcontrol.c
@@ -1095,7 +1095,7 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
-unsigned int memcg1_stats[] = {
+static const unsigned int memcg1_stats[] = {
 	MEMCG_CACHE,
 	MEMCG_RSS,
 	MEMCG_RSS_HUGE,
_

Patches currently in -mm which might be from chrisadr@gentoo.org are


