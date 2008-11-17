From: akpm@linux-foundation.org
Subject: + memcg-swap-cgroup-for-remembering-usage-fix-2.patch added to -mm tree
Date: Sun, 16 Nov 2008 20:50:02 -0800
Message-ID: <200811170450.mAH4o25B001751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbYKQEuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Nov 2008 23:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, xemul@openvz.org


The patch titled
     swap cgroup: fix typo in message
has been added to the -mm tree.  Its filename is
     memcg-swap-cgroup-for-remembering-usage-fix-2.patch

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
Subject: swap cgroup: fix typo in message
From: Balbir Singh <balbir@linux.vnet.ibm.com>

There is a typo in the spelling of buffers (buffres) and the message is
not very clear either.  Fix the message and typo (hopefully not
introducing any new ones ;) )

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-2 mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-2
+++ a/mm/page_cgroup.c
@@ -422,7 +422,8 @@ int swap_cgroup_swapon(int type, unsigne
 	mutex_unlock(&swap_cgroup_mutex);
 
 	printk(KERN_INFO
-		"swap_cgroup: uses %ld bytes vmalloc and %ld bytes buffres\n",
+		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
+		" and %ld bytes to hold mem_cgroup pointers on swap\n",
 		array_size, length * PAGE_SIZE);
 	printk(KERN_INFO
 	"swap_cgroup can be disabled by noswapaccount boot option.\n");
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch

