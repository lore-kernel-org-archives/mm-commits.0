From: akpm@linux-foundation.org
Subject: + lib-show_memc-show-num_poisoned_pages-when-oom.patch added to
 -mm tree
Date: Tue, 10 Dec 2013 13:42:26 -0800
Message-ID: <52a78ac2.S434n63Td7gV93wd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3LJVm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 16:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, qiuxishi@huawei.com

Subject: + lib-show_memc-show-num_poisoned_pages-when-oom.patch added to -mm tree
To: qiuxishi@huawei.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 13:42:26 -0800


The patch titled
     Subject: lib/show_mem.c: show num_poisoned_pages when oom
has been added to the -mm tree.  Its filename is
     lib-show_memc-show-num_poisoned_pages-when-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-show_memc-show-num_poisoned_pages-when-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-show_memc-show-num_poisoned_pages-when-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-show_memc-show-num_poisoned_pages-when-oom.patch
linux-next.patch

