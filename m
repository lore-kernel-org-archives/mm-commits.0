From: akpm@linux-foundation.org
Subject: - drivers-edac-add-edac_device-class.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:21 -0700
Message-ID: <200707192005.l6JK5LrY020038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759983AbXGSUQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add edac_device class
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-edac_device-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add edac_device class
From: Douglas Thompson <dougthompson@xmission.com>

This patch adds the new 'class' of object to be managed, named: 'edac_device'.

As a peer of the 'edac_mc' class of object, it provides a non-memory centric
view of an ERROR DETECTING device in hardware. It provides a sysfs interface
and an abstraction for varioius EDAC type devices.

Multiple 'instances' within the class are possible, with each 'instance'
able to have multiple 'blocks', and each 'block' having 'attributes'.

At the 'block' level there are the 'ce_count' and 'ue_count' fields
which the device driver can update and/or call edac_device_handle_XX()
functions. At each higher level are additional 'total' count fields,
which are a summation of counts below that level.

This 'edac_device' has been used to capture and present ECC errors
which are found in a a L1 and L2 system on a per CORE/CPU basis.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Makefile            |    4 
 drivers/edac/edac_core.h         |  252 ++++++++
 drivers/edac/edac_device.c       |  669 +++++++++++++++++++++++
 drivers/edac/edac_device_sysfs.c |  837 +++++++++++++++++++++++++++++
 drivers/edac/edac_mc.c           |    8 
 drivers/edac/edac_mc_sysfs.c     |   70 +-
 drivers/edac/edac_module.c       |  147 ++++-
 drivers/edac/edac_module.h       |    9 
 8 files changed, 1936 insertions(+), 60 deletions(-)

diff -puN drivers/edac/Makefile~drivers-edac-add-edac_device-class drivers/edac/Makefile
--- a/drivers/edac/Makefile~drivers-edac-add-edac_device-class
+++ a/drivers/edac/Makefile
@@ -10,9 +10,9 @@
 
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
-edac_core-objs	:= edac_mc.o edac_mc_sysfs.o edac_pci_sysfs.o
+edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
 
-edac_core-objs	+= edac_module.o
+edac_core-objs	+= edac_module.o edac_device_sysfs.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_E7XXX)		+= e7xxx_edac.o
diff -puN drivers/edac/edac_core.h~drivers-edac-add-edac_device-class drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-add-edac_device-class
+++ a/drivers/edac/edac_core.h
@@ -32,9 +32,14 @@
 #include <linux/completion.h>
 #include <linux/kobject.h>
 #include <linux/platform_device.h>
+#include <linux/sysdev.h>
+#include <linux/workqueue.h>
+#include <linux/version.h>
 
 #define EDAC_MC_LABEL_LEN	31
-#define MC_PROC_NAME_MAX_LEN 7
+#define EDAC_DEVICE_NAME_LEN	31
+#define EDAC_ATTRIB_VALUE_LEN	15
+#define MC_PROC_NAME_MAX_LEN	7
 
 #if PAGE_SHIFT < 20
 #define PAGES_TO_MiB( pages )	( ( pages ) >> ( 20 - PAGE_SHIFT ) )
@@ -51,6 +56,10 @@
 #define edac_mc_chipset_printk(mci, level, prefix, fmt, arg...) \
 	printk(level "EDAC " prefix " MC%d: " fmt, mci->mc_idx, ##arg)
 
+/* edac_device printk */
+#define edac_device_printk(ctl, level, fmt, arg...) \
+	printk(level "EDAC DEVICE%d: " fmt, ctl->dev_idx, ##arg)
+
 /* prefixes for edac_printk() and edac_mc_printk() */
 #define EDAC_MC "MC"
 #define EDAC_PCI "PCI"
@@ -62,7 +71,7 @@ extern int edac_debug_level;
 #define edac_debug_printk(level, fmt, arg...)                            \
 	do {                                                             \
 		if (level <= edac_debug_level)                           \
-			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
+			edac_printk(KERN_EMERG, EDAC_DEBUG, fmt, ##arg); \
 	} while(0)
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
@@ -195,6 +204,8 @@ enum scrub_type {
 
 /* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
 
+extern char * edac_align_ptr(void *ptr, unsigned size);
+
 /*
  * There are several things to be aware of that aren't at all obvious:
  *
@@ -376,6 +387,231 @@ struct mem_ctl_info {
 	struct completion kobj_complete;
 };
 
+/*
+ * The following are the structures to provide for a generice
+ * or abstract 'edac_device'. This set of structures and the
+ * code that implements the APIs for the same, provide for
+ * registering EDAC type devices which are NOT standard memory.
+ *
+ * CPU caches (L1 and L2)
+ * DMA engines
+ * Core CPU swithces
+ * Fabric switch units
+ * PCIe interface controllers
+ * other EDAC/ECC type devices that can be monitored for
+ * errors, etc.
+ *
+ * It allows for a 2 level set of hiearchry. For example:
+ *
+ * cache could be composed of L1, L2 and L3 levels of cache.
+ * Each CPU core would have its own L1 cache, while sharing
+ * L2 and maybe L3 caches.
+ *
+ * View them arranged, via the sysfs presentation:
+ * /sys/devices/system/edac/..
+ *
+ *	mc/		<existing memory device directory>
+ *	cpu/cpu0/..	<L1 and L2 block directory>
+ *		/L1-cache/ce_count
+ *			 /ue_count
+ *		/L2-cache/ce_count
+ *			 /ue_count
+ *	cpu/cpu1/..	<L1 and L2 block directory>
+ *		/L1-cache/ce_count
+ *			 /ue_count
+ *		/L2-cache/ce_count
+ *			 /ue_count
+ *	...
+ *
+ *	the L1 and L2 directories would be "edac_device_block's"
+ */
+
+struct edac_device_counter {
+	u32	ue_count;
+	u32	ce_count;
+};
+
+#define INC_COUNTER(cnt)	(cnt++)
+
+/*
+ * An array of these is passed to the alloc() function
+ * to specify attributes of the edac_block
+ */
+struct edac_attrib_spec {
+	char  name[EDAC_DEVICE_NAME_LEN + 1];
+
+	int type;
+#define	EDAC_ATTR_INT		0x01
+#define EDAC_ATTR_CHAR		0x02
+};
+
+
+/* Attribute control structure
+ * In this structure is a pointer to the driver's edac_attrib_spec
+ * The life of this pointer is inclusive in the life of the driver's
+ * life cycle.
+ */
+struct edac_attrib {
+	struct edac_device_block *block;	/* Up Pointer */
+
+	struct edac_attrib_spec *spec;		/* ptr to module spec entry */
+
+	union {					/* actual value */
+		int edac_attrib_int_value;
+		char edac_attrib_char_value[EDAC_ATTRIB_VALUE_LEN + 1];
+	} edac_attrib_value;
+};
+
+/* device block control structure */
+struct edac_device_block {
+	struct edac_device_instance *instance;	/* Up Pointer */
+	char  name[EDAC_DEVICE_NAME_LEN + 1];
+
+	struct edac_device_counter counters;	/* basic UE and CE counters */
+
+	int nr_attribs;				/* how many attributes */
+	struct edac_attrib *attribs;		/* this block's attributes */
+
+	/* edac sysfs device control */
+	struct kobject kobj;
+	struct completion kobj_complete;
+};
+
+/* device instance control structure */
+struct edac_device_instance {
+	struct edac_device_ctl_info *ctl;	/* Up pointer */
+	char name[EDAC_DEVICE_NAME_LEN + 4];
+
+	struct edac_device_counter counters;	/* instance counters */
+
+	u32 nr_blocks;				/* how many blocks */
+	struct edac_device_block *blocks;	/* block array */
+
+	/* edac sysfs device control */
+	struct kobject kobj;
+	struct completion kobj_complete;
+};
+
+
+/*
+ * Abstract edac_device control info structure
+ *
+ */
+struct edac_device_ctl_info {
+	/* for global list of edac_device_ctl_info structs */
+	struct list_head link;
+
+	int dev_idx;
+
+	/* Per instance controls for this edac_device */
+	int log_ue;		/* boolean for logging UEs */
+	int log_ce;		/* boolean for logging CEs */
+	int panic_on_ue;	/* boolean for panic'ing on an UE */
+	unsigned poll_msec;	/* number of milliseconds to poll interval */
+	unsigned long delay;	/* number of jiffies for poll_msec */
+
+	struct sysdev_class *edac_class;	/* pointer to class */
+
+	/* the internal state of this controller instance */
+	int op_state;
+#define	OP_ALLOC		0x100
+#define OP_RUNNING_POLL		0x201
+#define OP_RUNNING_INTERRUPT	0x202
+#define OP_RUNNING_POLL_INTR	0x203
+#define OP_OFFLINE		0x300
+
+	/* work struct for this instance */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	struct delayed_work work;
+#else
+	struct work_struct work;
+#endif
+
+	/* pointer to edac polling checking routine:
+	 *	If NOT NULL: points to polling check routine
+	 *	If NULL: Then assumes INTERRUPT operation, where
+	 *		MC driver will receive events
+	 */
+	void (*edac_check) (struct edac_device_ctl_info * edac_dev);
+
+	struct device *dev;	/* pointer to device structure */
+
+	const char *mod_name;	/* module name */
+	const char *ctl_name;	/* edac controller  name */
+
+	void *pvt_info;		/* pointer to 'private driver' info */
+
+	unsigned long start_time;/* edac_device load start time (jiffies)*/
+
+	/* these are for safe removal of mc devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	struct rcu_head rcu;
+	struct completion complete;
+
+	/* sysfs top name under 'edac' directory
+	 * and instance name:
+	 *	cpu/cpu0/...
+	 *	cpu/cpu1/...
+	 *	cpu/cpu2/...
+	 *	...
+	 */
+	char name[EDAC_DEVICE_NAME_LEN + 1];
+
+	/* Number of instances supported on this control structure
+	 * and the array of those instances
+	 */
+	u32 nr_instances;
+	struct edac_device_instance *instances;
+
+	/* Event counters for the this whole EDAC Device */
+	struct edac_device_counter counters;
+
+	/* edac sysfs device control for the 'name'
+	 * device this structure controls
+	 */
+	struct kobject kobj;
+	struct completion kobj_complete;
+};
+
+/* To get from the instance's wq to the beginning of the ctl structure */
+#define to_edac_device_ctl_work(w) \
+		container_of(w,struct edac_device_ctl_info,work)
+
+/* Function to calc the number of delay jiffies from poll_msec */
+static inline void edac_device_calc_delay(
+				struct edac_device_ctl_info *edac_dev)
+{
+	/* convert from msec to jiffies */
+	edac_dev->delay = edac_dev->poll_msec * HZ / 1000;
+}
+
+/*
+ * The alloc() and free() functions for the 'edac_device' control info
+ * structure. A MC driver will allocate one of these for each edac_device
+ * it is going to control/register with the EDAC CORE.
+ */
+extern struct edac_device_ctl_info *edac_device_alloc_ctl_info(
+	unsigned sizeof_private,
+	char *edac_device_name,
+	unsigned nr_instances,
+	char *edac_block_name,
+	unsigned nr_blocks,
+	unsigned offset_value,
+	struct edac_attrib_spec *attrib_spec,
+	unsigned nr_attribs
+);
+
+/* The offset value can be:
+ *	-1 indicating no offset value
+ *	0 for zero-based block numbers
+ *	1 for 1-based block number
+ *	other for other-based block number
+ */
+#define	BLOCK_OFFSET_VALUE_OFF	((unsigned) -1)
+
+extern void edac_device_free_ctl_info( struct edac_device_ctl_info *ctl_info);
+
 #ifdef CONFIG_PCI
 
 /* write all or some bits in a byte-register*/
@@ -466,13 +702,17 @@ extern void edac_mc_handle_fbd_ce(struct
 		char *msg);
 
 /*
- * This kmalloc's and initializes all the structures.
- * Can't be used if all structures don't have the same lifetime.
+ * edac_device APIs
  */
 extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 		unsigned nr_chans);
-
-/* Free an mc previously allocated by edac_mc_alloc() */
 extern void edac_mc_free(struct mem_ctl_info *mci);
+extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx);
+extern struct edac_device_ctl_info * edac_device_del_device(struct device *dev);
+extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
+		int inst_nr, int block_nr, const char *msg);
+extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
+		int inst_nr, int block_nr, const char *msg);
+
 
 #endif				/* _EDAC_CORE_H_ */
