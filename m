From: akpm@osdl.org
Subject: - kvm-api-versioning.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:24 -0800
Message-ID: <200612230753.kBN7rOpP010121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbWLWHx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: API versioning
has been removed from the -mm tree.  Its filename was
     kvm-api-versioning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: API versioning
From: Avi Kivity <avi@qumranet.com>

Add compile-time and run-time API versioning.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    3 +++
 include/linux/kvm.h    |    3 +++
 2 files changed, 6 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-api-versioning drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-api-versioning
+++ a/drivers/kvm/kvm_main.c
@@ -1603,6 +1603,9 @@ static long kvm_dev_ioctl(struct file *f
 	int r = -EINVAL;
 
 	switch (ioctl) {
+	case KVM_GET_API_VERSION:
+		r = KVM_API_VERSION;
+		break;
 	case KVM_CREATE_VCPU: {
 		r = kvm_dev_ioctl_create_vcpu(kvm, arg);
 		if (r)
diff -puN include/linux/kvm.h~kvm-api-versioning include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-api-versioning
+++ a/include/linux/kvm.h
@@ -11,6 +11,8 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+#define KVM_API_VERSION 1
+
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
  * to hold them.
@@ -209,6 +211,7 @@ struct kvm_dirty_log {
 
 #define KVMIO 0xAE
 
+#define KVM_GET_API_VERSION       _IO(KVMIO, 1)
 #define KVM_RUN                   _IOWR(KVMIO, 2, struct kvm_run)
 #define KVM_GET_REGS              _IOWR(KVMIO, 3, struct kvm_regs)
 #define KVM_SET_REGS              _IOW(KVMIO, 4, struct kvm_regs)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

