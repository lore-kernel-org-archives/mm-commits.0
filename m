From: akpm@linux-foundation.org
Subject: + memcg-remove-unused-page-flag-bitfield-defines.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:25:28 -0800
Message-ID: <201102032325.p13NPSf6031003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab1BCX0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:26:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove unused page flag bitfield defines
has been added to the -mm tree.  Its filename is
     memcg-remove-unused-page-flag-bitfield-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove unused page flag bitfield defines
From: Johannes Weiner <hannes@cmpxchg.org>

These definitions have been unused since '4b3bde4 memcg: remove the
overhead associated with the root cgroup'.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-page-flag-bitfield-defines mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-page-flag-bitfield-defines
+++ a/mm/memcontrol.c
@@ -327,13 +327,6 @@ enum charge_type {
 	NR_CHARGE_TYPE,
 };
 
-/* only for here (for easy reading.) */
-#define PCGF_CACHE	(1UL << PCG_CACHE)
-#define PCGF_USED	(1UL << PCG_USED)
-#define PCGF_LOCK	(1UL << PCG_LOCK)
-/* Not used, but added here for completeness */
-#define PCGF_ACCT	(1UL << PCG_ACCT)