diff -puN /dev/null drivers/edac/edac_device.c
--- /dev/null
+++ a/drivers/edac/edac_device.c
@@ -0,0 +1,669 @@
+
+/*
+ * edac_device.c
+ * (C) 2007 www.douglaskthompson.com
+ *
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ * Written by Doug Thompson <norsk5@xmission.com>
+ *
+ * edac_device API implementation
+ * 19 Jan 2007
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <linux/highmem.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/sysdev.h>
+#include <linux/ctype.h>
+#include <linux/workqueue.h>
+#include <asm/uaccess.h>
+#include <asm/page.h>
+
+#include "edac_core.h"
+#include "edac_module.h"
+
+/* lock to memory controller's control array */
+static DECLARE_MUTEX(device_ctls_mutex);
+static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
+
+
+static inline void lock_device_list(void)
+{
+	down(&device_ctls_mutex);
+}
+
+static inline void unlock_device_list(void)
+{
+	up(&device_ctls_mutex);
+}
+
+
+#ifdef CONFIG_EDAC_DEBUG
+static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
+{
+	debugf3("\tedac_dev = %p dev_idx=%d \n", edac_dev,edac_dev->dev_idx);
+	debugf4("\tedac_dev->edac_check = %p\n", edac_dev->edac_check);
+	debugf3("\tdev = %p\n", edac_dev->dev);
+	debugf3("\tmod_name:ctl_name = %s:%s\n",
+		edac_dev->mod_name, edac_dev->ctl_name);
+	debugf3("\tpvt_info = %p\n\n", edac_dev->pvt_info);
+}
+#endif  /* CONFIG_EDAC_DEBUG */
+
+/*
+ * The alloc() and free() functions for the 'edac_device' control info
+ * structure. A MC driver will allocate one of these for each edac_device
+ * it is going to control/register with the EDAC CORE.
+ */
+struct edac_device_ctl_info *edac_device_alloc_ctl_info(
+	unsigned sz_private,
+	char *edac_device_name,
+	unsigned nr_instances,
+	char *edac_block_name,
+	unsigned nr_blocks,
+	unsigned offset_value,
+	struct edac_attrib_spec *attrib_spec,
+	unsigned nr_attribs)
+{
+	struct edac_device_ctl_info *dev_ctl;
+	struct edac_device_instance *dev_inst, *inst;
+	struct edac_device_block *dev_blk, *blk_p, *blk;
+	struct edac_attrib *dev_attrib, *attrib_p, *attrib;
+	unsigned total_size;
+	unsigned count;
+	unsigned instance, block, attr;
+	void *pvt;
+
+	debugf1("%s() instances=%d blocks=%d\n",
+		__func__,nr_instances,nr_blocks);
+
+	/* Figure out the offsets of the various items from the start of an
+	 * ctl_info structure.  We want the alignment of each item
+	 * to be at least as stringent as what the compiler would
+	 * provide if we could simply hardcode everything into a single struct.
+	 */
+	dev_ctl = (struct edac_device_ctl_info *) 0;
+
+	/* Calc the 'end' offset past the ctl_info structure */
+	dev_inst = (struct edac_device_instance *)
+			edac_align_ptr(&dev_ctl[1],sizeof(*dev_inst));
+
+	/* Calc the 'end' offset past the instance array */
+	dev_blk = (struct edac_device_block *)
+			edac_align_ptr(&dev_inst[nr_instances],sizeof(*dev_blk));
+
+	/* Calc the 'end' offset past the dev_blk array */
+	count = nr_instances * nr_blocks;
+	dev_attrib = (struct edac_attrib *)
+			edac_align_ptr(&dev_blk[count],sizeof(*dev_attrib));
+
+	/* Check for case of NO attributes specified */
+	if (nr_attribs > 0)
+		count *= nr_attribs;
+
+	/* Calc the 'end' offset past the attributes array */
+	pvt = edac_align_ptr(&dev_attrib[count],sz_private);
+	total_size = ((unsigned long) pvt) + sz_private;
+
+	/* Allocate the amount of memory for the set of control structures */
+	if ((dev_ctl = kmalloc(total_size, GFP_KERNEL)) == NULL)
+		return NULL;
+
+	/* Adjust pointers so they point within the memory we just allocated
+	 * rather than an imaginary chunk of memory located at address 0.
+	 */
+	dev_inst = (struct edac_device_instance *)
+			(((char *) dev_ctl) + ((unsigned long) dev_inst));
+	dev_blk = (struct edac_device_block *)
+			(((char *) dev_ctl) + ((unsigned long) dev_blk));
+	dev_attrib = (struct edac_attrib *)
+			(((char *) dev_ctl) + ((unsigned long) dev_attrib));
+	pvt = sz_private ?
+			(((char *) dev_ctl) + ((unsigned long) pvt)) : NULL;
+
+	memset(dev_ctl, 0, total_size);		/* clear all fields */
+	dev_ctl->nr_instances = nr_instances;
+	dev_ctl->instances = dev_inst;
+	dev_ctl->pvt_info = pvt;
+
+	/* Name of this edac device, ensure null terminated */
+	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s", edac_device_name);
+	dev_ctl->name[sizeof(dev_ctl->name)-1] = '\0';
+
+	/* Initialize every Instance */
+	for (instance = 0; instance < nr_instances; instance++) {
+		inst = &dev_inst[instance];
+		inst->ctl = dev_ctl;
+		inst->nr_blocks = nr_blocks;
+		blk_p = &dev_blk[instance * nr_blocks];
+		inst->blocks = blk_p;
+
+		/* name of this instance */
+		snprintf(inst->name, sizeof(inst->name),
+			"%s%u", edac_device_name, instance);
+		inst->name[sizeof(inst->name)-1] = '\0';
+
+		/* Initialize every block in each instance */
+		for (		block = 0;
+				block < nr_blocks;
+				block++) {
+			blk = &blk_p[block];
+			blk->instance = inst;
+			blk->nr_attribs = nr_attribs;
+			attrib_p = &dev_attrib[block * nr_attribs];
+			blk->attribs = attrib_p;
+			snprintf(blk->name, sizeof(blk->name),
+				"%s%d", edac_block_name,block+1);
+			blk->name[sizeof(blk->name)-1] = '\0';
+
+			debugf1("%s() instance=%d block=%d name=%s\n",
+				__func__, instance,block,blk->name);
+
+			if (attrib_spec != NULL) {
+				/* when there is an attrib_spec passed int then
+				 * Initialize every attrib of each block
+				 */
+				for (attr = 0; attr < nr_attribs; attr++) {
+					attrib = &attrib_p[attr];
+					attrib->block = blk;
+
+					/* Link each attribute to the caller's
+					 * spec entry, for name and type
+				 	 */
+					attrib->spec = &attrib_spec[attr];
+				}
+			}
+		}
+	}
+
+	/* Mark this instance as merely ALLOCATED */
+	dev_ctl->op_state = OP_ALLOC;
+
+	return dev_ctl;
+}
+EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_info);
+
+/*
+ * edac_device_free_ctl_info()
+ *	frees the memory allocated by the edac_device_alloc_ctl_info()
+ *	function
+ */
+void edac_device_free_ctl_info( struct edac_device_ctl_info *ctl_info) {
+	kfree(ctl_info);
+}
+EXPORT_SYMBOL_GPL(edac_device_free_ctl_info);
+
+
+
+/*
+ * find_edac_device_by_dev
+ *	scans the edac_device list for a specific 'struct device *'
+ */
+static struct edac_device_ctl_info *
+find_edac_device_by_dev(struct device *dev)
+{
+	struct edac_device_ctl_info *edac_dev;
+	struct list_head *item;
+
+	debugf3("%s()\n", __func__);
+
+	list_for_each(item, &edac_device_list) {
+		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
+
+		if (edac_dev->dev == dev)
+			return edac_dev;
+	}
+
+	return NULL;
+}
+
+/*
+ * add_edac_dev_to_global_list
+ *	Before calling this function, caller must
+ *	assign a unique value to edac_dev->dev_idx.
+ *	Return:
+ *		0 on success
+ *		1 on failure.
+ */
+static int add_edac_dev_to_global_list (struct edac_device_ctl_info *edac_dev)
+{
+	struct list_head *item, *insert_before;
+	struct edac_device_ctl_info *rover;
+
+	insert_before = &edac_device_list;
+
+	/* Determine if already on the list */
+	if (unlikely((rover = find_edac_device_by_dev(edac_dev->dev)) != NULL))
+		goto fail0;
+
+	/* Insert in ascending order by 'dev_idx', so find position */
+	list_for_each(item, &edac_device_list) {
+		rover = list_entry(item, struct edac_device_ctl_info, link);
+
+		if (rover->dev_idx >= edac_dev->dev_idx) {
+			if (unlikely(rover->dev_idx == edac_dev->dev_idx))
+				goto fail1;
+
+			insert_before = item;
+			break;
+		}
+	}
+
+	list_add_tail_rcu(&edac_dev->link, insert_before);
+	return 0;
+
+fail0:
+	edac_printk(KERN_WARNING, EDAC_MC,
+		"%s (%s) %s %s already assigned %d\n",
+		rover->dev->bus_id, dev_name(rover->dev),
+		rover->mod_name, rover->ctl_name, rover->dev_idx);
+	return 1;
+
+fail1:
+	edac_printk(KERN_WARNING, EDAC_MC,
+		"bug in low-level driver: attempt to assign\n"
+		"    duplicate dev_idx %d in %s()\n", rover->dev_idx, __func__);
+	return 1;
+}
+
+/*
+ * complete_edac_device_list_del
+ */
+static void complete_edac_device_list_del(struct rcu_head *head)
+{
+	struct edac_device_ctl_info *edac_dev;
+
+	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
+	INIT_LIST_HEAD(&edac_dev->link);
+	complete(&edac_dev->complete);
+}
+
+/*
+ * del_edac_device_from_global_list
+ */
+static void del_edac_device_from_global_list(
+			struct edac_device_ctl_info *edac_device)
+{
+	list_del_rcu(&edac_device->link);
+	init_completion(&edac_device->complete);
+	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
+	wait_for_completion(&edac_device->complete);
+}
+
+/**
+ * edac_device_find
+ *	Search for a edac_device_ctl_info structure whose index is 'idx'.
+ *
+ * If found, return a pointer to the structure.
+ * Else return NULL.
+ *
+ * Caller must hold device_ctls_mutex.
+ */
+struct edac_device_ctl_info * edac_device_find(int idx)
+{
+	struct list_head *item;
+	struct edac_device_ctl_info *edac_dev;
+
+	/* Iterate over list, looking for exact match of ID */
+	list_for_each(item, &edac_device_list) {
+		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
+
+		if (edac_dev->dev_idx >= idx) {
+			if (edac_dev->dev_idx == idx)
+				return edac_dev;
+
+			/* not on list, so terminate early */
+			break;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(edac_device_find);
+
+
+/*
+ * edac_workq_function
+ *	performs the operation scheduled by a workq request
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+static void edac_workq_function(struct work_struct *work_req)
+{
+	struct delayed_work *d_work = (struct delayed_work*) work_req;
+	struct edac_device_ctl_info *edac_dev =
+		to_edac_device_ctl_work(d_work);
+#else
+static void edac_workq_function(void *ptr)
+{
+	struct edac_device_ctl_info *edac_dev =
+		(struct edac_device_ctl_info *) ptr;
+#endif
+
+	//debugf0("%s() here and running\n", __func__);
+	lock_device_list();
+
+	/* Only poll controllers that are running polled and have a check */
+	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
+					(edac_dev->edac_check != NULL)) {
+		edac_dev->edac_check(edac_dev);
+	}
+
+	unlock_device_list();
+
+	/* Reschedule */
+	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
+}
+
+/*
+ * edac_workq_setup
+ *	initialize a workq item for this edac_device instance
+ *	passing in the new delay period in msec
+ */
+void edac_workq_setup(struct edac_device_ctl_info *edac_dev, unsigned msec)
+{
+	debugf0("%s()\n", __func__);
+
+	edac_dev->poll_msec = msec;
+	edac_device_calc_delay(edac_dev);	/* Calc delay jiffies */
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	INIT_DELAYED_WORK(&edac_dev->work,edac_workq_function);
+#else
+	INIT_WORK(&edac_dev->work,edac_workq_function,edac_dev);
+#endif
+	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
+}
+
+/*
+ * edac_workq_teardown
+ *	stop the workq processing on this edac_dev
+ */
+void edac_workq_teardown(struct edac_device_ctl_info *edac_dev)
+{
+	int status;
+
+	status = cancel_delayed_work(&edac_dev->work);
+	if (status == 0) {
+		/* workq instance might be running, wait for it */
+		flush_workqueue(edac_workqueue);
+	}
+}
+
+/*
+ * edac_device_reset_delay_period
+ */
+
+void edac_device_reset_delay_period(
+		struct edac_device_ctl_info *edac_dev,
+		unsigned long value)
+{
+	lock_device_list();
+
+	/* cancel the current workq request */
+	edac_workq_teardown(edac_dev);
+
+	/* restart the workq request, with new delay value */
+	edac_workq_setup(edac_dev, value);
+
+	unlock_device_list();
+}
+
+/*
+ * edac_op_state_toString(edac_dev)
+ */
+static char *edac_op_state_toString(struct edac_device_ctl_info *edac_dev)
+{
+	int opstate = edac_dev->op_state;
+
+	if (opstate == OP_RUNNING_POLL)
+		return "POLLED";
+	else if (opstate == OP_RUNNING_INTERRUPT)
+		return "INTERRUPT";
+	else if (opstate == OP_RUNNING_POLL_INTR)
+		return "POLL-INTR";
+	else if (opstate == OP_ALLOC)
+		return "ALLOC";
+	else if (opstate == OP_OFFLINE)
+		return "OFFLINE";
+
+	return "UNKNOWN";
+}
+
+/**
+ * edac_device_add_device: Insert the 'edac_dev' structure into the
+ * edac_device global list and create sysfs entries associated with
+ * edac_device structure.
+ * @edac_device: pointer to the edac_device structure to be added to the list
+ * @edac_idx: A unique numeric identifier to be assigned to the
+ * 'edac_device' structure.
+ *
+ * Return:
+ *	0	Success
+ *	!0	Failure
+ */
+int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx)
+{
+	debugf0("%s()\n", __func__);
+
+	edac_dev->dev_idx = edac_idx;
+#ifdef CONFIG_EDAC_DEBUG
+	if (edac_debug_level >= 3)
+		edac_device_dump_device(edac_dev);
+#endif
+	lock_device_list();
+
+	if (add_edac_dev_to_global_list(edac_dev))
+		goto fail0;
+
+	/* set load time so that error rate can be tracked */
+	edac_dev->start_time = jiffies;
+
+	/* create this instance's sysfs entries */
+	if (edac_device_create_sysfs(edac_dev)) {
+		edac_device_printk(edac_dev, KERN_WARNING,
+			"failed to create sysfs device\n");
+		goto fail1;
+	}
+
+	/* If there IS a check routine, then we are running POLLED */
+	if (edac_dev->edac_check != NULL) {
+		/* This instance is NOW RUNNING */
+		edac_dev->op_state = OP_RUNNING_POLL;
+
+		/* enable workq processing on this instance, default = 1000 msec */
+		edac_workq_setup(edac_dev, 1000);
+	} else {
+		edac_dev->op_state = OP_RUNNING_INTERRUPT;
+	}
+
+
+	/* Report action taken */
+	edac_device_printk(edac_dev, KERN_INFO,
+		"Giving out device to module '%s' controller '%s': DEV '%s' (%s)\n",
+		edac_dev->mod_name,
+		edac_dev->ctl_name,
+		dev_name(edac_dev->dev),
+		edac_op_state_toString(edac_dev)
+		);
+
+	unlock_device_list();
+	return 0;
+
+fail1:
+	/* Some error, so remove the entry from the lsit */
+	del_edac_device_from_global_list(edac_dev);
+
+fail0:
+	unlock_device_list();
+	return 1;
+}
+EXPORT_SYMBOL_GPL(edac_device_add_device);
+
+/**
+ * edac_device_del_device:
+ *	Remove sysfs entries for specified edac_device structure and
+ *	then remove edac_device structure from global list
+ *
+ * @pdev:
+ *	Pointer to 'struct device' representing edac_device
+ *	structure to remove.
+ *
+ * Return:
+ *	Pointer to removed edac_device structure,
+ *	OR NULL if device not found.
+ */
+struct edac_device_ctl_info * edac_device_del_device(struct device *dev)
+{
+	struct edac_device_ctl_info *edac_dev;
+
+	debugf0("MC: %s()\n", __func__);
+
+	lock_device_list();
+
+	if ((edac_dev = find_edac_device_by_dev(dev)) == NULL) {
+		unlock_device_list();
+		return NULL;
+	}
+
+	/* mark this instance as OFFLINE */
+	edac_dev->op_state = OP_OFFLINE;
+
+	/* clear workq processing on this instance */
+	edac_workq_teardown(edac_dev);
+
+	/* Tear down the sysfs entries for this instance */
+	edac_device_remove_sysfs(edac_dev);
+
+	/* deregister from global list */
+	del_edac_device_from_global_list(edac_dev);
+
+	unlock_device_list();
+
+	edac_printk(KERN_INFO, EDAC_MC,
+		"Removed device %d for %s %s: DEV %s\n",
+		edac_dev->dev_idx,
+		edac_dev->mod_name,
+		edac_dev->ctl_name,
+		dev_name(edac_dev->dev));
+
+	return edac_dev;
+}
+EXPORT_SYMBOL_GPL(edac_device_del_device);
+
+
+static inline int edac_device_get_log_ce(struct edac_device_ctl_info *edac_dev)
+{
+	return edac_dev->log_ce;
+}
+
+static inline int edac_device_get_log_ue(struct edac_device_ctl_info *edac_dev)
+{
+	return edac_dev->log_ue;
+}
+
+static inline int edac_device_get_panic_on_ue(
+		struct edac_device_ctl_info *edac_dev)
+{
+	return edac_dev->panic_on_ue;
+}
+
+/*
+ * edac_device_handle_ce
+ *	perform a common output and handling of an 'edac_dev' CE event
+ */
+void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
+		int inst_nr, int block_nr, const char *msg)
+{
+	struct edac_device_instance *instance;
+	struct edac_device_block *block = NULL;
+
+	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
+		edac_device_printk(edac_dev, KERN_ERR,
+			"INTERNAL ERROR: 'instance' out of range "
+			"(%d >= %d)\n", inst_nr, edac_dev->nr_instances);
+		return;
+	}
+
+	instance = edac_dev->instances + inst_nr;
+
+	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
+		edac_device_printk(edac_dev, KERN_ERR,
+			"INTERNAL ERROR: instance %d 'block' out of range "
+			"(%d >= %d)\n", inst_nr, block_nr, instance->nr_blocks);
+		return;
+	}
+
+	if (instance->nr_blocks > 0) {
+		block = instance->blocks + block_nr;
+		block->counters.ce_count++;
+	}
+
+	/* Propogate the count up the 'totals' tree */
+	instance->counters.ce_count++;
+	edac_dev->counters.ce_count++;
+
+	if (edac_device_get_log_ce(edac_dev))
+		edac_device_printk(edac_dev, KERN_WARNING,
+		"CE ctl: %s, instance: %s, block: %s: %s\n",
+		edac_dev->ctl_name, instance->name,
+		block ? block->name : "N/A", msg);
+}
+EXPORT_SYMBOL_GPL(edac_device_handle_ce);
+
+/*
+ * edac_device_handle_ue
+ *	perform a common output and handling of an 'edac_dev' UE event
+ */
+void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
+		int inst_nr, int block_nr, const char *msg)
+{
+	struct edac_device_instance *instance;
+	struct edac_device_block *block = NULL;
+
+	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
+		edac_device_printk(edac_dev, KERN_ERR,
+			"INTERNAL ERROR: 'instance' out of range "
+			"(%d >= %d)\n", inst_nr, edac_dev->nr_instances);
+		return;
+	}
+
+	instance = edac_dev->instances + inst_nr;
+
+	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
+		edac_device_printk(edac_dev, KERN_ERR,
+			"INTERNAL ERROR: instance %d 'block' out of range "
+			"(%d >= %d)\n", inst_nr, block_nr, instance->nr_blocks);
+		return;
+	}
+
+	if (instance->nr_blocks > 0) {
+		block = instance->blocks + block_nr;
+		block->counters.ue_count++;
+	}
+
+	/* Propogate the count up the 'totals' tree */
+	instance->counters.ue_count++;
+	edac_dev->counters.ue_count++;
+
+	if (edac_device_get_log_ue(edac_dev))
+		edac_device_printk(edac_dev, KERN_EMERG,
+		"UE ctl: %s, instance: %s, block: %s: %s\n",
+		edac_dev->ctl_name, instance->name,
+		block ? block->name : "N/A", msg);
+
+	if (edac_device_get_panic_on_ue(edac_dev))
+		panic("EDAC %s: UE instance: %s, block %s: %s\n",
+			edac_dev->ctl_name, instance->name,
+			block ? block->name : "N/A", msg);
+}
+EXPORT_SYMBOL_GPL(edac_device_handle_ue);
+
diff -puN /dev/null drivers/edac/edac_device_sysfs.c
--- /dev/null
+++ a/drivers/edac/edac_device_sysfs.c
@@ -0,0 +1,837 @@
+/*
+ * file for managing the edac_device class of devices for EDAC
+ *
+ * (C) 2007 SoftwareBitMaker(http://www.softwarebitmaker.com)
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ * Written Doug Thompson <norsk5@xmission.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/sysdev.h>
+#include <linux/ctype.h>
+
+#include "edac_core.h"
+#include "edac_module.h"
+
+
+#define EDAC_DEVICE_SYMLINK	"device"
+
+#define to_edacdev(k) container_of(k, struct edac_device_ctl_info, kobj)
+#define to_edacdev_attr(a) container_of(a, struct edacdev_attribute, attr)
+
+#ifdef DKT
+
+static ssize_t edac_dev_ue_count_show(struct edac_device_ctl_info *edac_dev,
+					char *data)
+{
+	return sprintf(data,"%d\n", edac_dev->ue_count);
+}
+
+static ssize_t edac_dev_ce_count_show(struct edac_device_ctl_info *edac_dev,
+					char *data)
+{
+	return sprintf(data,"%d\n", edac_dev->ce_count);
+}
+
+static ssize_t edac_dev_seconds_show(struct edac_device_ctl_info *edac_dev,
+					char *data)
+{
+	return sprintf(data,"%ld\n", (jiffies - edac_dev->start_time) / HZ);
+}
+
+static ssize_t edac_dev_ctl_name_show(struct edac_device_ctl_info *edac_dev,
+					char *data)
+{
+	return sprintf(data,"%s\n", edac_dev->ctl_name);
+}
+
+
+struct edacdev_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct edac_device_ctl_info *,char *);
+	ssize_t (*store)(struct edac_device_ctl_info *, const char *,size_t);
+};
+
+
+/* EDAC DEVICE show/store functions for top most object */
+static ssize_t edacdev_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
+	struct edacdev_attribute * edacdev_attr = to_edacdev_attr(attr);
+
+	if (edacdev_attr->show)
+		return edacdev_attr->show(edac_dev, buffer);
+
+	return -EIO;
+}
+
+static ssize_t edacdev_store(struct kobject *kobj, struct attribute *attr,
+		const char *buffer, size_t count)
+{
+	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
+	struct edacdev_attribute * edacdev_attr = to_edacdev_attr(attr);
+
+	if (edacdev_attr->store)
+		return edacdev_attr->store(edac_dev, buffer, count);
+
+	return -EIO;
+}
+
+static struct sysfs_ops edac_dev_ops = {
+	.show = edacdev_show,
+	.store = edacdev_store
+};
+
+#define EDACDEV_ATTR(_name,_mode,_show,_store)			\
+static struct edacdev_attribute edac_dev_attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+/* default Control file */
+EDACDEV_ATTR(reset_counters,S_IWUSR,NULL,edac_dev_reset_counters_store);
+
+/* default Attribute files */
+EDACDEV_ATTR(mc_name,S_IRUGO,edac_dev_ctl_name_show,NULL);
+EDACDEV_ATTR(seconds_since_reset,S_IRUGO,edac_dev_seconds_show,NULL);
+EDACDEV_ATTR(ue_count,S_IRUGO,edac_dev_ue_count_show,NULL);
+EDACDEV_ATTR(ce_count,S_IRUGO,edac_dev_ce_count_show,NULL);
+
+
+static struct edacdev_attribute *edacdev_attr[] = {
+	&edacdev_attr_reset_counters,
+	&edacdev_attr_mc_name,
+	&edacdev_attr_seconds_since_reset,
+	&edacdev_attr_ue_count,
+	&edacdev_attr_ce_count,
+	NULL
+};
+
+/*
+ * Release of a Edac Device controlling instance
+ */
+static void edac_dev_instance_release(struct kobject *kobj)
+{
+	struct edac_device_ctl_info *edac_dev;
+
+	edac_dev = to_edacdev(kobj);
+	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
+	complete(&edac_dev->kobj_complete);
+}
+
+static struct kobj_type ktype_device = {
+	.release = edac_dev_instance_release,
+	.sysfs_ops = &edacdev_ops,
+	.default_attrs = (struct attribute **) edacdev_attr,
+};
+
+#endif
+
+/************************** edac_device sysfs code and data **************/
+
+/*
+ * Set of edac_device_ctl_info attribute store/show functions
+ */
+
+/* 'log_ue' */
+static ssize_t edac_device_ctl_log_ue_show(
+		struct edac_device_ctl_info *ctl_info, char *data)
+{
+        return sprintf(data,"%u\n", ctl_info->log_ue);
+}
+
+static ssize_t edac_device_ctl_log_ue_store(
+		struct edac_device_ctl_info *ctl_info,
+			const char *data,size_t count)
+{
+	/* if parameter is zero, turn off flag, if non-zero turn on flag */
+	ctl_info->log_ue = (simple_strtoul(data,NULL,0) != 0);
+
+        return count;
+}
+
+/* 'log_ce' */
+static ssize_t edac_device_ctl_log_ce_show(
+		struct edac_device_ctl_info *ctl_info,char *data)
+{
+        return sprintf(data,"%u\n", ctl_info->log_ce);
+}
+
+static ssize_t edac_device_ctl_log_ce_store(
+		struct edac_device_ctl_info *ctl_info,
+			const char *data,size_t count)
+{
+	/* if parameter is zero, turn off flag, if non-zero turn on flag */
+	ctl_info->log_ce = (simple_strtoul(data,NULL,0) != 0);
+
+        return count;
+}
+
+
+/* 'panic_on_ue' */
+static ssize_t edac_device_ctl_panic_on_ue_show(
+		struct edac_device_ctl_info *ctl_info, char *data)
+{
+        return sprintf(data,"%u\n", ctl_info->panic_on_ue);
+}
+
+static ssize_t edac_device_ctl_panic_on_ue_store(
+		struct edac_device_ctl_info *ctl_info,
+			const char *data,size_t count)
+{
+	/* if parameter is zero, turn off flag, if non-zero turn on flag */
+	ctl_info->panic_on_ue = (simple_strtoul(data,NULL,0) != 0);
+
+	return count;
+}
+
+/* 'poll_msec' show and store functions*/
+static ssize_t edac_device_ctl_poll_msec_show(
+		struct edac_device_ctl_info *ctl_info, char *data)
+{
+        return sprintf(data,"%u\n", ctl_info->poll_msec);
+}
+
+static ssize_t edac_device_ctl_poll_msec_store(
+		struct edac_device_ctl_info *ctl_info,
+		const char *data,size_t count)
+{
+	unsigned long value;
+
+	/* get the value and enforce that it is non-zero, must be at least
+	 * one millisecond for the delay period, between scans
+	 * Then cancel last outstanding delay for the work request
+	 * and set a new one.
+	 */
+	value = simple_strtoul(data,NULL,0);
+	edac_device_reset_delay_period(ctl_info,value);
+
+        return count;
+}
+
+
+/* edac_device_ctl_info specific attribute structure */
+struct ctl_info_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct edac_device_ctl_info *,char *);
+        ssize_t (*store)(struct edac_device_ctl_info *,const char *,size_t);
+};
+
+#define to_ctl_info(k) container_of(k, struct edac_device_ctl_info, kobj)
+#define to_ctl_info_attr(a) container_of(a,struct ctl_info_attribute,attr)
+
+/* Function to 'show' fields from the edac_dev 'ctl_info' structure */
+static ssize_t edac_dev_ctl_info_show(struct kobject *kobj,
+                        struct attribute *attr,
+                        char *buffer)
+{
+        struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
+        struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
+
+        if (ctl_info_attr->show)
+                return ctl_info_attr->show(edac_dev,buffer);
+        return -EIO;
+}
+
+/* Function to 'store' fields into the edac_dev 'ctl_info' structure */
+static ssize_t edac_dev_ctl_info_store(struct kobject *kobj,
+                        struct attribute *attr,
+                	const char *buffer, size_t count)
+{
+        struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
+        struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
+
+        if (ctl_info_attr->store)
+                return ctl_info_attr->store(edac_dev, buffer, count);
+        return -EIO;
+}
+
+/* edac_dev file operations for an 'ctl_info' */
+static struct sysfs_ops device_ctl_info_ops = {
+	.show   = edac_dev_ctl_info_show,
+	.store  = edac_dev_ctl_info_store
+};
+
+#define CTL_INFO_ATTR(_name,_mode,_show,_store)        \
+static struct ctl_info_attribute attr_ctl_info_##_name = {      \
+        .attr = {.name = __stringify(_name), .mode = _mode },   \
+        .show   = _show,                                        \
+        .store  = _store,                                       \
+};
+
+
+/* Declare the various ctl_info attributes here and their respective ops */
+CTL_INFO_ATTR(log_ue,S_IRUGO|S_IWUSR,
+		edac_device_ctl_log_ue_show,
+		edac_device_ctl_log_ue_store);
+CTL_INFO_ATTR(log_ce,S_IRUGO|S_IWUSR,
+		edac_device_ctl_log_ce_show,
+		edac_device_ctl_log_ce_store);
+CTL_INFO_ATTR(panic_on_ue,S_IRUGO|S_IWUSR,
+		edac_device_ctl_panic_on_ue_show,
+		edac_device_ctl_panic_on_ue_store);
+CTL_INFO_ATTR(poll_msec,S_IRUGO|S_IWUSR,
+		edac_device_ctl_poll_msec_show,
+		edac_device_ctl_poll_msec_store);
+
+
+/* Base Attributes of the EDAC_DEVICE ECC object */
+static struct ctl_info_attribute *device_ctrl_attr[] = {
+	&attr_ctl_info_panic_on_ue,
+	&attr_ctl_info_log_ue,
+	&attr_ctl_info_log_ce,
+	&attr_ctl_info_poll_msec,
+	NULL,
+};
+
+/* Main DEVICE kobject release() function */
+static void edac_device_ctrl_master_release(struct kobject *kobj)
+{
+	struct edac_device_ctl_info *edac_dev;
+
+	edac_dev = to_edacdev(kobj);
+
+	debugf1("%s()\n", __func__);
+	complete(&edac_dev->kobj_complete);
+}
+
+static struct kobj_type ktype_device_ctrl = {
+	.release = edac_device_ctrl_master_release,
+	.sysfs_ops = &device_ctl_info_ops,
+	.default_attrs = (struct attribute **) device_ctrl_attr,
+};
+
+
+/**************** edac_device main kobj ctor/dtor code *********************/
+
+/*
+ * edac_device_register_main_kobj
+ *
+ *	perform the high level setup for the new edac_device instance
+ *
+ * Return:  0 SUCCESS
+ *         !0 FAILURE
+ */
+static int edac_device_register_main_kobj(
+		struct edac_device_ctl_info *edac_dev)
+{
+	int err = 0;
+	struct sysdev_class *edac_class;
+
+	debugf1("%s()\n", __func__);
+
+        /* get the /sys/devices/system/edac reference */
+        edac_class = edac_get_edac_class();
+        if (edac_class == NULL) {
+                debugf1("%s() no edac_class error=%d\n", __func__, err);
+                return err;
+        }
+
+	/* Point to the 'edac_class' this instance 'reports' to */
+	edac_dev->edac_class = edac_class;
+
+	/* Init the devices's kobject */
+	memset(&edac_dev->kobj, 0, sizeof (struct kobject));
+	edac_dev->kobj.ktype = &ktype_device_ctrl;
+
+	/* set this new device under the edac_class kobject */
+	edac_dev->kobj.parent = &edac_class->kset.kobj;
+
+	/* generate sysfs "..../edac/<name>"   */
+	debugf1("%s() set name of kobject to: %s\n",
+		__func__, edac_dev->name);
+	err = kobject_set_name(&edac_dev->kobj,"%s",edac_dev->name);
+	if (err)
+		return err;
+	err = kobject_register(&edac_dev->kobj);
+	if (err) {
+		debugf1("%s()Failed to register '.../edac/%s'\n",
+			__func__,edac_dev->name);
+		return err;
+	}
+
+	debugf1("%s() Registered '.../edac/%s' kobject\n",
+		__func__, edac_dev->name);
+
+	return 0;
+}
+
+/*
+ * edac_device_unregister_main_kobj:
+ *	the '..../edac/<name>' kobject
+ */
+static void edac_device_unregister_main_kobj(
+			struct edac_device_ctl_info *edac_dev)
+{
+	debugf0("%s()\n", __func__);
+	debugf1("%s() name of kobject is: %s\n",
+		__func__, kobject_name(&edac_dev->kobj));
+
+	init_completion(&edac_dev->kobj_complete);
+
+	/*
+	 * Unregister the edac device's kobject and
+	 * wait for reference count to reach 0.
+	 */
+	kobject_unregister(&edac_dev->kobj);
+	wait_for_completion(&edac_dev->kobj_complete);
+}
+
+
+/*************** edac_dev -> instance information ***********/
+
+/*
+ * Set of low-level instance attribute show functions
+ */
+static ssize_t instance_ue_count_show(
+		struct edac_device_instance *instance, char *data)
+{
+        return sprintf(data,"%u\n", instance->counters.ue_count);
+}
+
+static ssize_t instance_ce_count_show(
+		struct edac_device_instance *instance, char *data)
+{
+        return sprintf(data,"%u\n", instance->counters.ce_count);
+}
+
+
+
+#define to_instance(k) container_of(k, struct edac_device_instance, kobj)
+#define to_instance_attr(a) container_of(a,struct instance_attribute,attr)
+
+/* DEVICE instance kobject release() function */
+static void edac_device_ctrl_instance_release(struct kobject *kobj)
+{
+	struct edac_device_instance *instance;
+
+	debugf1("%s()\n", __func__);
+
+	instance = to_instance(kobj);
+	complete(&instance->kobj_complete);
+}
+
+
+/* instance specific attribute structure */
+struct instance_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct edac_device_instance *,char *);
+        ssize_t (*store)(struct edac_device_instance *,const char *,size_t);
+};
+
+
+/* Function to 'show' fields from the edac_dev 'instance' structure */
+static ssize_t edac_dev_instance_show(struct kobject *kobj,
+                        struct attribute *attr,
+                        char *buffer)
+{
+        struct edac_device_instance *instance = to_instance(kobj);
+        struct instance_attribute *instance_attr = to_instance_attr(attr);
+
+        if (instance_attr->show)
+                return instance_attr->show(instance,buffer);
+        return -EIO;
+}
+
+
+/* Function to 'store' fields into the edac_dev 'instance' structure */
+static ssize_t edac_dev_instance_store(struct kobject *kobj,
+                        struct attribute *attr,
+                	const char *buffer, size_t count)
+{
+        struct edac_device_instance *instance = to_instance(kobj);
+        struct instance_attribute *instance_attr = to_instance_attr(attr);
+
+        if (instance_attr->store)
+                return instance_attr->store(instance, buffer, count);
+        return -EIO;
+}
+
+
+
+/* edac_dev file operations for an 'instance' */
+static struct sysfs_ops device_instance_ops = {
+	.show   = edac_dev_instance_show,
+	.store  = edac_dev_instance_store
+};
+
+#define INSTANCE_ATTR(_name,_mode,_show,_store)        \
+static struct instance_attribute attr_instance_##_name = {      \
+        .attr = {.name = __stringify(_name), .mode = _mode },   \
+        .show   = _show,                                        \
+        .store  = _store,                                       \
+};
+
+/*
+ * Define attributes visible for the edac_device instance object
+ *	Each contains a pointer to a show and an optional set
+ *	function pointer that does the low level output/input
+ */
+INSTANCE_ATTR(ce_count,S_IRUGO,instance_ce_count_show,NULL);
+INSTANCE_ATTR(ue_count,S_IRUGO,instance_ue_count_show,NULL);
+
+/* list of edac_dev 'instance' attributes */
+static struct instance_attribute *device_instance_attr[] = {
+	&attr_instance_ce_count,
+	&attr_instance_ue_count,
+	NULL,
+};
+
+/* The 'ktype' for each edac_dev 'instance' */
+static struct kobj_type ktype_instance_ctrl = {
+	.release = edac_device_ctrl_instance_release,
+	.sysfs_ops = &device_instance_ops,
+	.default_attrs = (struct attribute **) device_instance_attr,
+};
+
+
+/*************** edac_dev -> instance -> block information *********/
+
+/*
+ * Set of low-level block attribute show functions
+ */
+static ssize_t block_ue_count_show(
+		struct edac_device_block *block, char *data)
+{
+        return sprintf(data,"%u\n", block->counters.ue_count);
+}
+
+static ssize_t block_ce_count_show(
+		struct edac_device_block *block, char *data)
+{
+        return sprintf(data,"%u\n", block->counters.ce_count);
+}
+
+
+
+#define to_block(k) container_of(k, struct edac_device_block, kobj)
+#define to_block_attr(a) container_of(a,struct block_attribute,attr)
+
+/* DEVICE block kobject release() function */
+static void edac_device_ctrl_block_release(struct kobject *kobj)
+{
+	struct edac_device_block *block;
+
+	debugf1("%s()\n", __func__);
+
+	block = to_block(kobj);
+	complete(&block->kobj_complete);
+}
+
+/* block specific attribute structure */
+struct block_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct edac_device_block *,char *);
+        ssize_t (*store)(struct edac_device_block *,const char *,size_t);
+};
+
+/* Function to 'show' fields from the edac_dev 'block' structure */
+static ssize_t edac_dev_block_show(struct kobject *kobj,
+                        struct attribute *attr,
+                        char *buffer)
+{
+        struct edac_device_block *block = to_block(kobj);
+        struct block_attribute *block_attr = to_block_attr(attr);
+
+        if (block_attr->show)
+                return block_attr->show(block,buffer);
+        return -EIO;
+}
+
+
+/* Function to 'store' fields into the edac_dev 'block' structure */
+static ssize_t edac_dev_block_store(struct kobject *kobj,
+                        struct attribute *attr,
+                	const char *buffer, size_t count)
+{
+        struct edac_device_block *block = to_block(kobj);
+        struct block_attribute *block_attr = to_block_attr(attr);
+
+        if (block_attr->store)
+                return block_attr->store(block, buffer, count);
+        return -EIO;
+}
+
+
+/* edac_dev file operations for a 'block' */
+static struct sysfs_ops device_block_ops = {
+	.show   = edac_dev_block_show,
+	.store  = edac_dev_block_store
+};
+
+
+#define BLOCK_ATTR(_name,_mode,_show,_store)        \
+static struct block_attribute attr_block_##_name = {                       \
+        .attr = {.name = __stringify(_name), .mode = _mode },   \
+        .show   = _show,                                        \
+        .store  = _store,                                       \
+};
+
+BLOCK_ATTR(ce_count,S_IRUGO,block_ce_count_show,NULL);
+BLOCK_ATTR(ue_count,S_IRUGO,block_ue_count_show,NULL);
+
+
+/* list of edac_dev 'block' attributes */
+static struct block_attribute *device_block_attr[] = {
+	&attr_block_ce_count,
+	&attr_block_ue_count,
+	NULL,
+};
+
+/* The 'ktype' for each edac_dev 'block' */
+static struct kobj_type ktype_block_ctrl = {
+	.release = edac_device_ctrl_block_release,
+	.sysfs_ops = &device_block_ops,
+	.default_attrs = (struct attribute **) device_block_attr,
+};
+
+
+/************** block ctor/dtor  code ************/
+
+/*
+ * edac_device_create_block
+ */
+static int edac_device_create_block(
+		struct edac_device_ctl_info *edac_dev,
+		struct edac_device_instance *instance,
+		int idx)
+{
+	int err;
+	struct edac_device_block *block;
+
+	block = &instance->blocks[idx];
+
+	debugf1("%s() Instance '%s' block[%d] '%s'\n",
+		__func__,instance->name, idx, block->name);
+
+	/* init this block's kobject */
+	memset(&block->kobj, 0, sizeof (struct kobject));
+	block->kobj.parent = &instance->kobj;
+	block->kobj.ktype = &ktype_block_ctrl;
+
+	err = kobject_set_name(&block->kobj,"%s",block->name);
+	if (err)
+		return err;
+
+	err = kobject_register(&block->kobj);
+	if (err) {
+		debugf1("%s()Failed to register instance '%s'\n",
+			__func__,block->name);
+		return err;
+	}
+
+	return 0;
+}
+
+/*
+ * edac_device_delete_block(edac_dev,j);
+ */
+static void edac_device_delete_block(
+		struct edac_device_ctl_info *edac_dev,
+		struct edac_device_instance *instance,
+		int idx)
+{
+	struct edac_device_block *block;
+
+	block = &instance->blocks[idx];
+
+	/* unregister this block's kobject */
+	init_completion(&block->kobj_complete);
+	kobject_unregister(&block->kobj);
+	wait_for_completion(&block->kobj_complete);
+}
+
+/************** instance ctor/dtor  code ************/
+
+/*
+ * edac_device_create_instance
+ *	create just one instance of an edac_device 'instance'
+ */
+static int edac_device_create_instance(
+		struct edac_device_ctl_info *edac_dev, int idx)
+{
+	int i, j;
+	int err;
+	struct edac_device_instance *instance;
+
+	instance = &edac_dev->instances[idx];
+
+	/* Init the instance's kobject */
+	memset(&instance->kobj, 0, sizeof (struct kobject));
+
+	/* set this new device under the edac_device main kobject */
+	instance->kobj.parent = &edac_dev->kobj;
+	instance->kobj.ktype = &ktype_instance_ctrl;
+
+	err = kobject_set_name(&instance->kobj,"%s",instance->name);
+	if (err)
+		return err;
+
+	err = kobject_register(&instance->kobj);
+	if (err != 0) {
+		debugf2("%s() Failed to register instance '%s'\n",
+			__func__,instance->name);
+		return err;
+	}
+
+	debugf1("%s() now register '%d' blocks for instance %d\n",
+			__func__,instance->nr_blocks,idx);
+
+	/* register all blocks of this instance */
+	for (i = 0; i < instance->nr_blocks; i++ ) {
+		err = edac_device_create_block(edac_dev,instance,i);
+		if (err) {
+			for (j = 0; j < i; j++) {
+				edac_device_delete_block(edac_dev,instance,j);
+			}
+			return err;
+		}
+	}
+
+	debugf1("%s() Registered instance %d '%s' kobject\n",
+		__func__, idx, instance->name);
+
+	return 0;
+}
+
+/*
+ * edac_device_remove_instance
+ *	remove an edac_device instance
+ */
+static void edac_device_delete_instance(
+		struct edac_device_ctl_info *edac_dev, int idx)
+{
+	int i;
+	struct edac_device_instance *instance;
+
+	instance = &edac_dev->instances[idx];
+
+	/* unregister all blocks in this instance */
+	for (i = 0; i < instance->nr_blocks; i++) {
+		edac_device_delete_block(edac_dev,instance,i);
+	}
+
+	/* unregister this instance's kobject */
+	init_completion(&instance->kobj_complete);
+	kobject_unregister(&instance->kobj);
+	wait_for_completion(&instance->kobj_complete);
+}
+
+/*
+ * edac_device_create_instances
+ *	create the first level of 'instances' for this device
+ *	(ie  'cache' might have 'cache0', 'cache1', 'cache2', etc
+ */
+static int edac_device_create_instances(struct edac_device_ctl_info *edac_dev)
+{
+	int i, j;
+	int err;
+
+	debugf0("%s()\n", __func__);
+
+	/* iterate over creation of the instances */
+	for (i = 0; i < edac_dev->nr_instances; i++ ) {
+		err = edac_device_create_instance(edac_dev,i);
+		if (err) {
+			/* unwind previous instances on error */
+			for (j = 0; j < i; j++) {
+				edac_device_delete_instance(edac_dev,j);
+			}
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * edac_device_delete_instances(edac_dev);
+ *	unregister all the kobjects of the instances
+ */
+static void edac_device_delete_instances(struct edac_device_ctl_info *edac_dev)
+{
+	int i;
+
+	/* iterate over creation of the instances */
+	for (i = 0; i < edac_dev->nr_instances; i++ ) {
+		edac_device_delete_instance(edac_dev,i);
+	}
+}
+
+/******************* edac_dev sysfs ctor/dtor  code *************/
+
+/*
+ * edac_device_create_sysfs() Constructor
+ *
+ * Create a new edac_device kobject instance,
+ *
+ * Return:
+ *	0	Success
+ *	!0	Failure
+ */
+int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
+{
+	int err;
+	struct kobject *edac_kobj=&edac_dev->kobj;
+
+	/* register this instance's main kobj with the edac class kobj */
+	err = edac_device_register_main_kobj(edac_dev);
+	if (err)
+		return err;
+
+	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
+
+	/* create a symlink from the edac device
+	 * to the platform 'device' being used for this
+	 */
+	err = sysfs_create_link(edac_kobj,
+				&edac_dev->dev->kobj,
+				EDAC_DEVICE_SYMLINK);
+	if (err) {
+		debugf0("%s() sysfs_create_link() returned err= %d\n",
+			__func__, err);
+		return err;
+	}
+
+	debugf0("%s() calling create-instances, idx=%d\n",
+		__func__, edac_dev->dev_idx);
+
+	/* Create the first level instance directories */
+	err = edac_device_create_instances(edac_dev);
+	if (err) {
+		goto error0;
+	}
+
+	return 0;
+
+	/* Error unwind stack */
+
+error0:
+	edac_device_unregister_main_kobj(edac_dev);
+
+	return err;
+}
+
+/*
+ * edac_device_remove_sysfs() destructor
+ *
+ * remove a edac_device instance
+ */
+void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev)
+{
+	debugf0("%s()\n", __func__);
+
+	edac_device_delete_instances(edac_dev);
+
+	/* remove the sym link */
+	sysfs_remove_link(&edac_dev->kobj, EDAC_DEVICE_SYMLINK);
+
+	/* unregister the instance's main kobj */
+	edac_device_unregister_main_kobj(edac_dev);
+}
+
diff -puN drivers/edac/edac_mc.c~drivers-edac-add-edac_device-class drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-add-edac_device-class
+++ a/drivers/edac/edac_mc.c
@@ -88,7 +88,7 @@ static void edac_mc_dump_mci(struct mem_
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-static inline char * align_ptr(void *ptr, unsigned size)
+char * edac_align_ptr(void *ptr, unsigned size)
 {
 	unsigned align, r;
 
@@ -147,10 +147,10 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	 * hardcode everything into a single struct.
 	 */
 	mci = (struct mem_ctl_info *) 0;
-	csi = (struct csrow_info *)align_ptr(&mci[1], sizeof(*csi));
+	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
 	chi = (struct channel_info *)
-			align_ptr(&csi[nr_csrows], sizeof(*chi));
-	pvt = align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
+			edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long) pvt) + sz_pvt;
 
 	if ((mci = kmalloc(size, GFP_KERNEL)) == NULL)
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-add-edac_device-class drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-add-edac_device-class
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -94,14 +94,6 @@ static const char *edac_caps[] = {
 	[EDAC_S16ECD16ED] = "S16ECD16ED"
 };
 
-/*
- * sysfs object: /sys/devices/system/edac
- *	need to export to other files in this modules
- */
-struct sysdev_class edac_class = {
-	set_kset_name("edac"),
-};
-
 /* sysfs object:
  *	/sys/devices/system/edac/mc
  */
@@ -224,43 +216,38 @@ static struct kobj_type ktype_memctrl = 
 int edac_sysfs_memctrl_setup(void)
 {
 	int err = 0;
+	struct sysdev_class *edac_class;
 
 	debugf1("%s()\n", __func__);
 
-	/* create the /sys/devices/system/edac directory */
-	err = sysdev_class_register(&edac_class);
-
-	if (err) {
-		debugf1("%s() error=%d\n", __func__, err);
+	/* get the /sys/devices/system/edac class reference */
+	edac_class = edac_get_edac_class();
+	if (edac_class == NULL) {
+		debugf1("%s() no edac_class error=%d\n", __func__, err);
 		return err;
 	}
 
 	/* Init the MC's kobject */
 	memset(&edac_memctrl_kobj, 0, sizeof (edac_memctrl_kobj));
-	edac_memctrl_kobj.parent = &edac_class.kset.kobj;
+	edac_memctrl_kobj.parent = &edac_class->kset.kobj;
 	edac_memctrl_kobj.ktype = &ktype_memctrl;
 
 	/* generate sysfs "..../edac/mc"   */
 	err = kobject_set_name(&edac_memctrl_kobj,"mc");
-
-	if (err)
-		goto fail;
+	if (err) {
+		debugf1("%s() Failed to set name '.../edac/mc'\n", __func__ );
+		return err;
+	}
 
 	/* FIXME: maybe new sysdev_create_subdir() */
 	err = kobject_register(&edac_memctrl_kobj);
-
 	if (err) {
-		debugf1("Failed to register '.../edac/mc'\n");
-		goto fail;
+		debugf1("%s() Failed to register '.../edac/mc'\n", __func__ );
+		return err;
 	}
 
-	debugf1("Registered '.../edac/mc' kobject\n");
-
+	debugf1("%s() Registered '.../edac/mc' kobject\n",__func__);
 	return 0;
-
-fail:
-	sysdev_class_unregister(&edac_class);
-	return err;
 }
 
 /*
@@ -276,9 +263,6 @@ void edac_sysfs_memctrl_teardown(void)
 	init_completion(&edac_memctrl_kobj_complete);
 	kobject_unregister(&edac_memctrl_kobj);
 	wait_for_completion(&edac_memctrl_kobj_complete);
-
-	/* Unregister the 'edac' object */
-	sysdev_class_unregister(&edac_class);
 }
 
 
@@ -286,32 +270,38 @@ void edac_sysfs_memctrl_teardown(void)
  */
 
 /* Set of more default csrow<id> attribute show/store functions */
-static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%u\n", csrow->ue_count);
 }
 
-static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%u\n", csrow->ce_count);
 }
 
