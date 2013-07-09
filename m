From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:41 -0700
Message-ID: <51dc9a8d.r3YiLSuv/oQSYujr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3GIXTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:41 -0700


The patch titled
     Subject: mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info

We should check the VM_UNITIALIZED flag in s_show().  If this flag is set,
that said, the vm_struct is not fully initialized.  So it is unnecessary
to try to show the information contained in vm_struct.

We checked this flag in show_numa_info(), but I think it's better
to check it earlier.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info
+++ a/mm/vmalloc.c
@@ -2569,11 +2569,6 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
-		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-		smp_rmb();
-		if (v->flags & VM_UNINITIALIZED)
-			return;
