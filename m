From: akpm@linux-foundation.org
Subject: [merged]
 x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:03 -0800
Message-ID: <5283e367.+ZSsWARkBer8sMVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3KMUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: [merged] x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:03 -0800


The patch titled
     Subject: x86, acpi, crash, kdump: do reserve_crashkernel() after SRAT is parsed.
has been removed from the -mm tree.  Its filename was
     x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Michal Nazarewicz <mina86@mina86.com>
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
@@ -1121,8 +1121,6 @@ void __init setup_arch(char **cmdline_p)
 	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
 #endif
 
-	reserve_crashkernel();
