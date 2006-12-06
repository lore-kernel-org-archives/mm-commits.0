From: akpm@osdl.org
Subject: - i386-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:06 -0800
Message-ID: <200612062224.kB6MO6PI018586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937734AbWLFWYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     i386: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     i386-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   11 +++--------
 arch/i386/kernel/mca.c                 |   13 ++++---------
 arch/i386/kernel/pci-dma.c             |    6 ++----
 arch/i386/mach-voyager/voyager_cat.c   |    6 ++----
 include/asm-i386/thread_info.h         |   10 +---------
 include/linux/textsearch.h             |    3 +--
 6 files changed, 13 insertions(+), 36 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~i386-replace-kmallocmemset-with-kzalloc arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~i386-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -480,12 +480,10 @@ static int __cpuinit detect_cache_attrib
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	cpuid4_info[cpu] = kmalloc(
+	cpuid4_info[cpu] = kzalloc(
 	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
 	if (unlikely(cpuid4_info[cpu] == NULL))
 		return -ENOMEM;
-	memset(cpuid4_info[cpu], 0,
-	    sizeof(struct _cpuid4_info) * num_cache_leaves);
 
 	oldmask = current->cpus_allowed;
 	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -658,17 +656,14 @@ static int __cpuinit cpuid4_cache_sysfs_
 		return -ENOENT;
 
 	/* Allocate all required memory */
-	cache_kobject[cpu] = kmalloc(sizeof(struct kobject), GFP_KERNEL);
+	cache_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
 	if (unlikely(cache_kobject[cpu] == NULL))
 		goto err_out;
-	memset(cache_kobject[cpu], 0, sizeof(struct kobject));
 
-	index_kobject[cpu] = kmalloc(
+	index_kobject[cpu] = kzalloc(
 	    sizeof(struct _index_kobject ) * num_cache_leaves, GFP_KERNEL);
 	if (unlikely(index_kobject[cpu] == NULL))
 		goto err_out;
-	memset(index_kobject[cpu], 0,
-	    sizeof(struct _index_kobject) * num_cache_leaves);
 
 	return 0;
 
diff -puN arch/i386/kernel/mca.c~i386-replace-kmallocmemset-with-kzalloc arch/i386/kernel/mca.c
--- a/arch/i386/kernel/mca.c~i386-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/kernel/mca.c
@@ -283,10 +283,9 @@ static int __init mca_init(void)
 	bus->f.mca_transform_memory = mca_dummy_transform_memory;
 
 	/* get the motherboard device */
-	mca_dev = kmalloc(sizeof(struct mca_device), GFP_KERNEL);
+	mca_dev = kzalloc(sizeof(struct mca_device), GFP_KERNEL);
 	if(unlikely(!mca_dev))
 		goto out_nomem;
-	memset(mca_dev, 0, sizeof(struct mca_device));
 
 	/*
 	 * We do not expect many MCA interrupts during initialization,
@@ -310,11 +309,9 @@ static int __init mca_init(void)
 	mca_dev->slot = MCA_MOTHERBOARD;
 	mca_register_device(MCA_PRIMARY_BUS, mca_dev);
 
-	mca_dev = kmalloc(sizeof(struct mca_device), GFP_ATOMIC);
+	mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
 	if(unlikely(!mca_dev))
 		goto out_unlock_nomem;
-	memset(mca_dev, 0, sizeof(struct mca_device));
-
 
 	/* Put motherboard into video setup mode, read integrated video
 	 * POS registers, and turn motherboard setup off.
@@ -349,10 +346,9 @@ static int __init mca_init(void)
 	}
 	if(which_scsi) {
 		/* found a scsi card */
-		mca_dev = kmalloc(sizeof(struct mca_device), GFP_ATOMIC);
+		mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
 		if(unlikely(!mca_dev))
 			goto out_unlock_nomem;
-		memset(mca_dev, 0, sizeof(struct mca_device));
 
 		for(j = 0; j < 8; j++)
 			mca_dev->pos[j] = pos[j];
@@ -378,10 +374,9 @@ static int __init mca_init(void)
 		if(!mca_read_and_store_pos(pos))
 			continue;
 
-		mca_dev = kmalloc(sizeof(struct mca_device), GFP_ATOMIC);
+		mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
 		if(unlikely(!mca_dev))
 			goto out_unlock_nomem;
-		memset(mca_dev, 0, sizeof(struct mca_device));
 
 		for(j=0; j<8; j++)
 			mca_dev->pos[j]=pos[j];
diff -puN arch/i386/kernel/pci-dma.c~i386-replace-kmallocmemset-with-kzalloc arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~i386-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/kernel/pci-dma.c
@@ -92,14 +92,12 @@ int dma_declare_coherent_memory(struct d
 	if (!mem_base)
 		goto out;
 
-	dev->dma_mem = kmalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
+	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
 	if (!dev->dma_mem)
 		goto out;
-	memset(dev->dma_mem, 0, sizeof(struct dma_coherent_mem));
-	dev->dma_mem->bitmap = kmalloc(bitmap_size, GFP_KERNEL);
+	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dev->dma_mem->bitmap)
 		goto free1_out;
-	memset(dev->dma_mem->bitmap, 0, bitmap_size);
 
 	dev->dma_mem->virt_base = mem_base;
 	dev->dma_mem->device_base = device_addr;
diff -puN arch/i386/mach-voyager/voyager_cat.c~i386-replace-kmallocmemset-with-kzalloc arch/i386/mach-voyager/voyager_cat.c
--- a/arch/i386/mach-voyager/voyager_cat.c~i386-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/mach-voyager/voyager_cat.c
@@ -776,7 +776,7 @@ voyager_cat_init(void)
 		for(asic=0; asic < (*modpp)->num_asics; asic++) {
 			int j;
 			voyager_asic_t *asicp = *asicpp 
-				= kmalloc(sizeof(voyager_asic_t), GFP_KERNEL); /*&voyager_asic_storage[asic_count++];*/
+				= kzalloc(sizeof(voyager_asic_t), GFP_KERNEL); /*&voyager_asic_storage[asic_count++];*/
 			voyager_sp_table_t *sp_table;
 			voyager_at_t *asic_table;
 			voyager_jtt_t *jtag_table;
@@ -785,7 +785,6 @@ voyager_cat_init(void)
 				printk("**WARNING** kmalloc failure in cat_init\n");
 				continue;
 			}
-			memset(asicp, 0, sizeof(voyager_asic_t));
 			asicpp = &(asicp->next);
 			asicp->asic_location = asic;
 			sp_table = (voyager_sp_table_t *)(eprom_buf + sp_offset);
@@ -851,8 +850,7 @@ voyager_cat_init(void)
 #endif
 
 		{
-			struct resource *res = kmalloc(sizeof(struct resource),GFP_KERNEL);
-			memset(res, 0, sizeof(struct resource));
+			struct resource *res = kzalloc(sizeof(struct resource),GFP_KERNEL);
 			res->name = kmalloc(128, GFP_KERNEL);
 			sprintf((char *)res->name, "Voyager %s Quad CPI", cat_module_name(i));
 			res->start = qic_addr;
diff -puN include/asm-i386/thread_info.h~i386-replace-kmallocmemset-with-kzalloc include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~i386-replace-kmallocmemset-with-kzalloc
+++ a/include/asm-i386/thread_info.h
@@ -95,15 +95,7 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-	({							\
-		struct thread_info *ret;			\
-								\
-		ret = kmalloc(THREAD_SIZE, GFP_KERNEL);		\
-		if (ret)					\
-			memset(ret, 0, THREAD_SIZE);		\
-		ret;						\
-	})
+#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
 #else
 #define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
 #endif
diff -puN include/linux/textsearch.h~i386-replace-kmallocmemset-with-kzalloc include/linux/textsearch.h
--- a/include/linux/textsearch.h~i386-replace-kmallocmemset-with-kzalloc
+++ a/include/linux/textsearch.h
@@ -164,11 +164,10 @@ static inline struct ts_config *alloc_ts
 {
 	struct ts_config *conf;
 
-	conf = kmalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
+	conf = kzalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
 	if (conf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	memset(conf, 0, TS_PRIV_ALIGN(sizeof(*conf)) + payload);
 	return conf;
 }
 
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
acpi-replace-kmallocmemset-with-kzalloc.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch
usb-auerswald-replace-kmallocmemset-with-kzalloc.patch
kernel-core-replace-kmallocmemset-with-kzalloc.patch
isdn-replace-kmallocmemset-with-kzalloc.patch

