From: akpm@linux-foundation.org
Subject: - rcu-spinlocks-take-an-unsigned-long-flags.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:14 -0700
Message-ID: <200809130746.m8D7kEpR026836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbYIMHqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, h-shimamoto@ct.jp.nec.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: spinlocks take an unsigned long flags
has been removed from the -mm tree.  Its filename was
     rcu-spinlocks-take-an-unsigned-long-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: spinlocks take an unsigned long flags
From: Harvey Harrison <harvey.harrison@gmail.com>

Noticed by sparse:
kernel/rcuclassic.c:719:2: error: incompatible types in comparison expression (different signedness)
kernel/rcuclassic.c:727:2: error: incompatible types in comparison expression (different signedness)
kernel/rcuclassic.c: In function `rcu_init_percpu_data':
kernel/rcuclassic.c:719: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:727: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcuclassic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcuclassic.c~rcu-spinlocks-take-an-unsigned-long-flags kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-spinlocks-take-an-unsigned-long-flags
+++ a/kernel/rcuclassic.c
@@ -714,7 +714,7 @@ void rcu_check_callbacks(int cpu, int us
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
-	long flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
fbcon-fix-monochrome-color-value-calculation.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch

