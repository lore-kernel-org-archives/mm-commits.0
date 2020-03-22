From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 06/10] mm: do not allow MADV_PAGEOUT for CoW pages
Date: Sat, 21 Mar 2020 18:22:26 -0700
Message-ID: <20200322012226.yY5JKgG__%akpm@linux-foundation.org>
References: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBW3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:29 -0400
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dancol@google.com, dave.hansen@intel.com, jannh@google.com, joel@joelfernandes.org, linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: do not allow MADV_PAGEOUT for CoW pages

Jann has brought up a very interesting point [1].  While shared pages are
excluded from MADV_PAGEOUT normally, CoW pages can be easily reclaimed
that way.  This can lead to all sorts of hard to debug problems.  E.g. 
performance problems outlined by Daniel [2].

There are runtime environments where there is a substantial memory shared
among security domains via CoW memory and a easy to reclaim way of that
memory, which MADV_{COLD,PAGEOUT} offers, can lead to either performance
degradation in for the parent process which might be more privileged or
even open side channel attacks.

The feasibility of the latter is not really clear to me TBH but there is
no real reason for exposure at this stage.  It seems there is no real use
case to depend on reclaiming CoW memory via madvise at this stage so it is
much easier to simply disallow it and this is what this patch does.  Put
it simply MADV_{PAGEOUT,COLD} can operate only on the exclusively owned
memory which is a straightforward semantic.

[1] http://lkml.kernel.org/r/CAG48ez0G3JkMq61gUmyQAaCq=_TwHbi1XKzWRooxZkv08PQKuw@mail.gmail.com
[2] http://lkml.kernel.org/r/CAKOZueua_v8jHCpmEtTB6f3i9e2YnmX4mqdYVWhV4E=Z-n+zRQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200312082248.GS23944@dhcp22.suse.cz
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Daniel Colascione <dancol@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-do-not-allow-madv_pageout-for-cow-pages
+++ a/mm/madvise.c
@@ -335,12 +335,14 @@ static int madvise_cold_or_pageout_pte_r
 		}
 
 		page = pmd_page(orig_pmd);
+
+		/* Do not interfere with other mappings of this page */
+		if (page_mapcount(page) != 1)
+			goto huge_unlock;
+
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
-			if (page_mapcount(page) != 1)
-				goto huge_unlock;
