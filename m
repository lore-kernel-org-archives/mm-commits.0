From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-call-swap_cgroup_swapon-earlier.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:46 -0700
Message-ID: <201103232041.p2NKfMfd028637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933418Ab1CWUl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: call swap_cgroup_swapon() earlier
has been removed from the -mm tree.  Its filename was
     sys_swapon-call-swap_cgroup_swapon-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: call swap_cgroup_swapon() earlier
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The call to swap_cgroup_swapon is in the middle of loading the swap map
and extents. As it only does memory allocation and does not depend on
the swapfile layout (map/extents), it can be called earlier (or later).

Move it to just after the allocation of swap_map, since it is
conceptually similar (allocates a map).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-call-swap_cgroup_swapon-earlier mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-call-swap_cgroup_swapon-earlier
+++ a/mm/swapfile.c
@@ -2074,6 +2074,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 
+	error = swap_cgroup_swapon(p->type, maxpages);
+	if (error)
+		goto bad_swap;
+
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -2088,10 +2092,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
-	error = swap_cgroup_swapon(p->type, maxpages);
-	if (error)
-		goto bad_swap;
