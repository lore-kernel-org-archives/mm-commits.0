From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-redundant-message-at-swapon.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:51 -0700
Message-ID: <200904061934.n36JYpVu011774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757643AbZDFThI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove redundant message at swapon
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-message-at-swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant message at swapon
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's pointed out that swap_cgroup's message at swapon() is nonsense.
Because

  * It can be calculated very easily if all necessary information is
    written in Kconfig.

  * It's not necessary to annoying people at every swapon().

In other view, now, memory usage per swp_entry is reduced to 2bytes from
8bytes(64bit) and I think it's reasonably small.

Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |    2 ++
 mm/page_cgroup.c |    7 -------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN init/Kconfig~memcg-remove-redundant-message-at-swapon init/Kconfig
--- a/init/Kconfig~memcg-remove-redundant-message-at-swapon
+++ a/init/Kconfig
@@ -597,6 +597,8 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  is disabled by boot option, this will be automatically disabled and
 	  there will be no overhead from this. Even when you set this config=y,
 	  if boot option "noswapaccount" is set, swap will not be accounted.
+	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
+	  size is 4096bytes, 512k per 1Gbytes of swap.
 
 endif # CGROUPS
 
diff -puN mm/page_cgroup.c~memcg-remove-redundant-message-at-swapon mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-redundant-message-at-swapon
+++ a/mm/page_cgroup.c
@@ -426,13 +426,6 @@ int swap_cgroup_swapon(int type, unsigne
 	}
 	mutex_unlock(&swap_cgroup_mutex);
 
-	printk(KERN_INFO
-		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
-		" and %ld bytes to hold mem_cgroup information per swap ents\n",
-		array_size, length * PAGE_SIZE);
-	printk(KERN_INFO
-	"swap_cgroup can be disabled by noswapaccount boot option.\n");
