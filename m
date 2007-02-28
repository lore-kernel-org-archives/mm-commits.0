From: akpm@linux-foundation.org
Subject: - kvm-more-0-null-conversions.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:55 -0800
Message-ID: <200702282354.l1SNstu4031234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714AbXB1Xy6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: More 0 -> NULL conversions
has been removed from the -mm tree.  Its filename was
     kvm-more-0-null-conversions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: More 0 -> NULL conversions
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-more-0-null-conversions drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-more-0-null-conversions
+++ a/drivers/kvm/kvm_main.c
@@ -2229,13 +2229,13 @@ static void kvm_exit_debug(void)
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
 	decache_vcpus_on_cpu(raw_smp_processor_id());
-	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
