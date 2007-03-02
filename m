From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:20 -0800
Message-ID: <200703020457.l224vKaq000520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXCBE6K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:58:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, chrisw@sous-sol.org, ian.pratt@xensource.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: add nosegneg capability to the vsyscall page notes
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: add nosegneg capability to the vsyscall page notes
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add the "nosegneg" fake capabilty to the vsyscall page notes.  This is used by
the runtime linker to select a glibc version which then disables
negative-offset accesses to the thread-local segment via %gs.  These accesses
require emulation in Xen (because segments are truncated to protect the
hypervisor address space) and avoiding them provides a measurable performance
boost.

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vsyscall-note.S |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+)

diff -puN arch/i386/kernel/vsyscall-note.S~xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes arch/i386/kernel/vsyscall-note.S
--- a/arch/i386/kernel/vsyscall-note.S~xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes
+++ a/arch/i386/kernel/vsyscall-note.S
@@ -23,3 +23,31 @@
 	ASM_ELF_NOTE_BEGIN(".note.kernel-version", "a", UTS_SYSNAME, 0)
 	.long LINUX_VERSION_CODE
 	ASM_ELF_NOTE_END
+
+#ifdef CONFIG_XEN
+/*
+ * Add a special note telling glibc's dynamic linker a fake hardware
+ * flavor that it will use to choose the search path for libraries in the
+ * same way it uses real hardware capabilities like "mmx".
+ * We supply "nosegneg" as the fake capability, to indicate that we
+ * do not like negative offsets in instructions using segment overrides,
+ * since we implement those inefficiently.  This makes it possible to
+ * install libraries optimized to avoid those access patterns in someplace
+ * like /lib/i686/tls/nosegneg.  Note that an /etc/ld.so.conf.d/file
+ * corresponding to the bits here is needed to make ldconfig work right.
+ * It should contain:
+ *	hwcap 0 nosegneg
+ * to match the mapping of bit to name that we give here.
+ */
+#define NOTE_KERNELCAP_BEGIN(ncaps, mask) \
+	ASM_ELF_NOTE_BEGIN(".note.kernelcap", "a", "GNU", 2) \
+	.long ncaps, mask
+#define NOTE_KERNELCAP(bit, name) \
+	.byte bit; .asciz name
+#define NOTE_KERNELCAP_END ASM_ELF_NOTE_END
+
+NOTE_KERNELCAP_BEGIN(1, 1)
+NOTE_KERNELCAP(1, "nosegneg")
+NOTE_KERNELCAP_END
+#endif
+
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
