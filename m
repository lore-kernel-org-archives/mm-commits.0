From: akpm@linux-foundation.org
Subject: - cell-pmi-remove-support-for-mutiple-devices.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:23:26 -0700
Message-ID: <200707190023.l6J0NRtf004720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbXGSAXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:23:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cell: pmi: remove support for mutiple devices.
has been removed from the -mm tree.  Its filename was
     cell-pmi-remove-support-for-mutiple-devices.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cell: pmi: remove support for mutiple devices.
From: Christian Krafft <krafft@de.ibm.com>

The pmi driver got simplified by removing support for multiple devices.  As
there is no more than one pmi device per maschine, there is no need to specify
the device for listening and sending messages.

This way the caller (cbe_cpufreq) doesn't need to scan the device tree.  When
registering the handler on a board without a pmi interface, pmi.c will just
return -ENODEV.

The patch that fixed the breakage of cell_defconfig has been broken out of the
earlier version of this patch.  So this is the version that applies cleanly on
top of it.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq.c |   36 +++++---------
 arch/powerpc/sysdev/pmi.c                 |   51 ++++++++------------
 include/asm-powerpc/pmi.h                 |    8 +--
 3 files changed, 40 insertions(+), 55 deletions(-)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-pmi-remove-support-for-mutiple-devices arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-pmi-remove-support-for-mutiple-devices
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -68,11 +68,12 @@ static u64 MIC_Slow_Next_Timer_table[] =
 };
 
 static unsigned int pmi_frequency_limit = 0;
+
 /*
  * hardware specific functions
  */
 
-static struct of_device *pmi_dev;
+static bool cbe_cpufreq_has_pmi;
 
 #ifdef CONFIG_PPC_PMI
 static int set_pmode_pmi(int cpu, unsigned int pmode)
