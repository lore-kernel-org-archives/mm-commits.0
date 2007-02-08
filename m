From: akpm@linux-foundation.org
Subject: + deprecate-sa_interrupt-and-friends.patch added to -mm tree
Date: Thu, 08 Feb 2007 15:54:11 -0800
Message-ID: <200702082354.l18NsBWi031254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXBHXyZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 18:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     deprecate SA_INTERRUPT and friends
has been added to the -mm tree.  Its filename is
     deprecate-sa_interrupt-and-friends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: deprecate SA_INTERRUPT and friends
From: Andrew Morton <akpm@linux-foundation.org>

Do ridiculous things to force a deprecated warning when someone uses one of
the old SA_* flags.  We can remove all this in six months or so.  To give all
those out-of-tree drivers time to catch up.

It'll cause build errors if someone is using SA_foo in a static initialiser,
but the fix for that is to use IRQF_foo.

Based on an idea from tglx.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |   37 +++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff -puN include/linux/interrupt.h~deprecate-sa_interrupt-and-friends include/linux/interrupt.h
--- a/include/linux/interrupt.h~deprecate-sa_interrupt-and-friends
+++ a/include/linux/interrupt.h
@@ -57,17 +57,32 @@
  * Migration helpers. Scheduled for removal in 1/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+#define emit_old_interrupt_name(old, new)				\
+static inline unsigned __deprecated emit_old_interrupt_name_##old(void)	\
+{									\
+	return (new);							\
+}
+
+emit_old_interrupt_name(SA_INTERRUPT, IRQF_DISABLED)
+#define SA_INTERRUPT emit_old_interrupt_name_SA_INTERRUPT()
+emit_old_interrupt_name(SA_SAMPLE_RANDOM, IRQF_SAMPLE_RANDOM)
+#define SA_SAMPLE_RANDOM emit_old_interrupt_name_SA_SAMPLE_RANDOM()
+emit_old_interrupt_name(SA_SHIRQ, IRQF_SHARED)
+#define SA_SHIRQ emit_old_interrupt_name_SA_SHIRQ()
+emit_old_interrupt_name(SA_PROBEIRQ, IRQF_PROBE_SHARED)
+#define SA_PROBEIRQ emit_old_interrupt_name_SA_PROBEIRQ()
+emit_old_interrupt_name(SA_PERCPU, IRQF_PERCPU)
+#define SA_PERCPU emit_old_interrupt_name_SA_PERCPU()
+emit_old_interrupt_name(SA_TRIGGER_LOW, IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_LOW emit_old_interrupt_name_SA_TRIGGER_LOW()
+emit_old_interrupt_name(SA_TRIGGER_HIGH, IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_HIGH emit_old_interrupt_name_SA_TRIGGER_HIGH()
+emit_old_interrupt_name(SA_TRIGGER_FALLING, IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_FALLING emit_old_interrupt_name_SA_TRIGGER_FALLING()
+emit_old_interrupt_name(SA_TRIGGER_RISING, IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_RISING emit_old_interrupt_name_SA_TRIGGER_RISING()
+emit_old_interrupt_name(SA_TRIGGER_MASK, IRQF_TRIGGER_MASK)
+#define SA_TRIGGER_MASK emit_old_interrupt_name_SA_TRIGGER_MASK()
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
utrace-i386-build-fix.patch
deprecate-sa_interrupt-and-friends.patch
