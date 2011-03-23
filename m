From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:12 -0700
Message-ID: <201103232040.p2NKemUD028561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: use vzalloc() instead of vmalloc/memset
has been removed from the -mm tree.  Its filename was
     sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: use vzalloc() instead of vmalloc/memset
From: Cesar Eduardo Barros <cesarb@cesarb.net>

This patch series refactors the sys_swapon function.

sys_swapon is currently a very large function, with 313 lines (more than
12 25-line screens), which can make it a bit hard to read. This patch
series reduces this size by half, by extracting large chunks of related
code to new helper functions.

One of these chunks of code was nearly identical to the part of
sys_swapoff which is used in case of a failure return from
try_to_unuse(), so this patch series also makes both share the same
code.

As a side effect of all this refactoring, the compiled code gets a bit
smaller (from v1 of this patch series):

   text       data        bss        dec        hex    filename
  14012        944        276      15232       3b80    mm/swapfile.o.before
  13941        944        276      15161       3b39    mm/swapfile.o.after


This patch:

Use vzalloc() instead of vmalloc/memset.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-use-vzalloc-instead-of-vmalloc-memset mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-use-vzalloc-instead-of-vmalloc-memset
+++ a/mm/swapfile.c
@@ -2047,13 +2047,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 
 	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vmalloc(maxpages);
+	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
 		error = -ENOMEM;
 		goto bad_swap;
 	}
 
-	memset(swap_map, 0, maxpages);
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