@@ -91,7 +92,7 @@ static int set_pmode_pmi(int cpu, unsign
 	time = (u64) get_cycles();
 #endif
 
-	pmi_send_message(pmi_dev, pmi_msg);
+	pmi_send_message(pmi_msg);
 	ret = pmi_msg.data2;
 
 	pr_debug("PMI returned slow mode %d\n", ret);
@@ -157,16 +158,16 @@ static int set_pmode_reg(int cpu, unsign
 	return 0;
 }
 
-static int set_pmode(int cpu, unsigned int slow_mode) {
+static int set_pmode(int cpu, unsigned int slow_mode)
+{
 #ifdef CONFIG_PPC_PMI
-	if (pmi_dev)
+	if (cbe_cpufreq_has_pmi)
 		return set_pmode_pmi(cpu, slow_mode);
-	else
 #endif
-		return set_pmode_reg(cpu, slow_mode);
+	return set_pmode_reg(cpu, slow_mode);
 }
 
-static void cbe_cpufreq_handle_pmi(struct of_device *dev, pmi_message_t pmi_msg)
+static void cbe_cpufreq_handle_pmi(pmi_message_t pmi_msg)
 {
 	u8 cpu;
 	u8 cbe_pmode_new;
@@ -253,7 +254,7 @@ static int cbe_cpufreq_cpu_init(struct c
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
 
-	if (pmi_dev) {
+	if (cbe_cpufreq_has_pmi) {
 		/* frequency might get limited later, initialize limit with max_freq */
 		pmi_frequency_limit = max_freq;
 		cpufreq_register_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
@@ -265,7 +266,7 @@ static int cbe_cpufreq_cpu_init(struct c
 
 static int cbe_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (pmi_dev)
+	if (cbe_cpufreq_has_pmi)
 		cpufreq_unregister_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
 
 	cpufreq_frequency_table_put_attr(policy->cpu);
@@ -326,29 +327,20 @@ static struct cpufreq_driver cbe_cpufreq
 
 static int __init cbe_cpufreq_init(void)
 {
-#ifdef CONFIG_PPC_PMI
-	struct device_node *np;
-#endif
 	if (!machine_is(cell))
 		return -ENODEV;
-#ifdef CONFIG_PPC_PMI
-	np = of_find_node_by_type(NULL, "ibm,pmi");
 
-	pmi_dev = of_find_device_by_node(np);
+	cbe_cpufreq_has_pmi = pmi_register_handler(&cbe_pmi_handler) == 0;
 
-	if (pmi_dev)
-		pmi_register_handler(pmi_dev, &cbe_pmi_handler);
-#endif
 	return cpufreq_register_driver(&cbe_cpufreq_driver);
 }
 
 static void __exit cbe_cpufreq_exit(void)
 {
-#ifdef CONFIG_PPC_PMI
-	if (pmi_dev)
-		pmi_unregister_handler(pmi_dev, &cbe_pmi_handler);
-#endif
 	cpufreq_unregister_driver(&cbe_cpufreq_driver);
+
+	if (cbe_cpufreq_has_pmi)
+		pmi_unregister_handler(&cbe_pmi_handler);
 }
 
 module_init(cbe_cpufreq_init);
diff -puN arch/powerpc/sysdev/pmi.c~cell-pmi-remove-support-for-mutiple-devices arch/powerpc/sysdev/pmi.c
--- a/arch/powerpc/sysdev/pmi.c~cell-pmi-remove-support-for-mutiple-devices
+++ a/arch/powerpc/sysdev/pmi.c
@@ -48,15 +48,13 @@ struct pmi_data {
 	struct work_struct	work;
 };
 
+static struct pmi_data *data;
 
 static int pmi_irq_handler(int irq, void *dev_id)
 {
-	struct pmi_data *data;
 	u8 type;
 	int rc;
 
-	data = dev_id;
-
 	spin_lock(&data->pmi_spinlock);
 
 	type = ioread8(data->pmi_reg + PMI_READ_TYPE);
@@ -111,16 +109,13 @@ MODULE_DEVICE_TABLE(of, pmi_match);
 
 static void pmi_notify_handlers(struct work_struct *work)
 {
-	struct pmi_data *data;
 	struct pmi_handler *handler;
 
-	data = container_of(work, struct pmi_data, work);
-
 	spin_lock(&data->handler_spinlock);
 	list_for_each_entry(handler, &data->handler, node) {
 		pr_debug(KERN_INFO "pmi: notifying handler %p\n", handler);
 		if (handler->type == data->msg.type)
-			handler->handle_pmi_message(data->dev, data->msg);
+			handler->handle_pmi_message(data->msg);
 	}
 	spin_unlock(&data->handler_spinlock);
 }
@@ -129,9 +124,14 @@ static int pmi_of_probe(struct of_device
 			const struct of_device_id *match)
 {
 	struct device_node *np = dev->node;
-	struct pmi_data *data;
 	int rc;
 
+	if (data) {
+		printk(KERN_ERR "pmi: driver has already been initialized.\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
 	data = kzalloc(sizeof(struct pmi_data), GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR "pmi: could not allocate memory.\n");
@@ -154,7 +154,6 @@ static int pmi_of_probe(struct of_device
 
 	INIT_WORK(&data->work, pmi_notify_handlers);
 
-	dev->dev.driver_data = data;
 	data->dev = dev;
 
 	data->irq = irq_of_parse_and_map(np, 0);
@@ -164,7 +163,7 @@ static int pmi_of_probe(struct of_device
 		goto error_cleanup_iomap;
 	}
 
-	rc = request_irq(data->irq, pmi_irq_handler, 0, "pmi", data);
+	rc = request_irq(data->irq, pmi_irq_handler, 0, "pmi", NULL);
 	if (rc) {
 		printk(KERN_ERR "pmi: can't request IRQ %d: returned %d\n",
 				data->irq, rc);
@@ -187,12 +186,9 @@ out:
 
 static int pmi_of_remove(struct of_device *dev)
 {
-	struct pmi_data *data;
 	struct pmi_handler *handler, *tmp;
 
-	data = dev->dev.driver_data;
-
-	free_irq(data->irq, data);
+	free_irq(data->irq, NULL);
 	iounmap(data->pmi_reg);
 
 	spin_lock(&data->handler_spinlock);
@@ -202,7 +198,8 @@ static int pmi_of_remove(struct of_devic
 
 	spin_unlock(&data->handler_spinlock);
 
-	kfree(dev->dev.driver_data);
+	kfree(data);
+	data = NULL;
 
 	return 0;
 }
@@ -226,13 +223,13 @@ static void __exit pmi_module_exit(void)
 }
 module_exit(pmi_module_exit);
 
-void pmi_send_message(struct of_device *device, pmi_message_t msg)
+int pmi_send_message(pmi_message_t msg)
 {
-	struct pmi_data *data;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(completion);
 
-	data = device->dev.driver_data;
+	if (!data)
+		return -ENODEV;
 
 	mutex_lock(&data->msg_mutex);
 
@@ -256,30 +253,26 @@ void pmi_send_message(struct of_device *
 	data->completion = NULL;
 
 	mutex_unlock(&data->msg_mutex);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(pmi_send_message);
 
-void pmi_register_handler(struct of_device *device,
-			  struct pmi_handler *handler)
+int pmi_register_handler(struct pmi_handler *handler)
 {
-	struct pmi_data *data;
-	data = device->dev.driver_data;
-
 	if (!data)
-		return;
+		return -ENODEV;
 
 	spin_lock(&data->handler_spinlock);
 	list_add_tail(&handler->node, &data->handler);
 	spin_unlock(&data->handler_spinlock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(pmi_register_handler);
 
-void pmi_unregister_handler(struct of_device *device,
-			    struct pmi_handler *handler)
+void pmi_unregister_handler(struct pmi_handler *handler)
 {
-	struct pmi_data *data;
-	data = device->dev.driver_data;
-
 	if (!data)
 		return;
 
diff -puN include/asm-powerpc/pmi.h~cell-pmi-remove-support-for-mutiple-devices include/asm-powerpc/pmi.h
--- a/include/asm-powerpc/pmi.h~cell-pmi-remove-support-for-mutiple-devices
+++ a/include/asm-powerpc/pmi.h
@@ -55,13 +55,13 @@ typedef struct {
 struct pmi_handler {
 	struct list_head node;
 	u8 type;
-	void (*handle_pmi_message) (struct of_device *, pmi_message_t);
+	void (*handle_pmi_message) (pmi_message_t);
 };
 
-void pmi_register_handler(struct of_device *, struct pmi_handler *);
-void pmi_unregister_handler(struct of_device *, struct pmi_handler *);
+int pmi_register_handler(struct pmi_handler *);
+void pmi_unregister_handler(struct pmi_handler *);
 
-void pmi_send_message(struct of_device *, pmi_message_t);
+int pmi_send_message(pmi_message_t);
 
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PMI_H */
_

Patches currently in -mm which might be from krafft@de.ibm.com are

cell-pmi-remove-support-for-mutiple-devices.patch
cell-cbe_cpufreq-fix-latency-measurement.patch
cell-cbe_cpufreq-fix-initialization.patch
cell-cbe_cpufreq-fix-minor-issues.patch
cell-cbe_cpufreq-reorganize-code.patch
cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
