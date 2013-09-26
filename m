From: akpm@linux-foundation.org
Subject: +
 x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 17:05:28 -0700
Message-ID: <52437a48.05b+o2SmWDNgccmt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3IZAFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: + x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch added to -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:05:28 -0700


The patch titled
     Subject: x86, acpi, crash, kdump: do reserve_crashkernel() after SRAT is parsed
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
Subject: x86, acpi, crash, kdump: do reserve_crashkernel() after SRAT is parsed

Memory reserved for crashkernel could be large.  So we should not allocate
this memory bottom up from the end of kernel image.

When SRAT is parsed, we will be able to know which memory is hotpluggable,
and we can avoid allocating this memory for the kernel.  So reorder
reserve_crashkernel() after SRAT is parsed.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

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
@@ -1136,6 +1134,12 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	memblock_find_dma_reserve();
 
+	/*
+	 * Reserve memory for crash kernel after SRAT is parsed so that it
+	 * won't consume hotpluggable memory.
+	 */
+	reserve_crashkernel();
+
 #ifdef CONFIG_KVM_GUEST
 	kvmclock_init();
 #endif
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch

