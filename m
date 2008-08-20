From: akpm@linux-foundation.org
Subject: - kvm-make-functions-static.patch removed from -mm tree
Date: Wed, 20 Aug 2008 13:12:55 -0700
Message-ID: <200808202012.m7KKCtZE029368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbYHTUM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 16:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: make functions static
has been removed from the -mm tree.  Its filename was
     kvm-make-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>

sparse says:

arch/x86/kvm/x86.c:107:32: warning: symbol 'kvm_find_assigned_dev' was not declared. Should it be static?
arch/x86/kvm/i8254.c:225:6: warning: symbol 'kvm_pit_ack_irq' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kvm/i8254.c~kvm-make-functions-static arch/x86/kvm/i8254.c
--- a/arch/x86/kvm/i8254.c~kvm-make-functions-static
+++ a/arch/x86/kvm/i8254.c
@@ -222,7 +222,7 @@ int pit_has_pending_timer(struct kvm_vcp
 	return 0;
 }
 
-void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
+static void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
 {
 	struct kvm_kpit_state *ps = container_of(kian, struct kvm_kpit_state,
 						 irq_ack_notifier);
diff -puN arch/x86/kvm/x86.c~kvm-make-functions-static arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~kvm-make-functions-static
+++ a/arch/x86/kvm/x86.c
@@ -104,7 +104,7 @@ struct kvm_stats_debugfs_item debugfs_en
 	{ NULL }
 };
 
-struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
+static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
 						      int assigned_dev_id)
 {
 	struct list_head *ptr;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

