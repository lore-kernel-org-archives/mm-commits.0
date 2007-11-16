From: akpm@linux-foundation.org
Subject: + iucv-axplicitly-code-allocpercpu-calls.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:48:53 -0800
Message-ID: <200711160048.lAG0mr6e024477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259AbXKPAtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, davem@davemloft.net, schwidefsky@de.ibm.com


The patch titled
     iucv: axplicitly code allocpercpu calls
has been added to the -mm tree.  Its filename is
     iucv-axplicitly-code-allocpercpu-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iucv: axplicitly code allocpercpu calls
From: Christoph Lameter <clameter@sgi.com>

iucv is the only user of the various functions that are used to bring parts
of cpus up and down.  Its the only allocpercpu user that will do I/O on per
cpu objects (which is difficult to do with virtually mapped memory).  And
its the only use of allocpercpu where a GFP_DMA allocation is done.

Remove the allocpercpu calls from iucv and code the allocation and freeing
manually.  After this patch it is possible to remove a large part of the
allocpercpu API.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/iucv/iucv.c |  107 ++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 46 deletions(-)

diff -puN net/iucv/iucv.c~iucv-axplicitly-code-allocpercpu-calls net/iucv/iucv.c
--- a/net/iucv/iucv.c~iucv-axplicitly-code-allocpercpu-calls
+++ a/net/iucv/iucv.c
@@ -97,7 +97,7 @@ struct iucv_irq_list {
 	struct iucv_irq_data data;
 };
 
-static struct iucv_irq_data *iucv_irq_data;
+static struct iucv_irq_data *iucv_irq_data[NR_CPUS];
 static cpumask_t iucv_buffer_cpumask = CPU_MASK_NONE;
 static cpumask_t iucv_irq_cpumask = CPU_MASK_NONE;
 
