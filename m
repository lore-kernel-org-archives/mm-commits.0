From: akpm@osdl.org
Subject: - kvm-recover-after-an-arch-module-load-failure.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:15 -0800
Message-ID: <200701070758.l077wFpT012942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40728 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbXAGH6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ichiyanagi.yoshimi@lab.ntt.co.jp, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Recover after an arch module load failure
has been removed from the -mm tree.  Its filename was
     kvm-recover-after-an-arch-module-load-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 4 deletions(-)

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
