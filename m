From: akpm@linux-foundation.org
Subject: + x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 17:27:43 -0800
Message-ID: <200702080128.l181SmFV001699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161390AbXBHB3B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 20:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, ebiederm@xmission.com, luigi.genoni@pirelli.com


The patch titled
     x86_64-survive-having-no-irq-mapping-for-a-vector-fix
has been added to the -mm tree.  Its filename is
     x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64-survive-having-no-irq-mapping-for-a-vector-fix
From: Andrew Morton <akpm@linux-foundation.org>

disable_apic doesn't exist on uniprocessor builds.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/irq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/irq.c~x86_64-survive-having-no-irq-mapping-for-a-vector-fix arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-survive-having-no-irq-mapping-for-a-vector-fix
+++ a/arch/x86_64/kernel/irq.c
@@ -138,12 +138,14 @@ asmlinkage unsigned int do_IRQ(struct pt
 	if (likely(irq < NR_IRQS))
 		generic_handle_irq(irq);
 	else {
+#ifdef CONFIG_SMP
 		if (!disable_apic)
 			ack_APIC_irq();
-
+#endif
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-				__func__, smp_processor_id(), vector);
+			printk(KERN_EMERG "%s: %d.%d No irq handler for "
+					"vector\n", __FUNCTION__,
+					smp_processor_id(), vector);
 	}
 
 	irq_exit();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
