From: akpm@linux-foundation.org
Subject: - x86_64-irq-remove-extra-smp_processor_id-calling.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:15 -0700
Message-ID: <200703292338.l2TNcFKQ015204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43060 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934379AbXC2XiW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai.lu@amd.com, ak@muc.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 irq: remove extra smp_processor_id calling
has been removed from the -mm tree.  Its filename was
     x86_64-irq-remove-extra-smp_processor_id-calling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 irq: remove extra smp_processor_id calling
From: "Yinghai Lu" <yinghai.lu@amd.com>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-remove-extra-smp_processor_id-calling arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-remove-extra-smp_processor_id-calling
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1407,8 +1407,7 @@ static void irq_complete_move(unsigned i
 
 	vector = ~get_irq_regs()->orig_rax;
 	me = smp_processor_id();
-	if ((vector == cfg->vector) &&
-	    cpu_isset(smp_processor_id(), cfg->domain)) {
+	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
_

Patches currently in -mm which might be from yinghai.lu@amd.com are

origin.patch