@@ -277,7 +277,7 @@ union iucv_param {
 /*
  * Anchor for per-cpu IUCV command parameter block.
  */
-static union iucv_param *iucv_param;
+static union iucv_param *iucv_param[NR_CPUS];
 
 /**
  * iucv_call_b2f0
@@ -356,7 +356,7 @@ static void iucv_allow_cpu(void *data)
 	 *	0x10 - Flag to allow priority message completion interrupts
 	 *	0x08 - Flag to allow IUCV control interrupts
 	 */
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[cpu];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->set_mask.ipmask = 0xf8;
 	iucv_call_b2f0(IUCV_SETMASK, parm);
@@ -377,7 +377,7 @@ static void iucv_block_cpu(void *data)
 	union iucv_param *parm;
 
 	/* Disable all iucv interrupts. */
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[cpu];
 	memset(parm, 0, sizeof(union iucv_param));
 	iucv_call_b2f0(IUCV_SETMASK, parm);
 
@@ -401,9 +401,9 @@ static void iucv_declare_cpu(void *data)
 		return;
 
 	/* Declare interrupt buffer. */
-	parm = percpu_ptr(iucv_param, cpu);
+	parm = iucv_param[cpu];
 	memset(parm, 0, sizeof(union iucv_param));
-	parm->db.ipbfadr1 = virt_to_phys(percpu_ptr(iucv_irq_data, cpu));
+	parm->db.ipbfadr1 = virt_to_phys(iucv_irq_data[cpu]);
 	rc = iucv_call_b2f0(IUCV_DECLARE_BUFFER, parm);
 	if (rc) {
 		char *err = "Unknown";
@@ -458,7 +458,7 @@ static void iucv_retrieve_cpu(void *data
 	iucv_block_cpu(NULL);
 
 	/* Retrieve interrupt buffer. */
-	parm = percpu_ptr(iucv_param, cpu);
+	parm = iucv_param[cpu];
 	iucv_call_b2f0(IUCV_RETRIEVE_BUFFER, parm);
 
 	/* Clear indication that an iucv buffer exists for this cpu. */
@@ -558,22 +558,23 @@ static int __cpuinit iucv_cpu_notify(str
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!percpu_populate(iucv_irq_data,
-				     sizeof(struct iucv_irq_data),
-				     GFP_KERNEL|GFP_DMA, cpu))
+		iucv_irq_data[cpu] = kmalloc_node(sizeof(struct iucv_irq_data),
+					GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
+		if (!iucv_irq_data[cpu])
 			return NOTIFY_BAD;
-		if (!percpu_populate(iucv_param, sizeof(union iucv_param),
-				     GFP_KERNEL|GFP_DMA, cpu)) {
-			percpu_depopulate(iucv_irq_data, cpu);
+		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
+				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
+		if (!iucv_param[cpu])
 			return NOTIFY_BAD;
-		}
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		percpu_depopulate(iucv_param, cpu);
-		percpu_depopulate(iucv_irq_data, cpu);
+		kfree(iucv_param[cpu]);
+		iucv_param[cpu] = NULL;
+		kfree(iucv_irq_data[cpu]);
+		iucv_irq_data[cpu] = NULL;
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
@@ -612,7 +613,7 @@ static int iucv_sever_pathid(u16 pathid,
 {
 	union iucv_param *parm;
 
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (userdata)
 		memcpy(parm->ctrl.ipuser, userdata, sizeof(parm->ctrl.ipuser));
@@ -755,7 +756,7 @@ int iucv_path_accept(struct iucv_path *p
 
 	local_bh_disable();
 	/* Prepare parameter block. */
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->ctrl.ippathid = path->pathid;
 	parm->ctrl.ipmsglim = path->msglim;
@@ -799,7 +800,7 @@ int iucv_path_connect(struct iucv_path *
 	BUG_ON(in_atomic());
 	spin_lock_bh(&iucv_table_lock);
 	iucv_cleanup_queue();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->ctrl.ipmsglim = path->msglim;
 	parm->ctrl.ipflags1 = path->flags;
@@ -854,7 +855,7 @@ int iucv_path_quiesce(struct iucv_path *
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (userdata)
 		memcpy(parm->ctrl.ipuser, userdata, sizeof(parm->ctrl.ipuser));
@@ -881,7 +882,7 @@ int iucv_path_resume(struct iucv_path *p
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (userdata)
 		memcpy(parm->ctrl.ipuser, userdata, sizeof(parm->ctrl.ipuser));
@@ -936,7 +937,7 @@ int iucv_message_purge(struct iucv_path 
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->purge.ippathid = path->pathid;
 	parm->purge.ipmsgid = msg->id;
@@ -1003,7 +1004,7 @@ int iucv_message_receive(struct iucv_pat
 	}
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->db.ipbfadr1 = (u32)(addr_t) buffer;
 	parm->db.ipbfln1f = (u32) size;
@@ -1040,7 +1041,7 @@ int iucv_message_reject(struct iucv_path
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->db.ippathid = path->pathid;
 	parm->db.ipmsgid = msg->id;
@@ -1074,7 +1075,7 @@ int iucv_message_reply(struct iucv_path 
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (flags & IUCV_IPRMDATA) {
 		parm->dpl.ippathid = path->pathid;
@@ -1118,7 +1119,7 @@ int iucv_message_send(struct iucv_path *
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (flags & IUCV_IPRMDATA) {
 		/* Message of 8 bytes can be placed into the parameter list. */
@@ -1172,7 +1173,7 @@ int iucv_message_send2way(struct iucv_pa
 	int rc;
 
 	local_bh_disable();
-	parm = percpu_ptr(iucv_param, smp_processor_id());
+	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	if (flags & IUCV_IPRMDATA) {
 		parm->dpl.ippathid = path->pathid;
@@ -1559,7 +1560,7 @@ static void iucv_external_interrupt(u16 
 	struct iucv_irq_data *p;
 	struct iucv_irq_list *work;
 
-	p = percpu_ptr(iucv_irq_data, smp_processor_id());
+	p = iucv_irq_data[smp_processor_id()];
 	if (p->ippathid >= iucv_max_pathid) {
 		printk(KERN_WARNING "iucv_do_int: Got interrupt with "
 		       "pathid %d > max_connections (%ld)\n",
@@ -1598,6 +1599,7 @@ static void iucv_external_interrupt(u16 
 static int __init iucv_init(void)
 {
 	int rc;
+	int cpu;
 
 	if (!MACHINE_IS_VM) {
 		rc = -EPROTONOSUPPORT;
@@ -1617,19 +1619,23 @@ static int __init iucv_init(void)
 		rc = PTR_ERR(iucv_root);
 		goto out_bus;
 	}
-	/* Note: GFP_DMA used to get memory below 2G */
-	iucv_irq_data = percpu_alloc(sizeof(struct iucv_irq_data),
-				     GFP_KERNEL|GFP_DMA);
-	if (!iucv_irq_data) {
-		rc = -ENOMEM;
-		goto out_root;
-	}
-	/* Allocate parameter blocks. */
-	iucv_param = percpu_alloc(sizeof(union iucv_param),
-				  GFP_KERNEL|GFP_DMA);
-	if (!iucv_param) {
-		rc = -ENOMEM;
-		goto out_extint;
+
+	for_each_online_cpu(cpu) {
+		/* Note: GFP_DMA used to get memory below 2G */
+		iucv_irq_data[cpu] = kmalloc_node(sizeof(struct iucv_irq_data),
+				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
+		if (!iucv_irq_data[cpu]) {
+			rc = -ENOMEM;
+			goto out_free;
+		}
+
+		/* Allocate parameter blocks. */
+		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
+				  GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
+		if (!iucv_param[cpu]) {
+			rc = -ENOMEM;
+			goto out_free;
+		}
 	}
 	register_hotcpu_notifier(&iucv_cpu_notifier);
 	ASCEBC(iucv_error_no_listener, 16);
@@ -1638,9 +1644,13 @@ static int __init iucv_init(void)
 	iucv_available = 1;
 	return 0;
 
-out_extint:
-	percpu_free(iucv_irq_data);
-out_root:
+out_free:
+	for_each_possible_cpu(cpu) {
+		kfree(iucv_param[cpu]);
+		iucv_param[cpu] = NULL;
+		kfree(iucv_irq_data[cpu]);
+		iucv_irq_data[cpu] = NULL;
+	}
 	s390_root_dev_unregister(iucv_root);
 out_bus:
 	bus_unregister(&iucv_bus);
@@ -1658,6 +1668,7 @@ out:
 static void __exit iucv_exit(void)
 {
 	struct iucv_irq_list *p, *n;
+	int cpu;
 
 	spin_lock_irq(&iucv_queue_lock);
 	list_for_each_entry_safe(p, n, &iucv_task_queue, list)
@@ -1666,8 +1677,12 @@ static void __exit iucv_exit(void)
 		kfree(p);
 	spin_unlock_irq(&iucv_queue_lock);
 	unregister_hotcpu_notifier(&iucv_cpu_notifier);
-	percpu_free(iucv_param);
-	percpu_free(iucv_irq_data);
+	for_each_possible_cpu(cpu) {
+		kfree(iucv_param[cpu]);
+		iucv_param[cpu] = NULL;
+		kfree(iucv_irq_data[cpu]);
+		iucv_irq_data[cpu] = NULL;
+	}
 	s390_root_dev_unregister(iucv_root);
 	bus_unregister(&iucv_bus);
 	unregister_external_interrupt(0x4000, iucv_external_interrupt);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
iucv-axplicitly-code-allocpercpu-calls.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
x86_64-configure-stack-size-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
