From: akpm@linux-foundation.org
Subject: +
 x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
 added to -mm tree
Date: Fri, 11 Oct 2013 13:39:14 -0700
Message-ID: <525861f2.Dq00yBYFISNR5ghH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab3JKUjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:39:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: + x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch added to -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:39:14 -0700


The patch titled
     Subject: x86, acpi, crash, kdump: do reserve_crashkernel() after SRAT is parsed.
has been added to the -mm tree.  Its filename is
     x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: x86, acpi, crash, kdump: do reserve_crashkernel() after SRAT is parsed.

Memory reserved for crashkernel could be large.  So we should not allocate
this memory bottom up from the end of kernel image.

When SRAT is parsed, we will be able to know which memory is hotpluggable,
and we can avoid allocating this memory for the kernel.  So reorder
reserve_crashkernel() after SRAT is parsed.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/setup.c~x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed
+++ a/arch/x86/kernel/setup.c
@@ -1120,8 +1120,6 @@ void __init setup_arch(char **cmdline_p)
 	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
 #endif
 
-	reserve_crashkernel();
-
 	vsmp_init();
 
 	io_delay_init();
@@ -1134,6 +1132,13 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
+
+	/*
+	 * Reserve memory for crash kernel after SRAT is parsed so that it
+	 * won't consume hotpluggable memory.
+	 */
+	reserve_crashkernel();
+
 	memblock_find_dma_reserve();
 
 #ifdef CONFIG_KVM_GUEST
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
linux-next.patch

