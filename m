From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-simplify-error-return-from-swap_info-allocation.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:20 -0700
Message-ID: <201103232040.p2NKeuqT028574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933520Ab1CWUzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: simplify error return from swap_info allocation
has been removed from the -mm tree.  Its filename was
     sys_swapon-simplify-error-return-from-swap_info-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: simplify error return from swap_info allocation
From: Cesar Eduardo Barros <cesarb@cesarb.net>

At this point in sys_swapon, there is nothing to free. Return directly
instead of jumping to the cleanup block at the end of the function.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-return-from-swap_info-allocation mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-return-from-swap_info-allocation
+++ a/mm/swapfile.c
@@ -1918,10 +1918,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		return -EPERM;
 
 	p = alloc_swap_info();
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		goto out;
-	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
 	name = getname(specialfile);
 	error = PTR_ERR(name);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

