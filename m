From: akpm@linux-foundation.org
Subject: + memcg-memcontrol-make-local-symbol-static.patch added to -mm
 tree
Date: Mon, 22 Jan 2018 15:28:04 -0800
Message-ID: <5a667384.FEdrP8rswmw9C9qr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbeAVX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 18:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisadr@gentoo.org, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: make local symbol static
has been added to the -mm tree.  Its filename is
     memcg-memcontrol-make-local-symbol-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-memcontrol-make-local-symbol-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-memcontrol-make-local-symbol-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1094,7 +1094,7 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
-unsigned int memcg1_stats[] = {
+static const unsigned int memcg1_stats[] = {
 	MEMCG_CACHE,
 	MEMCG_RSS,
 	MEMCG_RSS_HUGE,
_

Patches currently in -mm which might be from chrisadr@gentoo.org are

memcg-memcontrol-make-local-symbol-static.patch

