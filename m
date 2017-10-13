From: akpm@linux-foundation.org
Subject: [patch 07/18] mm: only display online cpus of the numa node
Date: Fri, 13 Oct 2017 15:57:50 -0700
Message-ID: <59e144ee.iYuL3GXWoeNbC0xJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdJMW5w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, thunder.leizhen@huawei.com, catalin.marinas@arm.com, dingtianhong@huawei.com, gregkh@linuxfoundation.org, guohanjun@huawei.com, huawei.libin@huawei.com, mhocko@suse.com, wangkefeng.wang@huawei.com, will.deacon@arm.com

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm: only display online cpus of the numa node

When I executed numactl -H(which read
/sys/devices/system/node/nodeX/cpumap and display cpumask_of_node for each
node), but I got different result on X86 and arm64.  For each numa node,
the former only displayed online CPUs, and the latter displayed all
possible CPUs.  Unfortunately, both Linux documentation and numactl manual
have not described it clear.

I sent a mail to ask for help, and Michal Hocko replied that he preferred
to print online cpus because it doesn't really make much sense to bind
anything on offline nodes.

Will said:

: I suspect the vast majority (if not all) code that reads this file was
: developed for x86, so having the same behaviour for arm64 sounds like
: something we should do ASAP before people try to special case with
: things like #ifdef __aarch64__.  I'd rather have this in 4.14 if possible.

Link: http://lkml.kernel.org/r/1506678805-15392-2-git-send-email-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Libin <huawei.libin@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~mm-only-dispaly-online-cpus-of-the-numa-node drivers/base/node.c
--- a/drivers/base/node.c~mm-only-dispaly-online-cpus-of-the-numa-node
+++ a/drivers/base/node.c
@@ -27,13 +27,21 @@ static struct bus_type node_subsys = {
 
 static ssize_t node_read_cpumap(struct device *dev, bool list, char *buf)
 {
+	ssize_t n;
+	cpumask_var_t mask;
 	struct node *node_dev = to_node(dev);
-	const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
-	return cpumap_print_to_pagebuf(list, buf, mask);
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return 0;
+
+	cpumask_and(mask, cpumask_of_node(node_dev->dev.id), cpu_online_mask);
+	n = cpumap_print_to_pagebuf(list, buf, mask);
+	free_cpumask_var(mask);
+
+	return n;
 }
 
 static inline ssize_t node_read_cpumask(struct device *dev,
_
