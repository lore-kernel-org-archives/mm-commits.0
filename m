From: akpm@osdl.org
Subject: + ehca-fix-kthread_create-error-check.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:42:31 -0800
Message-ID: <200612210342.kBL3gVmO014761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbWLUDnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:43:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com


The patch titled
     ehca: fix kthread_create() error check
has been added to the -mm tree.  Its filename is
     ehca-fix-kthread_create-error-check.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehca: fix kthread_create() error check
From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of kthread_create() should be checked by IS_ERR(). 
create_comp_task() returns the return value from kthread_create().

Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-kthread_create-error-check drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-kthread_create-error-check
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -670,11 +670,13 @@ static int comp_pool_callback(struct not
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct ehca_cpu_comp_task *cct;
+	struct task_struct *task;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
-		if(!create_comp_task(pool, cpu)) {
+		task = create_comp_task(pool, cpu);
+		if (IS_ERR(task)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
 			return NOTIFY_BAD;
 		}
@@ -730,7 +732,7 @@ int ehca_create_comp_pool(void)
 
 	for_each_online_cpu(cpu) {
 		task = create_comp_task(pool, cpu);
-		if (task) {
+		if (!IS_ERR(task)) {
 			kthread_bind(task, cpu);
 			wake_up_process(task);
 		}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
powerpc-use-is_init.patch
git-drm.patch
ehca-fix-kthread_create-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

