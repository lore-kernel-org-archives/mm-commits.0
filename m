From: akpm@linux-foundation.org
Subject: + x86_64-irq-remove-extra-smp_processor_id-calling.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:43:49 -0800
Message-ID: <200703060443.l264hnjQ012075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbXCFEn7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai.lu@amd.com, ak@muc.de, ebiederm@xmission.com


The patch titled
     x86_64 irq: remove extra smp_processor_id calling
has been added to the -mm tree.  Its filename is
     x86_64-irq-remove-extra-smp_processor_id-calling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-irq-remove-extra-smp_processor_id-calling.patch
