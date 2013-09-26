From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch added to -mm tree
Date: Wed, 25 Sep 2013 17:40:52 -0700
Message-ID: <52438294.ojDhrV2rsWM0gwDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3IZAkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, mitsuo.hayasaka.hu@hitachi.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: + mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mitsuo.hayasaka.hu@hitachi.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:40:52 -0700


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

The VM_UNINITIALIZED/VM_UNLIST flag introduced by f5252e00 ("mm:
avoid null pointer access in vm_struct via /proc/vmallocinfo") is used to
avoid accessing the pages field with unallocated page when
show_numa_info() is called.  This patch move the check just before
show_numa_info in order that some messages still can be dumped via
/proc/vmallocinfo.  This patch revert commit d157a558 ("mm/vmalloc.c: check
VM_UNINITIALIZED flag in s_show instead of show_numa_info");

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info
+++ a/mm/vmalloc.c
@@ -2562,6 +2562,11 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+		if (v->flags & VM_UNINITIALIZED)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2587,11 +2592,6 @@ static int s_show(struct seq_file *m, vo
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
-
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-compactionc-periodically-schedule-when-freeing-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