-static ssize_t csrow_size_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%u\n", PAGES_TO_MiB(csrow->nr_pages));
 }
 
-static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%s\n", mem_types[csrow->mtype]);
 }
 
-static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%s\n", dev_types[csrow->dtype]);
 }
 
-static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data, int private)
+static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
+			int private)
 {
 	return sprintf(data,"%s\n", edac_caps[csrow->edac_mode]);
 }
@@ -509,9 +499,10 @@ static int edac_create_channel_files(str
 	if (!err) {
 		/* create the CE Count attribute file */
 		err = sysfs_create_file(kobj,
-			(struct attribute *) dynamic_csrow_ce_count_attr[chan]);
+			(struct attribute *)dynamic_csrow_ce_count_attr[chan]);
 	} else {
-		debugf1("%s()  dimm labels and ce_count files created", __func__);
+		debugf1("%s()  dimm labels and ce_count files created",
+			__func__);
 	}
 
 	return err;
@@ -643,7 +634,7 @@ static ssize_t mci_sdram_scrub_rate_show
 	} else {
 		/* FIXME: produce "not implemented" ERROR for user-side.  */
 		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'get' control is not implemented!\n");
+			"Memory scrubbing 'get' control is not implemented\n");
 	}
 	return sprintf(data, "%d\n", bandwidth);
 }
