From: akpm@osdl.org
Subject: - kvm-do-not-export-unsupported-msrs-to-userspace.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:17 -0800
Message-ID: <200612230753.kBN7rHfA010110@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49592 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbWLWHx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@mr511.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Do not export unsupported msrs to userspace
has been removed from the -mm tree.  Its filename was
     kvm-do-not-export-unsupported-msrs-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Do not export unsupported msrs to userspace
From: Michael Riepe <michael@mr511.de>

Some msrs, such as MSR_STAR, are not available on all processors.  Exporting
them causes qemu to try to fetch them, which will fail.

So, check all msrs for validity at module load time.

Signed-off-by: Michael Riepe <michael@mr511.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-do-not-export-unsupported-msrs-to-userspace drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-do-not-export-unsupported-msrs-to-userspace
+++ a/drivers/kvm/kvm_main.c
@@ -1417,6 +1417,9 @@ static int kvm_dev_ioctl_set_sregs(struc
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
+ *
+ * This list is modified at module load time to reflect the
+ * capabilities of the host cpu.
  */
 static u32 msrs_to_save[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
@@ -1427,6 +1430,22 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_TIME_STAMP_COUNTER,
 };
 
+static unsigned num_msrs_to_save;
+
+static __init void kvm_init_msr_list(void)
+{
+	u32 dummy[2];
+	unsigned i, j;
+
+	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
+		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
+			continue;
+		if (j < i)
+			msrs_to_save[j] = msrs_to_save[i];
+		j++;
+	}
+	num_msrs_to_save = j;
+}
 
 /*
  * Adapt set_msr() to msr_io()'s calling convention
@@ -1735,15 +1754,15 @@ static long kvm_dev_ioctl(struct file *f
 		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
 			goto out;
 		n = msr_list.nmsrs;
-		msr_list.nmsrs = ARRAY_SIZE(msrs_to_save);
+		msr_list.nmsrs = num_msrs_to_save;
 		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
 			goto out;
 		r = -E2BIG;
-		if (n < ARRAY_SIZE(msrs_to_save))
+		if (n < num_msrs_to_save)
 			goto out;
 		r = -EFAULT;
 		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
-				 sizeof msrs_to_save))
+				 num_msrs_to_save * sizeof(u32)))
 			goto out;
 		r = 0;
 	}
@@ -1894,6 +1913,8 @@ static __init int kvm_init(void)
 
 	kvm_init_debug();
 
+	kvm_init_msr_list();
+
 	if ((bad_page = alloc_page(GFP_KERNEL)) == NULL) {
 		r = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from michael@mr511.de are

origin.patch

