From: akpm@linux-foundation.org
Subject: [merged] mm-remove-inline-from-scan_swap_map.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:00 -0700
Message-ID: <201103232041.p2NKfaMh028663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933517Ab1CWUzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: remove inline from scan_swap_map()
has been removed from the -mm tree.  Its filename was
     mm-remove-inline-from-scan_swap_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove inline from scan_swap_map()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

scan_swap_map() is a large function (224 lines), with several loops and a
complex control flow involving several gotos.

Given all that, it is a bit silly that it is marked as inline.  The
compiler agrees with me: on a x86-64 compile, it did not inline the
function.

Remove the "inline" and let the compiler decide instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-remove-inline-from-scan_swap_map mm/swapfile.c
--- a/mm/swapfile.c~mm-remove-inline-from-scan_swap_map
+++ a/mm/swapfile.c
@@ -212,8 +212,8 @@ static int wait_for_discard(void *word)
 #define SWAPFILE_CLUSTER	256
 #define LATENCY_LIMIT		256
 
-static inline unsigned long scan_swap_map(struct swap_info_struct *si,
-					  unsigned char usage)
+static unsigned long scan_swap_map(struct swap_info_struct *si,
+				   unsigned char usage)
 {
 	unsigned long offset;
 	unsigned long scan_base;
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

