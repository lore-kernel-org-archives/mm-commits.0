From: akpm@osdl.org
Subject: + kvm-recover-after-an-arch-module-load-failure.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:06:03 -0800
Message-ID: <200701022206.l02M64xh031385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907AbXABWG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ichiyanagi.yoshimi@lab.ntt.co.jp, avi@qumranet.com


The patch titled
     KVM: Recover after an arch module load failure
has been added to the -mm tree.  Its filename is
     kvm-recover-after-an-arch-module-load-failure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Recover after an arch module load failure
From: Yoshimi Ichiyanagi <ichiyanagi.yoshimi@lab.ntt.co.jp>

If we load the wrong arch module, it leaves behind kvm_arch_ops set, which
prevents loading of the correct arch module later.

Fix be not setting kvm_arch_ops until we're sure it's good.

Signed-off-by: Yoshimi Ichiyanagi <ichiyanagi.yoshimi@lab.ntt.co.jp>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-recover-after-an-arch-module-load-failure drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-recover-after-an-arch-module-load-failure
+++ a/drivers/kvm/kvm_main.c
@@ -1944,17 +1944,17 @@ int kvm_init_arch(struct kvm_arch_ops *o
 		return -EEXIST;
 	}
 
-	kvm_arch_ops = ops;
-
-	if (!kvm_arch_ops->cpu_has_kvm_support()) {
+	if (!ops->cpu_has_kvm_support()) {
 		printk(KERN_ERR "kvm: no hardware support\n");
 		return -EOPNOTSUPP;
 	}
-	if (kvm_arch_ops->disabled_by_bios()) {
+	if (ops->disabled_by_bios()) {
 		printk(KERN_ERR "kvm: disabled by bios\n");
 		return -EOPNOTSUPP;
 	}
 
+	kvm_arch_ops = ops;
+
 	r = kvm_arch_ops->hardware_setup();
 	if (r < 0)
 	    return r;
_

Patches currently in -mm which might be from ichiyanagi.yoshimi@lab.ntt.co.jp are

kvm-recover-after-an-arch-module-load-failure.patch
