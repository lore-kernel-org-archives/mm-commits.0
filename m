From: akpm@osdl.org
Subject: - kvm-amd-svm-plumbing.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:56:04 -0800
Message-ID: <200612100756.kBA7u4KV017923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59899 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760365AbWLJH4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: Plumbing
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-plumbing.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: AMD SVM: Plumbing
From: Avi Kivity <avi@qumranet.com>

Wire it all up and we're ready to go.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/Kconfig  |    7 +++++++
 drivers/kvm/Makefile |    2 ++
 2 files changed, 9 insertions(+)

diff -puN drivers/kvm/Kconfig~kvm-amd-svm-plumbing drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig~kvm-amd-svm-plumbing
+++ a/drivers/kvm/Kconfig
@@ -24,3 +24,10 @@ config KVM_INTEL
 	---help---
 	  Provides support for KVM on Intel processors equipped with the VT
 	  extensions.
+
+config KVM_AMD
+	tristate "KVM for AMD processors support"
+	depends on KVM && X86_64
+	---help---
+	  Provides support for KVM on AMD processors equipped with the AMD-V
+	  (SVM) extensions.
diff -puN drivers/kvm/Makefile~kvm-amd-svm-plumbing drivers/kvm/Makefile
--- a/drivers/kvm/Makefile~kvm-amd-svm-plumbing
+++ a/drivers/kvm/Makefile
@@ -6,3 +6,5 @@ kvm-objs := kvm_main.o mmu.o x86_emulate
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
+kvm-amd-objs = svm.o
+obj-$(CONFIG_KVM_AMD) += kvm-amd.o
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

