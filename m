From: akpm@linux-foundation.org
Subject: - paravirt-helper-to-disable-all-io-space.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:24 -0700
Message-ID: <200706231928.l5NJSOnJ022144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbXFWTes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@xensource.com, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     paravirt: helper to disable all IO space
has been removed from the -mm tree.  Its filename was
     paravirt-helper-to-disable-all-io-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt: helper to disable all IO space
From: Jeremy Fitzhardinge <jeremy@xensource.com>

In a virtual environment, device drivers such as legacy IDE will waste quite a
lot of time probing for their devices which will never appear.  This helper
function allows a paravirt implementation to lay claim to the whole iomem and
ioport space, thereby disabling all device drivers trying to claim IO
resources.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |   33 +++++++++++++++++++++++++++++++++
 arch/i386/xen/setup.c       |    2 ++
 include/asm-i386/paravirt.h |    1 +
 3 files changed, 36 insertions(+)

diff -puN arch/i386/kernel/paravirt.c~paravirt-helper-to-disable-all-io-space arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt-helper-to-disable-all-io-space
+++ a/arch/i386/kernel/paravirt.c
@@ -228,6 +228,39 @@ static int __init print_banner(void)
 }
 core_initcall(print_banner);
 
+static struct resource reserve_ioports = {
+	.start = 0,
+	.end = IO_SPACE_LIMIT,
+	.name = "paravirt-ioport",
+	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
+};
+
+static struct resource reserve_iomem = {
+	.start = 0,
+	.end = -1,
+	.name = "paravirt-iomem",
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+};
+
+/*
+ * Reserve the whole legacy IO space to prevent any legacy drivers
+ * from wasting time probing for their hardware.  This is a fairly
+ * brute-force approach to disabling all non-virtual drivers.
+ *
+ * Note that this must be called very early to have any effect.
+ */
+int paravirt_disable_iospace(void)
+{
+	int ret = 0;
+
+	ret = request_resource(&ioport_resource, &reserve_ioports);
+	if (ret == 0)
+		ret = request_resource(&iomem_resource, &reserve_iomem);
+
+	return ret;
+}
+
+
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
diff -puN arch/i386/xen/setup.c~paravirt-helper-to-disable-all-io-space arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~paravirt-helper-to-disable-all-io-space
+++ a/arch/i386/xen/setup.c
@@ -8,12 +8,14 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
+#include <linux/ioport.h>
 
 #include <asm/elf.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <asm/io.h>
 
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
diff -puN include/asm-i386/paravirt.h~paravirt-helper-to-disable-all-io-space include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt-helper-to-disable-all-io-space
+++ a/include/asm-i386/paravirt.h
@@ -262,6 +262,7 @@ unsigned paravirt_patch_default(u8 type,
 unsigned paravirt_patch_insns(void *site, unsigned len,
 			      const char *start, const char *end);
 
+int paravirt_disable_iospace(void);
 
 /*
  * This generates an indirect call based on the operation type number.
_

Patches currently in -mm which might be from jeremy@xensource.com are

git-kbuild.patch
add-kstrndup-fix.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