@@ -755,7 +746,8 @@ MCIDEV_ATTR(ue_count,S_IRUGO,mci_ue_coun
 MCIDEV_ATTR(ce_count,S_IRUGO,mci_ce_count_show,NULL);
 
 /* memory scrubber attribute file */
-MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,mci_sdram_scrub_rate_store);
+MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,\
+			mci_sdram_scrub_rate_store);
 
 static struct mcidev_attribute *mci_attr[] = {
 	&mci_attr_reset_counters,
diff -puN drivers/edac/edac_module.c~drivers-edac-add-edac_device-class drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-add-edac_device-class
+++ a/drivers/edac/edac_module.c
@@ -13,8 +13,77 @@ int edac_debug_level = 1;
 EXPORT_SYMBOL_GPL(edac_debug_level);
 #endif
 
+/* scope is to module level only */
+struct workqueue_struct *edac_workqueue;
+
+/* private to this file */
 static struct task_struct *edac_thread;
 
+
+/*
+ * sysfs object: /sys/devices/system/edac
+ *	need to export to other files in this modules
+ */
+static struct sysdev_class edac_class = {
+	set_kset_name("edac"),
+};
+static int edac_class_valid = 0;
+
+/*
+ * edac_get_edac_class()
+ *
+ *	return pointer to the edac class of 'edac'
+ */
+struct sysdev_class *edac_get_edac_class(void)
+{
+	struct sysdev_class *classptr=NULL;
+
+	if (edac_class_valid)
+		classptr = &edac_class;
+
+	return classptr;
+}
+
+/*
+ * edac_register_sysfs_edac_name()
+ *
+ *	register the 'edac' into /sys/devices/system
+ *
+ * return:
+ *	0  success
+ *	!0 error
+ */
+static int edac_register_sysfs_edac_name(void)
+{
+	int err;
+
+	/* create the /sys/devices/system/edac directory */
+	err = sysdev_class_register(&edac_class);
+
+	if (err) {
+		debugf1("%s() error=%d\n", __func__, err);
+		return err;
+	}
+
+	edac_class_valid = 1;
+	return 0;
+}
+
+/*
+ * sysdev_class_unregister()
+ *
+ *	unregister the 'edac' from /sys/devices/system
+ */
+static void edac_unregister_sysfs_edac_name(void)
+{
+	/* only if currently registered, then unregister it */
+	if (edac_class_valid)
+		sysdev_class_unregister(&edac_class);
+
+	edac_class_valid = 0;
+}
+
+
 /*
  * Check MC status every edac_get_poll_msec().
  * Check PCI status every edac_get_poll_msec() as well.
@@ -53,11 +122,40 @@ static int edac_kernel_thread(void *arg)
 }
 
 /*
+ * edac_workqueue_setup
+ *	initialize the edac work queue for polling operations
+ */
+static int edac_workqueue_setup(void)
+{
+	edac_workqueue = create_singlethread_workqueue("edac-poller");
+	if (edac_workqueue == NULL)
+		return -ENODEV;
+	else
+		return 0;
+}
+
+/*
+ * edac_workqueue_teardown
+ *	teardown the edac workqueue
+ */
+static void edac_workqueue_teardown(void)
+{
+	if (edac_workqueue) {
+		flush_workqueue(edac_workqueue);
+		destroy_workqueue(edac_workqueue);
+		edac_workqueue = NULL;
+	}
+}
+
+
+/*
  * edac_init
  *      module initialization entry point
  */
 static int __init edac_init(void)
 {
+	int err = 0;
+
 	edac_printk(KERN_INFO, EDAC_MC, EDAC_MC_VERSION "\n");
 
 	/*
@@ -69,32 +167,61 @@ static int __init edac_init(void)
 	 */
 	edac_pci_clear_parity_errors();
 
-	/* Create the MC sysfs entries */
+	/*
+	 * perform the registration of the /sys/devices/system/edac object
+	 */
+	if (edac_register_sysfs_edac_name()) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			"Error initializing 'edac' kobject\n");
+		err = -ENODEV;
+		goto error;
+	}
+
+	/* Create the MC sysfs entries, must be first
+	 */
 	if (edac_sysfs_memctrl_setup()) {
 		edac_printk(KERN_ERR, EDAC_MC,
 			"Error initializing sysfs code\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto error_sysfs;
 	}
 
 	/* Create the PCI parity sysfs entries */
 	if (edac_sysfs_pci_setup()) {
-		edac_sysfs_memctrl_teardown();
 		edac_printk(KERN_ERR, EDAC_MC,
 			"PCI: Error initializing sysfs code\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto error_mem;
+	}
+
+	/* Setup/Initialize the edac_device system */
+	err = edac_workqueue_setup();
+	if (err) {
+		edac_printk(KERN_ERR, EDAC_MC, "init WorkQueue failure\n");
+		goto error_pci;
 	}
 
 	/* create our kernel thread */
 	edac_thread = kthread_run(edac_kernel_thread, NULL, "kedac");
 
 	if (IS_ERR(edac_thread)) {
-		/* remove the sysfs entries */
-		edac_sysfs_memctrl_teardown();
-		edac_sysfs_pci_teardown();
-		return PTR_ERR(edac_thread);
+		err = PTR_ERR(edac_thread);
+		goto error_work;
 	}
 
 	return 0;
+
+	/* Error teardown stack */
+error_work:
+	edac_workqueue_teardown();
+error_pci:
+	edac_sysfs_pci_teardown();
+error_mem:
+	edac_sysfs_memctrl_teardown();
+error_sysfs:
+	edac_unregister_sysfs_edac_name();
+error:
+	return err;
 }
 
 /*
@@ -106,9 +233,11 @@ static void __exit edac_exit(void)
 	debugf0("%s()\n", __func__);
 	kthread_stop(edac_thread);
 
-	/* tear down the sysfs device */
+	/* tear down the various subsystems*/
+	edac_workqueue_teardown();
 	edac_sysfs_memctrl_teardown();
 	edac_sysfs_pci_teardown();
+	edac_unregister_sysfs_edac_name();
 }
 
 /*
diff -puN drivers/edac/edac_module.h~drivers-edac-add-edac_device-class drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-add-edac_device-class
+++ a/drivers/edac/edac_module.h
@@ -33,6 +33,15 @@ extern int edac_device_create_sysfs(stru
 extern void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev);
 extern struct sysdev_class *edac_get_edac_class(void);
 
+/* edac core workqueue: single CPU mode */
+extern struct workqueue_struct *edac_workqueue;
+extern void edac_workq_setup(struct edac_device_ctl_info *edac_dev,
+				unsigned msec);
+extern void edac_workq_teardown(struct edac_device_ctl_info *edac_dev);
+extern void edac_device_reset_delay_period(
+			struct edac_device_ctl_info *edac_dev,
+			unsigned long value);
+
 
 /*
  * EDAC PCI functions
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
