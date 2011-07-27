From: akpm@linux-foundation.org
Subject: [merged] cpumask-convert-for_each_cpumask-with-for_each_cpu.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:52 -0700
Message-ID: <201107271927.p6RJRcMg003228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab1G0T16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cpumask: convert for_each_cpumask() with for_each_cpu()
has been removed from the -mm tree.  Its filename was
     cpumask-convert-for_each_cpumask-with-for_each_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: convert for_each_cpumask() with for_each_cpu()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Adapt new API fashion.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/cpumask.c~cpumask-convert-for_each_cpumask-with-for_each_cpu lib/cpumask.c
--- a/lib/cpumask.c~cpumask-convert-for_each_cpumask-with-for_each_cpu
+++ a/lib/cpumask.c
@@ -30,7 +30,7 @@ int __any_online_cpu(const cpumask_t *ma
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		if (cpu_online(cpu))
 			break;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
kexec-remove-kmsg_dump_kexec.patch

