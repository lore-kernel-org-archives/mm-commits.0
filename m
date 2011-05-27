From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-spin_lock_irqsave-misuse.patch removed from -mm tree
Date: Fri, 27 May 2011 12:56:54 -0700
Message-ID: <201105271954.p4RJsxmF017386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab1E0Tzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: fix spin_lock_irqsave() misuse
has been removed from the -mm tree.  Its filename was
     m32r-fix-spin_lock_irqsave-misuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: fix spin_lock_irqsave() misuse
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

spin_lock_irqsave() requires unsigned long.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/m32r_sio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/tty/serial/m32r_sio.c~m32r-fix-spin_lock_irqsave-misuse drivers/tty/serial/m32r_sio.c
--- a/drivers/tty/serial/m32r_sio.c~m32r-fix-spin_lock_irqsave-misuse
+++ a/drivers/tty/serial/m32r_sio.c
@@ -907,9 +907,10 @@ static int m32r_sio_request_port(struct 
 	return ret;
 }
 
-static void m32r_sio_config_port(struct uart_port *port, int flags)
+static void m32r_sio_config_port(struct uart_port *port, int unused)
 {
 	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

