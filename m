From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch added to -mm tree
Date: Tue, 17 Sep 2013 16:09:42 -0700
Message-ID: <5238e136.tnDc/gK6e9HDliqW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3IQXJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 19:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mitsuo.hayasaka.hu@hitachi.com, liwanp@linux.vnet.ibm.com

Subject: + mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mitsuo.hayasaka.hu@hitachi.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 16:09:42 -0700


The patch titled
     Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"
has been added to the -mm tree.  Its filename is
     mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"

The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm:
avoid null pointer access in vm_struct via /proc/vmallocinfo) is used to
avoid accessing the pages field with unallocated page when
show_numa_info() is called.

This patch move the check into show_numa_info in order that some messages
still can be dumped via /proc/vmallocinfo.

This patch revert commit d157a558 (mm/vmalloc.c: check VM_UNINITIALIZED
flag in s_show instead of show_numa_info);

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info
+++ a/mm/vmalloc.c
@@ -2563,6 +2563,11 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+		if (v->flags & VM_UNINITIALIZED)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2591,11 +2596,6 @@ static int s_show(struct seq_file *m, vo
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
