From: akpm@linux-foundation.org
Subject: [merged] lib-show_memc-show-num_poisoned_pages-when-oom.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:36 -0800
Message-ID: <52e026ac.Q9nSsak4s80of4nm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, qiuxishi@huawei.com

Subject: [merged] lib-show_memc-show-num_poisoned_pages-when-oom.patch removed from -mm tree
To: qiuxishi@huawei.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:36 -0800


The patch titled
     Subject: lib/show_mem.c: show num_poisoned_pages when oom
has been removed from the -mm tree.  Its filename was
     lib-show_memc-show-num_poisoned_pages-when-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: lib/show_mem.c: show num_poisoned_pages when oom

Show num_poisoned_pages when oom, it is a little helpful to find the
reason.  Also it will be emitted anytime show_mem() is called.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/show_mem.c~lib-show_memc-show-num_poisoned_pages-when-oom lib/show_mem.c
--- a/lib/show_mem.c~lib-show_memc-show-num_poisoned_pages-when-oom
+++ a/lib/show_mem.c
@@ -43,4 +43,7 @@ void show_mem(unsigned int filter)
 	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+#endif
 }
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch
mm-do_mincore-cleanup.patch
mm-nobootmem-free_all_bootmem-again.patch
doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch
linux-next.patch

