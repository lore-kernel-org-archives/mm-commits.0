From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info.patch
 removed from -mm tree
Date: Tue, 17 Sep 2013 16:07:54 -0700
Message-ID: <5238e0ca.PP0XwMVW3gAZUAux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3IQXHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 19:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mitsuo.hayasaka.hu@hitachi.com, liwanp@linux.vnet.ibm.com

Subject: [alternative-merged] mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mitsuo.hayasaka.hu@hitachi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 16:07:54 -0700


The patch titled
     Subject: mm/vmalloc: move VM_UNINITIALIZED to just before show_numa_info
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: move VM_UNINITIALIZED to just before show_numa_info

The VM_UNINITIALIZED/VM_UNLIST flag introduced by f5252e00 ("mm: avoid
null pointer access in vm_struct via /proc/vmallocinfo") is used to avoid
accessing the pages field with unallocated page when show_numa_info() is
called.

This patch moves the check to just before show_numa_info in order that
some messages still can be dumped via /proc/vmallocinfo.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info
+++ a/mm/vmalloc.c
@@ -2591,11 +2591,6 @@ static int s_show(struct seq_file *m, vo
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
-
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
@@ -2623,6 +2618,11 @@ static int s_show(struct seq_file *m, vo
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+	smp_rmb();
+	if (v->flags & VM_UNINITIALIZED)
+		return;
+
 	show_numa_info(m, v);
 	seq_putc(m, '\n');
 	return 0;
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

