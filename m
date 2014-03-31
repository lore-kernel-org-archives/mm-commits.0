From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch
 added to -mm tree
Date: Mon, 31 Mar 2014 12:31:51 -0700
Message-ID: <5339c2a7.I8TaMevnooiiiY/Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaCaTbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 15:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, m.mizuma@jp.fujitsu.com

Subject: + mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch added to -mm tree
To: m.mizuma@jp.fujitsu.com,aneesh.kumar@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 12:31:51 -0700


The patch titled
     Subject: mm: hugetlb: fix softlockup when a large number of hugepages are freed.
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>
Subject: mm: hugetlb: fix softlockup when a large number of hugepages are freed.

When I decrease the value of nr_hugepage in procfs a lot, softlockup
happens.  It is because there is no chance of context switch during this
process.

On the other hand, when I allocate a large number of hugepages, there is
some chance of context switch.  Hence softlockup doesn't happen during
this process.  So it's necessary to add the context switch in the freeing
process as same as allocating process to avoid softlockup.

When I freed 12 TB hugapages with kernel-2.6.32-358.el6, the freeing
process occupied a CPU over 150 seconds and following softlockup message
appeared twice or more.


$ echo 6000000 > /proc/sys/vm/nr_hugepages
$ cat /proc/sys/vm/nr_hugepages
6000000
$ grep ^Huge /proc/meminfo
HugePages_Total:   6000000
HugePages_Free:    6000000
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
$ echo 0 > /proc/sys/vm/nr_hugepages

BUG: soft lockup - CPU#16 stuck for 67s! [sh:12883] ...
Pid: 12883, comm: sh Not tainted 2.6.32-358.el6.x86_64 #1
Call Trace:
 [<ffffffff8115a438>] ? free_pool_huge_page+0xb8/0xd0
 [<ffffffff8115a578>] ? set_max_huge_pages+0x128/0x190
 [<ffffffff8115c663>] ? hugetlb_sysctl_handler_common+0x113/0x140
 [<ffffffff8115c6de>] ? hugetlb_sysctl_handler+0x1e/0x20
 [<ffffffff811f3097>] ? proc_sys_call_handler+0x97/0xd0
 [<ffffffff811f30e4>] ? proc_sys_write+0x14/0x20
 [<ffffffff81180f98>] ? vfs_write+0xb8/0x1a0
 [<ffffffff81181891>] ? sys_write+0x51/0x90
 [<ffffffff810dc565>] ? __audit_syscall_exit+0x265/0x290
 [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b

I have not confirmed this problem with upstream kernels because I am not
able to prepare the machine equipped with 12TB memory now.  However I
confirmed that the amount of decreasing hugepages was directly
proportional to the amount of required time.

I measured required times on a smaller machine.  It showed 130-145
hugepages decreased in a millisecond.

Amount of decreasing     Required time      Decreasing rate
hugepages                     (msec)         (pages/msec)
------------------------------------------------------------
10,000 pages == 20GB         70 -  74          135-142
30,000 pages == 60GB        208 - 229          131-144

It means decrement of 6TB hugepages will trigger softlockup with the
default threshold 20sec, in this decreasing rate.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed
+++ a/mm/hugetlb.c
@@ -1537,6 +1537,7 @@ static unsigned long set_max_huge_pages(
 	while (min_count < persistent_huge_pages(h)) {
 		if (!free_pool_huge_page(h, nodes_allowed, 0))
 			break;
+		cond_resched_lock(&hugetlb_lock);
 	}
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, nodes_allowed, 1))
_

Patches currently in -mm which might be from m.mizuma@jp.fujitsu.com are

mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch

