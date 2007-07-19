From: akpm@linux-foundation.org
Subject: - drivers-edac-core-lindent-cleanup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:05 -0700
Message-ID: <200707192006.l6JK65in020107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59968 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761390AbXGSU1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: core Lindent cleanup
has been removed from the -mm tree.  Its filename was
     drivers-edac-core-lindent-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: core Lindent cleanup
From: Douglas Thompson <dougthompson@xmission.com>

Run the EDAC CORE files through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h         |  173 ++++++------
 drivers/edac/edac_device.c       |  186 ++++++-------
 drivers/edac/edac_device_sysfs.c |  389 +++++++++++++----------------
 drivers/edac/edac_mc.c           |  202 +++++++--------
 drivers/edac/edac_mc.h           |    2 
 drivers/edac/edac_mc_sysfs.c     |  336 ++++++++++---------------
 drivers/edac/edac_module.c       |   22 -
 drivers/edac/edac_module.h       |   16 -
 drivers/edac/edac_pci.c          |   75 ++---
 drivers/edac/edac_pci_sysfs.c    |  140 +++++-----
 drivers/edac/edac_stub.c         |    2 
 11 files changed, 722 insertions(+), 821 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-core-lindent-cleanup drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_core.h
@@ -84,7 +84,7 @@ extern int edac_debug_level;
 #define debugf3( ... ) edac_debug_printk(3, __VA_ARGS__ )
 #define debugf4( ... ) edac_debug_printk(4, __VA_ARGS__ )
 
-#else  /* !CONFIG_EDAC_DEBUG */
+#else				/* !CONFIG_EDAC_DEBUG */
 
 #define debugf0( ... )
 #define debugf1( ... )
@@ -92,7 +92,7 @@ extern int edac_debug_level;
 #define debugf3( ... )
 #define debugf4( ... )
 
-#endif  /* !CONFIG_EDAC_DEBUG */
+#endif				/* !CONFIG_EDAC_DEBUG */
 
 #define BIT(x) (1 << (x))
 
@@ -135,9 +135,9 @@ enum mem_type {
 	MEM_DDR,		/* Double data rate SDRAM */
 	MEM_RDDR,		/* Registered Double data rate SDRAM */
 	MEM_RMBS,		/* Rambus DRAM */
-	MEM_DDR2,               /* DDR2 RAM */
-	MEM_FB_DDR2,            /* fully buffered DDR2 */
-	MEM_RDDR2,              /* Registered DDR2 RAM */
+	MEM_DDR2,		/* DDR2 RAM */
+	MEM_FB_DDR2,		/* fully buffered DDR2 */
+	MEM_RDDR2,		/* Registered DDR2 RAM */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -211,7 +211,7 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
-extern char * edac_align_ptr(void *ptr, unsigned size);
+extern char *edac_align_ptr(void *ptr, unsigned size);
 
 /*
  * There are several things to be aware of that aren't at all obvious:
@@ -298,7 +298,7 @@ extern char * edac_align_ptr(void *ptr, 
 struct channel_info {
 	int chan_idx;		/* channel index */
 	u32 ce_count;		/* Correctable Errors for this CHANNEL */
-	char label[EDAC_MC_LABEL_LEN + 1];  /* DIMM label on motherboard */
+	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
 	struct csrow_info *csrow;	/* the parent */
 };
 
@@ -327,7 +327,7 @@ struct csrow_info {
 };
 
 struct mem_ctl_info {
-	struct list_head link;  /* for global list of mem_ctl_info structs */
+	struct list_head link;	/* for global list of mem_ctl_info structs */
 	unsigned long mtype_cap;	/* memory types supported by mc */
 	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
 	unsigned long edac_cap;	/* configuration capabilities - this is
@@ -344,14 +344,14 @@ struct mem_ctl_info {
 	/* Translates sdram memory scrub rate given in bytes/sec to the
 	   internal representation and configures whatever else needs
 	   to be configured.
-	*/
-	int (*set_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+	 */
+	int (*set_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 * bw);
 
 	/* Get the current sdram memory scrub rate from the internal
 	   representation and converts it to the closest matching
 	   bandwith in bytes/sec.
-	*/
-	int (*get_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+	 */
+	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 * bw);
 
 	/* pointer to edac checking routine */
 	void (*edac_check) (struct mem_ctl_info * mci);
@@ -362,7 +362,7 @@ struct mem_ctl_info {
 	 */
 	/* FIXME - why not send the phys page to begin with? */
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
-					unsigned long page);
+					   unsigned long page);
 	int mc_idx;
 	int nr_csrows;
 	struct csrow_info *csrows;
@@ -444,8 +444,8 @@ struct mem_ctl_info {
  */
 
 struct edac_device_counter {
-	u32	ue_count;
-	u32	ce_count;
+	u32 ue_count;
+	u32 ce_count;
 };
 
 #define INC_COUNTER(cnt)	(cnt++)
@@ -455,14 +455,13 @@ struct edac_device_counter {
  * to specify attributes of the edac_block
  */
 struct edac_attrib_spec {
-	char  name[EDAC_DEVICE_NAME_LEN + 1];
+	char name[EDAC_DEVICE_NAME_LEN + 1];
 
 	int type;
 #define	EDAC_ATTR_INT		0x01
 #define EDAC_ATTR_CHAR		0x02
 };
 
-
 /* Attribute control structure
  * In this structure is a pointer to the driver's edac_attrib_spec
  * The life of this pointer is inclusive in the life of the driver's
@@ -471,9 +470,9 @@ struct edac_attrib_spec {
 struct edac_attrib {
 	struct edac_device_block *block;	/* Up Pointer */
 
-	struct edac_attrib_spec *spec;		/* ptr to module spec entry */
+	struct edac_attrib_spec *spec;	/* ptr to module spec entry */
 
-	union {					/* actual value */
+	union {			/* actual value */
 		int edac_attrib_int_value;
 		char edac_attrib_char_value[EDAC_ATTRIB_VALUE_LEN + 1];
 	} edac_attrib_value;
@@ -482,12 +481,12 @@ struct edac_attrib {
 /* device block control structure */
 struct edac_device_block {
 	struct edac_device_instance *instance;	/* Up Pointer */
-	char  name[EDAC_DEVICE_NAME_LEN + 1];
+	char name[EDAC_DEVICE_NAME_LEN + 1];
 
 	struct edac_device_counter counters;	/* basic UE and CE counters */
 
-	int nr_attribs;				/* how many attributes */
-	struct edac_attrib *attribs;		/* this block's attributes */
+	int nr_attribs;		/* how many attributes */
+	struct edac_attrib *attribs;	/* this block's attributes */
 
 	/* edac sysfs device control */
 	struct kobject kobj;
@@ -501,7 +500,7 @@ struct edac_device_instance {
 
 	struct edac_device_counter counters;	/* instance counters */
 
-	u32 nr_blocks;				/* how many blocks */
+	u32 nr_blocks;		/* how many blocks */
 	struct edac_device_block *blocks;	/* block array */
 
 	/* edac sysfs device control */
@@ -509,7 +508,6 @@ struct edac_device_instance {
 	struct completion kobj_complete;
 };
 
-
 /*
  * Abstract edac_device control info structure
  *
@@ -539,9 +537,9 @@ struct edac_device_ctl_info {
 #endif
 
 	/* pointer to edac polling checking routine:
-	 *	If NOT NULL: points to polling check routine
-	 *	If NULL: Then assumes INTERRUPT operation, where
-	 *		MC driver will receive events
+	 *      If NOT NULL: points to polling check routine
+	 *      If NULL: Then assumes INTERRUPT operation, where
+	 *              MC driver will receive events
 	 */
 	void (*edac_check) (struct edac_device_ctl_info * edac_dev);
 
@@ -553,7 +551,7 @@ struct edac_device_ctl_info {
 
 	void *pvt_info;		/* pointer to 'private driver' info */
 
-	unsigned long start_time;/* edac_device load start time (jiffies)*/
+	unsigned long start_time;	/* edac_device load start time (jiffies) */
 
 	/* these are for safe removal of mc devices from global list while
 	 * NMI handlers may be traversing list
@@ -563,10 +561,10 @@ struct edac_device_ctl_info {
 
 	/* sysfs top name under 'edac' directory
 	 * and instance name:
-	 *	cpu/cpu0/...
-	 *	cpu/cpu1/...
-	 *	cpu/cpu2/...
-	 *	...
+	 *      cpu/cpu0/...
+	 *      cpu/cpu1/...
+	 *      cpu/cpu2/...
+	 *      ...
 	 */
 	char name[EDAC_DEVICE_NAME_LEN + 1];
 
@@ -594,8 +592,7 @@ struct edac_device_ctl_info {
 		container_of(w,struct edac_device_ctl_info,work)
 
 /* Function to calc the number of delay jiffies from poll_msec */
-static inline void edac_device_calc_delay(
-				struct edac_device_ctl_info *edac_dev)
+static inline void edac_device_calc_delay(struct edac_device_ctl_info *edac_dev)
 {
 	/* convert from msec to jiffies */
 	edac_dev->delay = edac_dev->poll_msec * HZ / 1000;
@@ -609,15 +606,14 @@ static inline void edac_device_calc_dela
  * it is going to control/register with the EDAC CORE.
  */
 extern struct edac_device_ctl_info *edac_device_alloc_ctl_info(
-	unsigned sizeof_private,
-	char *edac_device_name,
-	unsigned nr_instances,
-	char *edac_block_name,
-	unsigned nr_blocks,
-	unsigned offset_value,
-	struct edac_attrib_spec *attrib_spec,
-	unsigned nr_attribs
-);
+		unsigned sizeof_private,
+		char *edac_device_name,
+		unsigned nr_instances,
+		char *edac_block_name,
+		unsigned nr_blocks,
+		unsigned offset_value,
+		struct edac_attrib_spec *attrib_spec,
+		unsigned nr_attribs);
 
 /* The offset value can be:
  *	-1 indicating no offset value
@@ -627,13 +623,13 @@ extern struct edac_device_ctl_info *edac
  */
 #define	BLOCK_OFFSET_VALUE_OFF	((unsigned) -1)
 
-extern void edac_device_free_ctl_info( struct edac_device_ctl_info *ctl_info);
+extern void edac_device_free_ctl_info(struct edac_device_ctl_info *ctl_info);
 
 #ifdef CONFIG_PCI
 
 struct edac_pci_counter {
-	atomic_t	pe_count;
-	atomic_t	npe_count;
+	atomic_t pe_count;
+	atomic_t npe_count;
 };
 
 /*
@@ -658,9 +654,9 @@ struct edac_pci_ctl_info {
 #endif
 
 	/* pointer to edac polling checking routine:
-	 *	If NOT NULL: points to polling check routine
-	 *	If NULL: Then assumes INTERRUPT operation, where
-	 *		MC driver will receive events
+	 *      If NOT NULL: points to polling check routine
+	 *      If NULL: Then assumes INTERRUPT operation, where
+	 *              MC driver will receive events
 	 */
 	void (*edac_check) (struct edac_pci_ctl_info * edac_dev);
 
@@ -672,7 +668,7 @@ struct edac_pci_ctl_info {
 
 	void *pvt_info;		/* pointer to 'private driver' info */
 
-	unsigned long start_time;/* edac_pci load start time (jiffies)*/
+	unsigned long start_time;	/* edac_pci load start time (jiffies) */
 
 	/* these are for safe removal of devices from global list while
 	 * NMI handlers may be traversing list
@@ -682,10 +678,10 @@ struct edac_pci_ctl_info {
 
 	/* sysfs top name under 'edac' directory
 	 * and instance name:
-	 *	cpu/cpu0/...
-	 *	cpu/cpu1/...
-	 *	cpu/cpu2/...
-	 *	...
+	 *      cpu/cpu0/...
+	 *      cpu/cpu1/...
+	 *      cpu/cpu2/...
+	 *      ...
 	 */
 	char name[EDAC_DEVICE_NAME_LEN + 1];
 
@@ -704,7 +700,7 @@ struct edac_pci_ctl_info {
 
 /* write all or some bits in a byte-register*/
 static inline void pci_write_bits8(struct pci_dev *pdev, int offset, u8 value,
-		u8 mask)
+				   u8 mask)
 {
 	if (mask != 0xff) {
 		u8 buf;
@@ -720,7 +716,7 @@ static inline void pci_write_bits8(struc
 
 /* write all or some bits in a word-register*/
 static inline void pci_write_bits16(struct pci_dev *pdev, int offset,
-		u16 value, u16 mask)
+				    u16 value, u16 mask)
 {
 	if (mask != 0xffff) {
 		u16 buf;
@@ -736,7 +732,7 @@ static inline void pci_write_bits16(stru
 
 /* write all or some bits in a dword-register*/
 static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
-		u32 value, u32 mask)
+				    u32 value, u32 mask)
 {
 	if (mask != 0xffff) {
 		u32 buf;
@@ -750,13 +746,13 @@ static inline void pci_write_bits32(stru
 	pci_write_config_dword(pdev, offset, value);
 }
 
-#endif /* CONFIG_PCI */
+#endif				/* CONFIG_PCI */
 
-extern struct mem_ctl_info * edac_mc_find(int idx);
-extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
-extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
+extern struct mem_ctl_info *edac_mc_find(int idx);
+extern int edac_mc_add_mc(struct mem_ctl_info *mci, int mc_idx);
+extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
-					unsigned long page);
+				      unsigned long page);
 
 /*
  * The no info errors are used when error overflows are reported.
@@ -769,44 +765,43 @@ extern int edac_mc_find_csrow_by_page(st
  * statement clutter and extra function arguments.
  */
 extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		unsigned long syndrome, int row, int channel,
-		const char *msg);
+			      unsigned long page_frame_number,
+			      unsigned long offset_in_page,
+			      unsigned long syndrome, int row, int channel,
+			      const char *msg);
 extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
-		const char *msg);
+				      const char *msg);
 extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		int row, const char *msg);
+			      unsigned long page_frame_number,
+			      unsigned long offset_in_page, int row,
+			      const char *msg);
 extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
-		const char *msg);
-extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-		unsigned int csrow,
-		unsigned int channel0,
-		unsigned int channel1,
-		char *msg);
-extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-		unsigned int csrow,
-		unsigned int channel,
-		char *msg);
+				      const char *msg);
+extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci, unsigned int csrow,
+				  unsigned int channel0, unsigned int channel1,
+				  char *msg);
+extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci, unsigned int csrow,
+				  unsigned int channel, char *msg);
 
 /*
  * edac_device APIs
  */
 extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-		unsigned nr_chans);
+					  unsigned nr_chans);
 extern void edac_mc_free(struct mem_ctl_info *mci);
-extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx);
-extern struct edac_device_ctl_info * edac_device_del_device(struct device *dev);
+extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev,
+				  int edac_idx);
+extern struct edac_device_ctl_info *edac_device_del_device(struct device *dev);
 extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
-		int inst_nr, int block_nr, const char *msg);
+				  int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
-		int inst_nr, int block_nr, const char *msg);
+				  int inst_nr, int block_nr, const char *msg);
 
 /*
  * edac_pci APIs
  */
-extern struct edac_pci_ctl_info *
-edac_pci_alloc_ctl_info(unsigned int sz_pvt, const char *edac_pci_name);
+extern struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt, const char
+							 *edac_pci_name);
 
 extern void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci);
 
@@ -814,10 +809,10 @@ extern void
 edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci, unsigned long value);
 
 extern int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx);
-extern struct edac_pci_ctl_info * edac_pci_del_device(struct device *dev);
+extern struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev);
 
-extern struct edac_pci_ctl_info *
-edac_pci_create_generic_ctl(struct device *dev, const char *mod_name);
+extern struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev, const char
+							     *mod_name);
 
 extern void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci);
 extern int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci);
@@ -826,6 +821,6 @@ extern void edac_pci_remove_sysfs(struct
 /*
  * edac misc APIs
  */
-extern char * edac_op_state_toString(int op_state);
+extern char *edac_op_state_toString(int op_state);
 
 #endif				/* _EDAC_CORE_H_ */
diff -puN drivers/edac/edac_device.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_device.c
@@ -35,7 +35,6 @@
 static DECLARE_MUTEX(device_ctls_mutex);
 static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
 
-
 static inline void lock_device_list(void)
 {
 	down(&device_ctls_mutex);
@@ -46,18 +45,17 @@ static inline void unlock_device_list(vo
 	up(&device_ctls_mutex);
 }
 
-
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
-	debugf3("\tedac_dev = %p dev_idx=%d \n", edac_dev,edac_dev->dev_idx);
+	debugf3("\tedac_dev = %p dev_idx=%d \n", edac_dev, edac_dev->dev_idx);
 	debugf4("\tedac_dev->edac_check = %p\n", edac_dev->edac_check);
 	debugf3("\tdev = %p\n", edac_dev->dev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n",
 		edac_dev->mod_name, edac_dev->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", edac_dev->pvt_info);
 }
-#endif  /* CONFIG_EDAC_DEBUG */
+#endif				/* CONFIG_EDAC_DEBUG */
 
 /*
  * The alloc() and free() functions for the 'edac_device' control info
@@ -71,7 +69,8 @@ struct edac_device_ctl_info *edac_device
 	char *edac_block_name,
 	unsigned nr_blocks,
 	unsigned offset_value,
-	struct edac_attrib_spec *attrib_spec,
+	struct edac_attrib_spec
+	*attrib_spec,
 	unsigned nr_attribs)
 {
 	struct edac_device_ctl_info *dev_ctl;
@@ -84,35 +83,35 @@ struct edac_device_ctl_info *edac_device
 	void *pvt;
 
 	debugf1("%s() instances=%d blocks=%d\n",
-		__func__,nr_instances,nr_blocks);
+		__func__, nr_instances, nr_blocks);
 
 	/* Figure out the offsets of the various items from the start of an
 	 * ctl_info structure.  We want the alignment of each item
 	 * to be at least as stringent as what the compiler would
 	 * provide if we could simply hardcode everything into a single struct.
 	 */
-	dev_ctl = (struct edac_device_ctl_info *) 0;
+	dev_ctl = (struct edac_device_ctl_info *)0;
 
 	/* Calc the 'end' offset past the ctl_info structure */
 	dev_inst = (struct edac_device_instance *)
-			edac_align_ptr(&dev_ctl[1],sizeof(*dev_inst));
+	    edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
 	/* Calc the 'end' offset past the instance array */
 	dev_blk = (struct edac_device_block *)
-			edac_align_ptr(&dev_inst[nr_instances],sizeof(*dev_blk));
+	    edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
 	/* Calc the 'end' offset past the dev_blk array */
 	count = nr_instances * nr_blocks;
 	dev_attrib = (struct edac_attrib *)
-			edac_align_ptr(&dev_blk[count],sizeof(*dev_attrib));
+	    edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
 	/* Check for case of NO attributes specified */
 	if (nr_attribs > 0)
 		count *= nr_attribs;
 
 	/* Calc the 'end' offset past the attributes array */
-	pvt = edac_align_ptr(&dev_attrib[count],sz_private);
-	total_size = ((unsigned long) pvt) + sz_private;
+	pvt = edac_align_ptr(&dev_attrib[count], sz_private);
+	total_size = ((unsigned long)pvt) + sz_private;
 
 	/* Allocate the amount of memory for the set of control structures */
 	if ((dev_ctl = kmalloc(total_size, GFP_KERNEL)) == NULL)
@@ -122,22 +121,21 @@ struct edac_device_ctl_info *edac_device
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	dev_inst = (struct edac_device_instance *)
-			(((char *) dev_ctl) + ((unsigned long) dev_inst));
+	    (((char *)dev_ctl) + ((unsigned long)dev_inst));
 	dev_blk = (struct edac_device_block *)
-			(((char *) dev_ctl) + ((unsigned long) dev_blk));
+	    (((char *)dev_ctl) + ((unsigned long)dev_blk));
 	dev_attrib = (struct edac_attrib *)
-			(((char *) dev_ctl) + ((unsigned long) dev_attrib));
-	pvt = sz_private ?
-			(((char *) dev_ctl) + ((unsigned long) pvt)) : NULL;
+	    (((char *)dev_ctl) + ((unsigned long)dev_attrib));
+	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
-	memset(dev_ctl, 0, total_size);		/* clear all fields */
+	memset(dev_ctl, 0, total_size);	/* clear all fields */
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
 
 	/* Name of this edac device, ensure null terminated */
-	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s", edac_device_name);
-	dev_ctl->name[sizeof(dev_ctl->name)-1] = '\0';
+	snprintf(dev_ctl->name, sizeof(dev_ctl->name), "%s", edac_device_name);
+	dev_ctl->name[sizeof(dev_ctl->name) - 1] = '\0';
 
 	/* Initialize every Instance */
 	for (instance = 0; instance < nr_instances; instance++) {
@@ -149,24 +147,22 @@ struct edac_device_ctl_info *edac_device
 
 		/* name of this instance */
 		snprintf(inst->name, sizeof(inst->name),
-			"%s%u", edac_device_name, instance);
-		inst->name[sizeof(inst->name)-1] = '\0';
+			 "%s%u", edac_device_name, instance);
+		inst->name[sizeof(inst->name) - 1] = '\0';
 
 		/* Initialize every block in each instance */
-		for (		block = 0;
-				block < nr_blocks;
-				block++) {
+		for (block = 0; block < nr_blocks; block++) {
 			blk = &blk_p[block];
 			blk->instance = inst;
 			blk->nr_attribs = nr_attribs;
 			attrib_p = &dev_attrib[block * nr_attribs];
 			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
-				"%s%d", edac_block_name,block+1);
-			blk->name[sizeof(blk->name)-1] = '\0';
+				 "%s%d", edac_block_name, block + 1);
+			blk->name[sizeof(blk->name) - 1] = '\0';
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
-				__func__, instance,block,blk->name);
+				__func__, instance, block, blk->name);
 
 			if (attrib_spec != NULL) {
 				/* when there is an attrib_spec passed int then
@@ -178,7 +174,7 @@ struct edac_device_ctl_info *edac_device
 
 					/* Link each attribute to the caller's
 					 * spec entry, for name and type
-				 	 */
+					 */
 					attrib->spec = &attrib_spec[attr];
 				}
 			}
@@ -190,6 +186,7 @@ struct edac_device_ctl_info *edac_device
 
 	return dev_ctl;
 }
+
 EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_info);
 
 /*
@@ -197,19 +194,18 @@ EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_
  *	frees the memory allocated by the edac_device_alloc_ctl_info()
  *	function
  */
-void edac_device_free_ctl_info( struct edac_device_ctl_info *ctl_info) {
+void edac_device_free_ctl_info(struct edac_device_ctl_info *ctl_info)
+{
 	kfree(ctl_info);
 }
-EXPORT_SYMBOL_GPL(edac_device_free_ctl_info);
-
 
+EXPORT_SYMBOL_GPL(edac_device_free_ctl_info);
 
 /*
  * find_edac_device_by_dev
  *	scans the edac_device list for a specific 'struct device *'
  */
-static struct edac_device_ctl_info *
-find_edac_device_by_dev(struct device *dev)
+static struct edac_device_ctl_info *find_edac_device_by_dev(struct device *dev)
 {
 	struct edac_device_ctl_info *edac_dev;
 	struct list_head *item;
@@ -234,7 +230,7 @@ find_edac_device_by_dev(struct device *d
  *		0 on success
  *		1 on failure.
  */
-static int add_edac_dev_to_global_list (struct edac_device_ctl_info *edac_dev)
+static int add_edac_dev_to_global_list(struct edac_device_ctl_info *edac_dev)
 {
 	struct list_head *item, *insert_before;
 	struct edac_device_ctl_info *rover;
@@ -261,17 +257,18 @@ static int add_edac_dev_to_global_list (
 	list_add_tail_rcu(&edac_dev->link, insert_before);
 	return 0;
 
-fail0:
+      fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		"%s (%s) %s %s already assigned %d\n",
-		rover->dev->bus_id, dev_name(rover),
-		rover->mod_name, rover->ctl_name, rover->dev_idx);
+		    "%s (%s) %s %s already assigned %d\n",
+		    rover->dev->bus_id, dev_name(rover),
+		    rover->mod_name, rover->ctl_name, rover->dev_idx);
 	return 1;
 
-fail1:
+      fail1:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		"bug in low-level driver: attempt to assign\n"
-		"    duplicate dev_idx %d in %s()\n", rover->dev_idx, __func__);
+		    "bug in low-level driver: attempt to assign\n"
+		    "    duplicate dev_idx %d in %s()\n", rover->dev_idx,
+		    __func__);
 	return 1;
 }
 
@@ -290,8 +287,8 @@ static void complete_edac_device_list_de
 /*
  * del_edac_device_from_global_list
  */
-static void del_edac_device_from_global_list(
-			struct edac_device_ctl_info *edac_device)
+static void del_edac_device_from_global_list(struct edac_device_ctl_info
+					     *edac_device)
 {
 	list_del_rcu(&edac_device->link);
 	init_completion(&edac_device->complete);
@@ -308,7 +305,7 @@ static void del_edac_device_from_global_
  *
  * Caller must hold device_ctls_mutex.
  */
-struct edac_device_ctl_info * edac_device_find(int idx)
+struct edac_device_ctl_info *edac_device_find(int idx)
 {
 	struct list_head *item;
 	struct edac_device_ctl_info *edac_dev;
@@ -328,8 +325,8 @@ struct edac_device_ctl_info * edac_devic
 
 	return NULL;
 }
-EXPORT_SYMBOL(edac_device_find);
 
+EXPORT_SYMBOL(edac_device_find);
 
 /*
  * edac_device_workq_function
@@ -338,14 +335,13 @@ EXPORT_SYMBOL(edac_device_find);
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_device_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work*) work_req;
-	struct edac_device_ctl_info *edac_dev =
-		to_edac_device_ctl_work(d_work);
+	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 #else
 static void edac_device_workq_function(void *ptr)
 {
 	struct edac_device_ctl_info *edac_dev =
-		(struct edac_device_ctl_info *) ptr;
+	    (struct edac_device_ctl_info *)ptr;
 #endif
 
 	//debugf0("%s() here and running\n", __func__);
@@ -353,14 +349,14 @@ static void edac_device_workq_function(v
 
 	/* Only poll controllers that are running polled and have a check */
 	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
-					(edac_dev->edac_check != NULL)) {
+	    (edac_dev->edac_check != NULL)) {
 		edac_dev->edac_check(edac_dev);
 	}
 
 	unlock_device_list();
 
 	/* Reschedule */
-	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
+	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
 }
 
 /*
@@ -369,7 +365,7 @@ static void edac_device_workq_function(v
  *	passing in the new delay period in msec
  */
 void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
-		unsigned msec)
+			     unsigned msec)
 {
 	debugf0("%s()\n", __func__);
 
@@ -403,9 +399,8 @@ void edac_device_workq_teardown(struct e
  * edac_device_reset_delay_period
  */
 
-void edac_device_reset_delay_period(
-		struct edac_device_ctl_info *edac_dev,
-		unsigned long value)
+void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
+				    unsigned long value)
 {
 	lock_device_list();
 
@@ -450,7 +445,7 @@ int edac_device_add_device(struct edac_d
 	/* create this instance's sysfs entries */
 	if (edac_device_create_sysfs(edac_dev)) {
 		edac_device_printk(edac_dev, KERN_WARNING,
-			"failed to create sysfs device\n");
+				   "failed to create sysfs device\n");
 		goto fail1;
 	}
 
@@ -468,27 +463,27 @@ int edac_device_add_device(struct edac_d
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}
 
-
 	/* Report action taken */
 	edac_device_printk(edac_dev, KERN_INFO,
-		"Giving out device to module '%s' controller '%s': DEV '%s' (%s)\n",
-		edac_dev->mod_name,
-		edac_dev->ctl_name,
-		dev_name(edac_dev),
-		edac_op_state_toString(edac_dev->op_state)
-		);
+			   "Giving out device to module '%s' controller '%s': DEV '%s' (%s)\n",
+			   edac_dev->mod_name,
+			   edac_dev->ctl_name,
+			   dev_name(edac_dev),
+			   edac_op_state_toString(edac_dev->op_state)
+	    );
 
 	unlock_device_list();
 	return 0;
 
-fail1:
+      fail1:
 	/* Some error, so remove the entry from the lsit */
 	del_edac_device_from_global_list(edac_dev);
 
-fail0:
+      fail0:
 	unlock_device_list();
 	return 1;
 }
+
 EXPORT_SYMBOL_GPL(edac_device_add_device);
 
 /**
@@ -504,7 +499,7 @@ EXPORT_SYMBOL_GPL(edac_device_add_device
  *	Pointer to removed edac_device structure,
  *	OR NULL if device not found.
  */
-struct edac_device_ctl_info * edac_device_del_device(struct device *dev)
+struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
 {
 	struct edac_device_ctl_info *edac_dev;
 
@@ -532,16 +527,14 @@ struct edac_device_ctl_info * edac_devic
 	unlock_device_list();
 
 	edac_printk(KERN_INFO, EDAC_MC,
-		"Removed device %d for %s %s: DEV %s\n",
-		edac_dev->dev_idx,
-		edac_dev->mod_name,
-		edac_dev->ctl_name,
-		dev_name(edac_dev));
+		    "Removed device %d for %s %s: DEV %s\n",
+		    edac_dev->dev_idx,
+		    edac_dev->mod_name, edac_dev->ctl_name, dev_name(edac_dev));
 
 	return edac_dev;
 }
-EXPORT_SYMBOL_GPL(edac_device_del_device);
 
+EXPORT_SYMBOL_GPL(edac_device_del_device);
 
 static inline int edac_device_get_log_ce(struct edac_device_ctl_info *edac_dev)
 {
@@ -553,8 +546,8 @@ static inline int edac_device_get_log_ue
 	return edac_dev->log_ue;
 }
 
-static inline int edac_device_get_panic_on_ue(
-		struct edac_device_ctl_info *edac_dev)
+static inline int edac_device_get_panic_on_ue(struct edac_device_ctl_info
+					      *edac_dev)
 {
 	return edac_dev->panic_on_ue;
 }
@@ -564,15 +557,16 @@ static inline int edac_device_get_panic_
  *	perform a common output and handling of an 'edac_dev' CE event
  */
 void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
-		int inst_nr, int block_nr, const char *msg)
+			   int inst_nr, int block_nr, const char *msg)
 {
 	struct edac_device_instance *instance;
 	struct edac_device_block *block = NULL;
 
 	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-			"INTERNAL ERROR: 'instance' out of range "
-			"(%d >= %d)\n", inst_nr, edac_dev->nr_instances);
+				   "INTERNAL ERROR: 'instance' out of range "
+				   "(%d >= %d)\n", inst_nr,
+				   edac_dev->nr_instances);
 		return;
 	}
 
@@ -580,8 +574,9 @@ void edac_device_handle_ce(struct edac_d
 
 	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-			"INTERNAL ERROR: instance %d 'block' out of range "
-			"(%d >= %d)\n", inst_nr, block_nr, instance->nr_blocks);
+				   "INTERNAL ERROR: instance %d 'block' out of range "
+				   "(%d >= %d)\n", inst_nr, block_nr,
+				   instance->nr_blocks);
 		return;
 	}
 
@@ -596,10 +591,11 @@ void edac_device_handle_ce(struct edac_d
 
 	if (edac_device_get_log_ce(edac_dev))
 		edac_device_printk(edac_dev, KERN_WARNING,
-		"CE ctl: %s, instance: %s, block: %s: %s\n",
-		edac_dev->ctl_name, instance->name,
-		block ? block->name : "N/A", msg);
+				   "CE ctl: %s, instance: %s, block: %s: %s\n",
+				   edac_dev->ctl_name, instance->name,
+				   block ? block->name : "N/A", msg);
 }
+
 EXPORT_SYMBOL_GPL(edac_device_handle_ce);
 
 /*
@@ -607,15 +603,16 @@ EXPORT_SYMBOL_GPL(edac_device_handle_ce)
  *	perform a common output and handling of an 'edac_dev' UE event
  */
 void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
-		int inst_nr, int block_nr, const char *msg)
+			   int inst_nr, int block_nr, const char *msg)
 {
 	struct edac_device_instance *instance;
 	struct edac_device_block *block = NULL;
 
 	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-			"INTERNAL ERROR: 'instance' out of range "
-			"(%d >= %d)\n", inst_nr, edac_dev->nr_instances);
+				   "INTERNAL ERROR: 'instance' out of range "
+				   "(%d >= %d)\n", inst_nr,
+				   edac_dev->nr_instances);
 		return;
 	}
 
@@ -623,8 +620,9 @@ void edac_device_handle_ue(struct edac_d
 
 	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-			"INTERNAL ERROR: instance %d 'block' out of range "
-			"(%d >= %d)\n", inst_nr, block_nr, instance->nr_blocks);
+				   "INTERNAL ERROR: instance %d 'block' out of range "
+				   "(%d >= %d)\n", inst_nr, block_nr,
+				   instance->nr_blocks);
 		return;
 	}
 
@@ -639,14 +637,14 @@ void edac_device_handle_ue(struct edac_d
 
 	if (edac_device_get_log_ue(edac_dev))
 		edac_device_printk(edac_dev, KERN_EMERG,
-		"UE ctl: %s, instance: %s, block: %s: %s\n",
-		edac_dev->ctl_name, instance->name,
-		block ? block->name : "N/A", msg);
+				   "UE ctl: %s, instance: %s, block: %s: %s\n",
+				   edac_dev->ctl_name, instance->name,
+				   block ? block->name : "N/A", msg);
 
 	if (edac_device_get_panic_on_ue(edac_dev))
 		panic("EDAC %s: UE instance: %s, block %s: %s\n",
-			edac_dev->ctl_name, instance->name,
-			block ? block->name : "N/A", msg);
+		      edac_dev->ctl_name, instance->name,
+		      block ? block->name : "N/A", msg);
 }
-EXPORT_SYMBOL_GPL(edac_device_handle_ue);
 
+EXPORT_SYMBOL_GPL(edac_device_handle_ue);
diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_device_sysfs.c
@@ -16,7 +16,6 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-
 #define EDAC_DEVICE_SYMLINK	"device"
 
 #define to_edacdev(k) container_of(k, struct edac_device_ctl_info, kobj)
@@ -25,43 +24,41 @@
 #ifdef DKT
 
 static ssize_t edac_dev_ue_count_show(struct edac_device_ctl_info *edac_dev,
-					char *data)
+				      char *data)
 {
-	return sprintf(data,"%d\n", edac_dev->ue_count);
+	return sprintf(data, "%d\n", edac_dev->ue_count);
 }
 
 static ssize_t edac_dev_ce_count_show(struct edac_device_ctl_info *edac_dev,
-					char *data)
+				      char *data)
 {
-	return sprintf(data,"%d\n", edac_dev->ce_count);
+	return sprintf(data, "%d\n", edac_dev->ce_count);
 }
 
 static ssize_t edac_dev_seconds_show(struct edac_device_ctl_info *edac_dev,
-					char *data)
+				     char *data)
 {
-	return sprintf(data,"%ld\n", (jiffies - edac_dev->start_time) / HZ);
+	return sprintf(data, "%ld\n", (jiffies - edac_dev->start_time) / HZ);
 }
 
 static ssize_t edac_dev_ctl_name_show(struct edac_device_ctl_info *edac_dev,
-					char *data)
+				      char *data)
 {
-	return sprintf(data,"%s\n", edac_dev->ctl_name);
+	return sprintf(data, "%s\n", edac_dev->ctl_name);
 }
 
-
 struct edacdev_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct edac_device_ctl_info *,char *);
-	ssize_t (*store)(struct edac_device_ctl_info *, const char *,size_t);
+	 ssize_t(*show) (struct edac_device_ctl_info *, char *);
+	 ssize_t(*store) (struct edac_device_ctl_info *, const char *, size_t);
 };
 
-
 /* EDAC DEVICE show/store functions for top most object */
 static ssize_t edacdev_show(struct kobject *kobj, struct attribute *attr,
-		char *buffer)
+			    char *buffer)
 {
 	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute * edacdev_attr = to_edacdev_attr(attr);
+	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
 
 	if (edacdev_attr->show)
 		return edacdev_attr->show(edac_dev, buffer);
@@ -70,10 +67,10 @@ static ssize_t edacdev_show(struct kobje
 }
 
 static ssize_t edacdev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
+			     const char *buffer, size_t count)
 {
 	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute * edacdev_attr = to_edacdev_attr(attr);
+	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
 
 	if (edacdev_attr->store)
 		return edacdev_attr->store(edac_dev, buffer, count);
@@ -94,14 +91,13 @@ static struct edacdev_attribute edac_dev
 };
 
 /* default Control file */
-EDACDEV_ATTR(reset_counters,S_IWUSR,NULL,edac_dev_reset_counters_store);
+EDACDEV_ATTR(reset_counters, S_IWUSR, NULL, edac_dev_reset_counters_store);
 
 /* default Attribute files */
-EDACDEV_ATTR(mc_name,S_IRUGO,edac_dev_ctl_name_show,NULL);
-EDACDEV_ATTR(seconds_since_reset,S_IRUGO,edac_dev_seconds_show,NULL);
-EDACDEV_ATTR(ue_count,S_IRUGO,edac_dev_ue_count_show,NULL);
-EDACDEV_ATTR(ce_count,S_IRUGO,edac_dev_ce_count_show,NULL);
-
+EDACDEV_ATTR(mc_name, S_IRUGO, edac_dev_ctl_name_show, NULL);
+EDACDEV_ATTR(seconds_since_reset, S_IRUGO, edac_dev_seconds_show, NULL);
+EDACDEV_ATTR(ue_count, S_IRUGO, edac_dev_ue_count_show, NULL);
+EDACDEV_ATTR(ce_count, S_IRUGO, edac_dev_ce_count_show, NULL);
 
 static struct edacdev_attribute *edacdev_attr[] = {
 	&edacdev_attr_reset_counters,
@@ -127,7 +123,7 @@ static void edac_dev_instance_release(st
 static struct kobj_type ktype_device = {
 	.release = edac_dev_instance_release,
 	.sysfs_ops = &edacdev_ops,
-	.default_attrs = (struct attribute **) edacdev_attr,
+	.default_attrs = (struct attribute **)edacdev_attr,
 };
 
 #endif
@@ -139,67 +135,66 @@ static struct kobj_type ktype_device = {
  */
 
 /* 'log_ue' */
-static ssize_t edac_device_ctl_log_ue_show(
-		struct edac_device_ctl_info *ctl_info, char *data)
+static ssize_t edac_device_ctl_log_ue_show(struct edac_device_ctl_info
+					   *ctl_info, char *data)
 {
-        return sprintf(data,"%u\n", ctl_info->log_ue);
+	return sprintf(data, "%u\n", ctl_info->log_ue);
 }
 
-static ssize_t edac_device_ctl_log_ue_store(
-		struct edac_device_ctl_info *ctl_info,
-			const char *data,size_t count)
+static ssize_t edac_device_ctl_log_ue_store(struct edac_device_ctl_info
+					    *ctl_info, const char *data,
+					    size_t count)
 {
 	/* if parameter is zero, turn off flag, if non-zero turn on flag */
-	ctl_info->log_ue = (simple_strtoul(data,NULL,0) != 0);
+	ctl_info->log_ue = (simple_strtoul(data, NULL, 0) != 0);
 
-        return count;
+	return count;
 }
 
 /* 'log_ce' */
-static ssize_t edac_device_ctl_log_ce_show(
-		struct edac_device_ctl_info *ctl_info,char *data)
+static ssize_t edac_device_ctl_log_ce_show(struct edac_device_ctl_info
+					   *ctl_info, char *data)
 {
-        return sprintf(data,"%u\n", ctl_info->log_ce);
+	return sprintf(data, "%u\n", ctl_info->log_ce);
 }
 
-static ssize_t edac_device_ctl_log_ce_store(
-		struct edac_device_ctl_info *ctl_info,
-			const char *data,size_t count)
+static ssize_t edac_device_ctl_log_ce_store(struct edac_device_ctl_info
+					    *ctl_info, const char *data,
+					    size_t count)
 {
 	/* if parameter is zero, turn off flag, if non-zero turn on flag */
-	ctl_info->log_ce = (simple_strtoul(data,NULL,0) != 0);
+	ctl_info->log_ce = (simple_strtoul(data, NULL, 0) != 0);
 
-        return count;
+	return count;
 }
 
-
 /* 'panic_on_ue' */
-static ssize_t edac_device_ctl_panic_on_ue_show(
-		struct edac_device_ctl_info *ctl_info, char *data)
+static ssize_t edac_device_ctl_panic_on_ue_show(struct edac_device_ctl_info
+						*ctl_info, char *data)
 {
-        return sprintf(data,"%u\n", ctl_info->panic_on_ue);
+	return sprintf(data, "%u\n", ctl_info->panic_on_ue);
 }
 
-static ssize_t edac_device_ctl_panic_on_ue_store(
-		struct edac_device_ctl_info *ctl_info,
-			const char *data,size_t count)
+static ssize_t edac_device_ctl_panic_on_ue_store(struct edac_device_ctl_info
+						 *ctl_info, const char *data,
+						 size_t count)
 {
 	/* if parameter is zero, turn off flag, if non-zero turn on flag */
-	ctl_info->panic_on_ue = (simple_strtoul(data,NULL,0) != 0);
+	ctl_info->panic_on_ue = (simple_strtoul(data, NULL, 0) != 0);
 
 	return count;
 }
 
 /* 'poll_msec' show and store functions*/
-static ssize_t edac_device_ctl_poll_msec_show(
-		struct edac_device_ctl_info *ctl_info, char *data)
+static ssize_t edac_device_ctl_poll_msec_show(struct edac_device_ctl_info
+					      *ctl_info, char *data)
 {
-        return sprintf(data,"%u\n", ctl_info->poll_msec);
+	return sprintf(data, "%u\n", ctl_info->poll_msec);
 }
 
-static ssize_t edac_device_ctl_poll_msec_store(
-		struct edac_device_ctl_info *ctl_info,
-		const char *data,size_t count)
+static ssize_t edac_device_ctl_poll_msec_store(struct edac_device_ctl_info
+					       *ctl_info, const char *data,
+					       size_t count)
 {
 	unsigned long value;
 
@@ -208,18 +203,17 @@ static ssize_t edac_device_ctl_poll_msec
 	 * Then cancel last outstanding delay for the work request
 	 * and set a new one.
 	 */
-	value = simple_strtoul(data,NULL,0);
-	edac_device_reset_delay_period(ctl_info,value);
+	value = simple_strtoul(data, NULL, 0);
+	edac_device_reset_delay_period(ctl_info, value);
 
-        return count;
+	return count;
 }
 
-
 /* edac_device_ctl_info specific attribute structure */
 struct ctl_info_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct edac_device_ctl_info *,char *);
-        ssize_t (*store)(struct edac_device_ctl_info *,const char *,size_t);
+	struct attribute attr;
+	 ssize_t(*show) (struct edac_device_ctl_info *, char *);
+	 ssize_t(*store) (struct edac_device_ctl_info *, const char *, size_t);
 };
 
 #define to_ctl_info(k) container_of(k, struct edac_device_ctl_info, kobj)
@@ -227,34 +221,33 @@ struct ctl_info_attribute {
 
 /* Function to 'show' fields from the edac_dev 'ctl_info' structure */
 static ssize_t edac_dev_ctl_info_show(struct kobject *kobj,
-                        struct attribute *attr,
-                        char *buffer)
+				      struct attribute *attr, char *buffer)
 {
-        struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
-        struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
+	struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
+	struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
 
-        if (ctl_info_attr->show)
-                return ctl_info_attr->show(edac_dev,buffer);
-        return -EIO;
+	if (ctl_info_attr->show)
+		return ctl_info_attr->show(edac_dev, buffer);
+	return -EIO;
 }
 
 /* Function to 'store' fields into the edac_dev 'ctl_info' structure */
 static ssize_t edac_dev_ctl_info_store(struct kobject *kobj,
-                        struct attribute *attr,
-                	const char *buffer, size_t count)
+				       struct attribute *attr,
+				       const char *buffer, size_t count)
 {
-        struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
-        struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
+	struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
+	struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
 
-        if (ctl_info_attr->store)
-                return ctl_info_attr->store(edac_dev, buffer, count);
-        return -EIO;
+	if (ctl_info_attr->store)
+		return ctl_info_attr->store(edac_dev, buffer, count);
+	return -EIO;
 }
 
 /* edac_dev file operations for an 'ctl_info' */
 static struct sysfs_ops device_ctl_info_ops = {
-	.show   = edac_dev_ctl_info_show,
-	.store  = edac_dev_ctl_info_store
+	.show = edac_dev_ctl_info_show,
+	.store = edac_dev_ctl_info_store
 };
 
 #define CTL_INFO_ATTR(_name,_mode,_show,_store)        \
@@ -264,21 +257,16 @@ static struct ctl_info_attribute attr_ct
         .store  = _store,                                       \
 };
 
-
 /* Declare the various ctl_info attributes here and their respective ops */
-CTL_INFO_ATTR(log_ue,S_IRUGO|S_IWUSR,
-		edac_device_ctl_log_ue_show,
-		edac_device_ctl_log_ue_store);
-CTL_INFO_ATTR(log_ce,S_IRUGO|S_IWUSR,
-		edac_device_ctl_log_ce_show,
-		edac_device_ctl_log_ce_store);
-CTL_INFO_ATTR(panic_on_ue,S_IRUGO|S_IWUSR,
-		edac_device_ctl_panic_on_ue_show,
-		edac_device_ctl_panic_on_ue_store);
-CTL_INFO_ATTR(poll_msec,S_IRUGO|S_IWUSR,
-		edac_device_ctl_poll_msec_show,
-		edac_device_ctl_poll_msec_store);
-
+CTL_INFO_ATTR(log_ue, S_IRUGO | S_IWUSR,
+	      edac_device_ctl_log_ue_show, edac_device_ctl_log_ue_store);
+CTL_INFO_ATTR(log_ce, S_IRUGO | S_IWUSR,
+	      edac_device_ctl_log_ce_show, edac_device_ctl_log_ce_store);
+CTL_INFO_ATTR(panic_on_ue, S_IRUGO | S_IWUSR,
+	      edac_device_ctl_panic_on_ue_show,
+	      edac_device_ctl_panic_on_ue_store);
+CTL_INFO_ATTR(poll_msec, S_IRUGO | S_IWUSR,
+	      edac_device_ctl_poll_msec_show, edac_device_ctl_poll_msec_store);
 
 /* Base Attributes of the EDAC_DEVICE ECC object */
 static struct ctl_info_attribute *device_ctrl_attr[] = {
@@ -303,10 +291,9 @@ static void edac_device_ctrl_master_rele
 static struct kobj_type ktype_device_ctrl = {
 	.release = edac_device_ctrl_master_release,
 	.sysfs_ops = &device_ctl_info_ops,
-	.default_attrs = (struct attribute **) device_ctrl_attr,
+	.default_attrs = (struct attribute **)device_ctrl_attr,
 };
 
-
 /**************** edac_device main kobj ctor/dtor code *********************/
 
 /*
@@ -317,41 +304,39 @@ static struct kobj_type ktype_device_ctr
  * Return:  0 SUCCESS
  *         !0 FAILURE
  */
-static int edac_device_register_main_kobj(
-		struct edac_device_ctl_info *edac_dev)
+static int edac_device_register_main_kobj(struct edac_device_ctl_info *edac_dev)
 {
 	int err = 0;
 	struct sysdev_class *edac_class;
 
 	debugf1("%s()\n", __func__);
 
-        /* get the /sys/devices/system/edac reference */
-        edac_class = edac_get_edac_class();
-        if (edac_class == NULL) {
-                debugf1("%s() no edac_class error=%d\n", __func__, err);
-                return err;
-        }
+	/* get the /sys/devices/system/edac reference */
+	edac_class = edac_get_edac_class();
+	if (edac_class == NULL) {
+		debugf1("%s() no edac_class error=%d\n", __func__, err);
+		return err;
+	}
 
 	/* Point to the 'edac_class' this instance 'reports' to */
 	edac_dev->edac_class = edac_class;
 
 	/* Init the devices's kobject */
-	memset(&edac_dev->kobj, 0, sizeof (struct kobject));
+	memset(&edac_dev->kobj, 0, sizeof(struct kobject));
 	edac_dev->kobj.ktype = &ktype_device_ctrl;
 
 	/* set this new device under the edac_class kobject */
 	edac_dev->kobj.parent = &edac_class->kset.kobj;
 
 	/* generate sysfs "..../edac/<name>"   */
-	debugf1("%s() set name of kobject to: %s\n",
-		__func__, edac_dev->name);
-	err = kobject_set_name(&edac_dev->kobj,"%s",edac_dev->name);
+	debugf1("%s() set name of kobject to: %s\n", __func__, edac_dev->name);
+	err = kobject_set_name(&edac_dev->kobj, "%s", edac_dev->name);
 	if (err)
 		return err;
 	err = kobject_register(&edac_dev->kobj);
 	if (err) {
 		debugf1("%s()Failed to register '.../edac/%s'\n",
-			__func__,edac_dev->name);
+			__func__, edac_dev->name);
 		return err;
 	}
 
@@ -365,8 +350,8 @@ static int edac_device_register_main_kob
  * edac_device_unregister_main_kobj:
  *	the '..../edac/<name>' kobject
  */
-static void edac_device_unregister_main_kobj(
-			struct edac_device_ctl_info *edac_dev)
+static void edac_device_unregister_main_kobj(struct edac_device_ctl_info
+					     *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 	debugf1("%s() name of kobject is: %s\n",
@@ -382,26 +367,23 @@ static void edac_device_unregister_main_
 	wait_for_completion(&edac_dev->kobj_complete);
 }
 
-
 /*************** edac_dev -> instance information ***********/
 
 /*
  * Set of low-level instance attribute show functions
  */
-static ssize_t instance_ue_count_show(
-		struct edac_device_instance *instance, char *data)
+static ssize_t instance_ue_count_show(struct edac_device_instance *instance,
+				      char *data)
 {
-        return sprintf(data,"%u\n", instance->counters.ue_count);
+	return sprintf(data, "%u\n", instance->counters.ue_count);
 }
 
-static ssize_t instance_ce_count_show(
-		struct edac_device_instance *instance, char *data)
+static ssize_t instance_ce_count_show(struct edac_device_instance *instance,
+				      char *data)
 {
-        return sprintf(data,"%u\n", instance->counters.ce_count);
+	return sprintf(data, "%u\n", instance->counters.ce_count);
 }
 
-
-
 #define to_instance(k) container_of(k, struct edac_device_instance, kobj)
 #define to_instance_attr(a) container_of(a,struct instance_attribute,attr)
 
@@ -416,48 +398,42 @@ static void edac_device_ctrl_instance_re
 	complete(&instance->kobj_complete);
 }
 
-
 /* instance specific attribute structure */
 struct instance_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct edac_device_instance *,char *);
-        ssize_t (*store)(struct edac_device_instance *,const char *,size_t);
+	struct attribute attr;
+	 ssize_t(*show) (struct edac_device_instance *, char *);
+	 ssize_t(*store) (struct edac_device_instance *, const char *, size_t);
 };
 
-
 /* Function to 'show' fields from the edac_dev 'instance' structure */
 static ssize_t edac_dev_instance_show(struct kobject *kobj,
-                        struct attribute *attr,
-                        char *buffer)
+				      struct attribute *attr, char *buffer)
 {
-        struct edac_device_instance *instance = to_instance(kobj);
-        struct instance_attribute *instance_attr = to_instance_attr(attr);
+	struct edac_device_instance *instance = to_instance(kobj);
+	struct instance_attribute *instance_attr = to_instance_attr(attr);
 
-        if (instance_attr->show)
-                return instance_attr->show(instance,buffer);
-        return -EIO;
+	if (instance_attr->show)
+		return instance_attr->show(instance, buffer);
+	return -EIO;
 }
 
-
 /* Function to 'store' fields into the edac_dev 'instance' structure */
 static ssize_t edac_dev_instance_store(struct kobject *kobj,
-                        struct attribute *attr,
-                	const char *buffer, size_t count)
+				       struct attribute *attr,
+				       const char *buffer, size_t count)
 {
-        struct edac_device_instance *instance = to_instance(kobj);
-        struct instance_attribute *instance_attr = to_instance_attr(attr);
+	struct edac_device_instance *instance = to_instance(kobj);
+	struct instance_attribute *instance_attr = to_instance_attr(attr);
 
-        if (instance_attr->store)
-                return instance_attr->store(instance, buffer, count);
-        return -EIO;
+	if (instance_attr->store)
+		return instance_attr->store(instance, buffer, count);
+	return -EIO;
 }
 
-
-
 /* edac_dev file operations for an 'instance' */
 static struct sysfs_ops device_instance_ops = {
-	.show   = edac_dev_instance_show,
-	.store  = edac_dev_instance_store
+	.show = edac_dev_instance_show,
+	.store = edac_dev_instance_store
 };
 
 #define INSTANCE_ATTR(_name,_mode,_show,_store)        \
@@ -472,8 +448,8 @@ static struct instance_attribute attr_in
  *	Each contains a pointer to a show and an optional set
  *	function pointer that does the low level output/input
  */
-INSTANCE_ATTR(ce_count,S_IRUGO,instance_ce_count_show,NULL);
-INSTANCE_ATTR(ue_count,S_IRUGO,instance_ue_count_show,NULL);
+INSTANCE_ATTR(ce_count, S_IRUGO, instance_ce_count_show, NULL);
+INSTANCE_ATTR(ue_count, S_IRUGO, instance_ue_count_show, NULL);
 
 /* list of edac_dev 'instance' attributes */
 static struct instance_attribute *device_instance_attr[] = {
@@ -486,29 +462,24 @@ static struct instance_attribute *device
 static struct kobj_type ktype_instance_ctrl = {
 	.release = edac_device_ctrl_instance_release,
 	.sysfs_ops = &device_instance_ops,
-	.default_attrs = (struct attribute **) device_instance_attr,
+	.default_attrs = (struct attribute **)device_instance_attr,
 };
 
-
 /*************** edac_dev -> instance -> block information *********/
 
 /*
  * Set of low-level block attribute show functions
  */
-static ssize_t block_ue_count_show(
-		struct edac_device_block *block, char *data)
+static ssize_t block_ue_count_show(struct edac_device_block *block, char *data)
 {
-        return sprintf(data,"%u\n", block->counters.ue_count);
+	return sprintf(data, "%u\n", block->counters.ue_count);
 }
 
-static ssize_t block_ce_count_show(
-		struct edac_device_block *block, char *data)
+static ssize_t block_ce_count_show(struct edac_device_block *block, char *data)
 {
-        return sprintf(data,"%u\n", block->counters.ce_count);
+	return sprintf(data, "%u\n", block->counters.ce_count);
 }
 
-
-
 #define to_block(k) container_of(k, struct edac_device_block, kobj)
 #define to_block_attr(a) container_of(a,struct block_attribute,attr)
 
@@ -525,46 +496,42 @@ static void edac_device_ctrl_block_relea
 
 /* block specific attribute structure */
 struct block_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct edac_device_block *,char *);
-        ssize_t (*store)(struct edac_device_block *,const char *,size_t);
+	struct attribute attr;
+	 ssize_t(*show) (struct edac_device_block *, char *);
+	 ssize_t(*store) (struct edac_device_block *, const char *, size_t);
 };
 
 /* Function to 'show' fields from the edac_dev 'block' structure */
 static ssize_t edac_dev_block_show(struct kobject *kobj,
-                        struct attribute *attr,
-                        char *buffer)
+				   struct attribute *attr, char *buffer)
 {
-        struct edac_device_block *block = to_block(kobj);
-        struct block_attribute *block_attr = to_block_attr(attr);
+	struct edac_device_block *block = to_block(kobj);
+	struct block_attribute *block_attr = to_block_attr(attr);
 
-        if (block_attr->show)
-                return block_attr->show(block,buffer);
-        return -EIO;
+	if (block_attr->show)
+		return block_attr->show(block, buffer);
+	return -EIO;
 }
 
-
 /* Function to 'store' fields into the edac_dev 'block' structure */
 static ssize_t edac_dev_block_store(struct kobject *kobj,
-                        struct attribute *attr,
-                	const char *buffer, size_t count)
+				    struct attribute *attr,
+				    const char *buffer, size_t count)
 {
-        struct edac_device_block *block = to_block(kobj);
-        struct block_attribute *block_attr = to_block_attr(attr);
+	struct edac_device_block *block = to_block(kobj);
+	struct block_attribute *block_attr = to_block_attr(attr);
 
-        if (block_attr->store)
-                return block_attr->store(block, buffer, count);
-        return -EIO;
+	if (block_attr->store)
+		return block_attr->store(block, buffer, count);
+	return -EIO;
 }
 
-
 /* edac_dev file operations for a 'block' */
 static struct sysfs_ops device_block_ops = {
-	.show   = edac_dev_block_show,
-	.store  = edac_dev_block_store
+	.show = edac_dev_block_show,
+	.store = edac_dev_block_store
 };
 
-
 #define BLOCK_ATTR(_name,_mode,_show,_store)        \
 static struct block_attribute attr_block_##_name = {                       \
         .attr = {.name = __stringify(_name), .mode = _mode },   \
@@ -572,9 +539,8 @@ static struct block_attribute attr_block
         .store  = _store,                                       \
 };
 
-BLOCK_ATTR(ce_count,S_IRUGO,block_ce_count_show,NULL);
-BLOCK_ATTR(ue_count,S_IRUGO,block_ue_count_show,NULL);
-
+BLOCK_ATTR(ce_count, S_IRUGO, block_ce_count_show, NULL);
+BLOCK_ATTR(ue_count, S_IRUGO, block_ue_count_show, NULL);
 
 /* list of edac_dev 'block' attributes */
 static struct block_attribute *device_block_attr[] = {
@@ -587,19 +553,17 @@ static struct block_attribute *device_bl
 static struct kobj_type ktype_block_ctrl = {
 	.release = edac_device_ctrl_block_release,
 	.sysfs_ops = &device_block_ops,
-	.default_attrs = (struct attribute **) device_block_attr,
+	.default_attrs = (struct attribute **)device_block_attr,
 };
 
-
 /************** block ctor/dtor  code ************/
 
 /*
  * edac_device_create_block
  */
-static int edac_device_create_block(
-		struct edac_device_ctl_info *edac_dev,
-		struct edac_device_instance *instance,
-		int idx)
+static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
+				    struct edac_device_instance *instance,
+				    int idx)
 {
 	int err;
 	struct edac_device_block *block;
@@ -607,21 +571,21 @@ static int edac_device_create_block(
 	block = &instance->blocks[idx];
 
 	debugf1("%s() Instance '%s' block[%d] '%s'\n",
-		__func__,instance->name, idx, block->name);
+		__func__, instance->name, idx, block->name);
 
 	/* init this block's kobject */
-	memset(&block->kobj, 0, sizeof (struct kobject));
+	memset(&block->kobj, 0, sizeof(struct kobject));
 	block->kobj.parent = &instance->kobj;
 	block->kobj.ktype = &ktype_block_ctrl;
 
-	err = kobject_set_name(&block->kobj,"%s",block->name);
+	err = kobject_set_name(&block->kobj, "%s", block->name);
 	if (err)
 		return err;
 
 	err = kobject_register(&block->kobj);
 	if (err) {
 		debugf1("%s()Failed to register instance '%s'\n",
-			__func__,block->name);
+			__func__, block->name);
 		return err;
 	}
 
@@ -631,10 +595,9 @@ static int edac_device_create_block(
 /*
  * edac_device_delete_block(edac_dev,j);
  */
-static void edac_device_delete_block(
-		struct edac_device_ctl_info *edac_dev,
-		struct edac_device_instance *instance,
-		int idx)
+static void edac_device_delete_block(struct edac_device_ctl_info *edac_dev,
+				     struct edac_device_instance *instance,
+				     int idx)
 {
 	struct edac_device_block *block;
 
@@ -652,8 +615,8 @@ static void edac_device_delete_block(
  * edac_device_create_instance
  *	create just one instance of an edac_device 'instance'
  */
-static int edac_device_create_instance(
-		struct edac_device_ctl_info *edac_dev, int idx)
+static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
+				       int idx)
 {
 	int i, j;
 	int err;
@@ -662,32 +625,32 @@ static int edac_device_create_instance(
 	instance = &edac_dev->instances[idx];
 
 	/* Init the instance's kobject */
-	memset(&instance->kobj, 0, sizeof (struct kobject));
+	memset(&instance->kobj, 0, sizeof(struct kobject));
 
 	/* set this new device under the edac_device main kobject */
 	instance->kobj.parent = &edac_dev->kobj;
 	instance->kobj.ktype = &ktype_instance_ctrl;
 
-	err = kobject_set_name(&instance->kobj,"%s",instance->name);
+	err = kobject_set_name(&instance->kobj, "%s", instance->name);
 	if (err)
 		return err;
 
 	err = kobject_register(&instance->kobj);
 	if (err != 0) {
 		debugf2("%s() Failed to register instance '%s'\n",
-			__func__,instance->name);
+			__func__, instance->name);
 		return err;
 	}
 
 	debugf1("%s() now register '%d' blocks for instance %d\n",
-			__func__,instance->nr_blocks,idx);
+		__func__, instance->nr_blocks, idx);
 
 	/* register all blocks of this instance */
-	for (i = 0; i < instance->nr_blocks; i++ ) {
-		err = edac_device_create_block(edac_dev,instance,i);
+	for (i = 0; i < instance->nr_blocks; i++) {
+		err = edac_device_create_block(edac_dev, instance, i);
 		if (err) {
 			for (j = 0; j < i; j++) {
-				edac_device_delete_block(edac_dev,instance,j);
+				edac_device_delete_block(edac_dev, instance, j);
 			}
 			return err;
 		}
@@ -703,8 +666,8 @@ static int edac_device_create_instance(
  * edac_device_remove_instance
  *	remove an edac_device instance
  */
-static void edac_device_delete_instance(
-		struct edac_device_ctl_info *edac_dev, int idx)
+static void edac_device_delete_instance(struct edac_device_ctl_info *edac_dev,
+					int idx)
 {
 	int i;
 	struct edac_device_instance *instance;
@@ -713,7 +676,7 @@ static void edac_device_delete_instance(
 
 	/* unregister all blocks in this instance */
 	for (i = 0; i < instance->nr_blocks; i++) {
-		edac_device_delete_block(edac_dev,instance,i);
+		edac_device_delete_block(edac_dev, instance, i);
 	}
 
 	/* unregister this instance's kobject */
@@ -735,12 +698,12 @@ static int edac_device_create_instances(
 	debugf0("%s()\n", __func__);
 
 	/* iterate over creation of the instances */
-	for (i = 0; i < edac_dev->nr_instances; i++ ) {
-		err = edac_device_create_instance(edac_dev,i);
+	for (i = 0; i < edac_dev->nr_instances; i++) {
+		err = edac_device_create_instance(edac_dev, i);
 		if (err) {
 			/* unwind previous instances on error */
 			for (j = 0; j < i; j++) {
-				edac_device_delete_instance(edac_dev,j);
+				edac_device_delete_instance(edac_dev, j);
 			}
 			return err;
 		}
@@ -758,8 +721,8 @@ static void edac_device_delete_instances
 	int i;
 
 	/* iterate over creation of the instances */
-	for (i = 0; i < edac_dev->nr_instances; i++ ) {
-		edac_device_delete_instance(edac_dev,i);
+	for (i = 0; i < edac_dev->nr_instances; i++) {
+		edac_device_delete_instance(edac_dev, i);
 	}
 }
 
@@ -777,7 +740,7 @@ static void edac_device_delete_instances
 int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 {
 	int err;
-	struct kobject *edac_kobj=&edac_dev->kobj;
+	struct kobject *edac_kobj = &edac_dev->kobj;
 
 	/* register this instance's main kobj with the edac class kobj */
 	err = edac_device_register_main_kobj(edac_dev);
@@ -790,8 +753,7 @@ int edac_device_create_sysfs(struct edac
 	 * to the platform 'device' being used for this
 	 */
 	err = sysfs_create_link(edac_kobj,
-				&edac_dev->dev->kobj,
-				EDAC_DEVICE_SYMLINK);
+				&edac_dev->dev->kobj, EDAC_DEVICE_SYMLINK);
 	if (err) {
 		debugf0("%s() sysfs_create_link() returned err= %d\n",
 			__func__, err);
@@ -811,7 +773,7 @@ int edac_device_create_sysfs(struct edac
 
 	/* Error unwind stack */
 
-error0:
+      error0:
 	edac_device_unregister_main_kobj(edac_dev);
 
 	return err;
@@ -834,4 +796,3 @@ void edac_device_remove_sysfs(struct eda
 	/* unregister the instance's main kobj */
 	edac_device_unregister_main_kobj(edac_dev);
 }
-
diff -puN drivers/edac/edac_mc.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_mc.c
@@ -34,7 +34,6 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
 static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
@@ -54,13 +53,11 @@ static void edac_mc_dump_csrow(struct cs
 {
 	debugf4("\tcsrow = %p\n", csrow);
 	debugf4("\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
-	debugf4("\tcsrow->first_page = 0x%lx\n",
-		csrow->first_page);
+	debugf4("\tcsrow->first_page = 0x%lx\n", csrow->first_page);
 	debugf4("\tcsrow->last_page = 0x%lx\n", csrow->last_page);
 	debugf4("\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
 	debugf4("\tcsrow->nr_pages = 0x%x\n", csrow->nr_pages);
-	debugf4("\tcsrow->nr_channels = %d\n",
-		csrow->nr_channels);
+	debugf4("\tcsrow->nr_channels = %d\n", csrow->nr_channels);
 	debugf4("\tcsrow->channels = %p\n", csrow->channels);
 	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
 }
@@ -75,12 +72,11 @@ static void edac_mc_dump_mci(struct mem_
 	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
 		mci->nr_csrows, mci->csrows);
 	debugf3("\tdev = %p\n", mci->dev);
-	debugf3("\tmod_name:ctl_name = %s:%s\n",
-		mci->mod_name, mci->ctl_name);
+	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
 
-#endif  /* CONFIG_EDAC_DEBUG */
+#endif				/* CONFIG_EDAC_DEBUG */
 
 /* 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
  * Adjust 'ptr' so that its alignment is at least as stringent as what the
@@ -89,7 +85,7 @@ static void edac_mc_dump_mci(struct mem_
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-char * edac_align_ptr(void *ptr, unsigned size)
+char *edac_align_ptr(void *ptr, unsigned size)
 {
 	unsigned align, r;
 
@@ -106,14 +102,14 @@ char * edac_align_ptr(void *ptr, unsigne
 	else if (size > sizeof(char))
 		align = sizeof(short);
 	else
-		return (char *) ptr;
+		return (char *)ptr;
 
 	r = size % align;
 
 	if (r == 0)
-		return (char *) ptr;
+		return (char *)ptr;
 
-	return (char *) (((unsigned long) ptr) + align - r);
+	return (char *)(((unsigned long)ptr) + align - r);
 }
 
 /**
@@ -133,7 +129,7 @@ char * edac_align_ptr(void *ptr, unsigne
  *	struct mem_ctl_info pointer
  */
 struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-		unsigned nr_chans)
+				   unsigned nr_chans)
 {
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
@@ -147,12 +143,12 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	 * stringent as what the compiler would provide if we could simply
 	 * hardcode everything into a single struct.
 	 */
-	mci = (struct mem_ctl_info *) 0;
+	mci = (struct mem_ctl_info *)0;
 	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
 	chi = (struct channel_info *)
-			edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+	    edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
-	size = ((unsigned long) pvt) + sz_pvt;
+	size = ((unsigned long)pvt) + sz_pvt;
 
 	if ((mci = kmalloc(size, GFP_KERNEL)) == NULL)
 		return NULL;
@@ -160,11 +156,11 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	/* Adjust pointers so they point within the memory we just allocated
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
-	csi = (struct csrow_info *) (((char *) mci) + ((unsigned long) csi));
-	chi = (struct channel_info *) (((char *) mci) + ((unsigned long) chi));
-	pvt = sz_pvt ? (((char *) mci) + ((unsigned long) pvt)) : NULL;
+	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
+	chi = (struct channel_info *)(((char *)mci) + ((unsigned long)chi));
+	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
-	memset(mci, 0, size);  /* clear all fields */
+	memset(mci, 0, size);	/* clear all fields */
 	mci->csrows = csi;
 	mci->pvt_info = pvt;
 	mci->nr_csrows = nr_csrows;
@@ -188,6 +184,7 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 
 	return mci;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
 
 /**
@@ -198,6 +195,7 @@ void edac_mc_free(struct mem_ctl_info *m
 {
 	kfree(mci);
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
 static struct mem_ctl_info *find_mci_by_dev(struct device *dev)
@@ -224,7 +222,7 @@ static int edac_mc_assert_error_check_an
 {
 	int old_state;
 
-	if(edac_op_state == EDAC_OPSTATE_POLL)
+	if (edac_op_state == EDAC_OPSTATE_POLL)
 		return 1;
 
 	old_state = edac_err_assert;
@@ -240,12 +238,12 @@ static int edac_mc_assert_error_check_an
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work*) work_req;
+	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
 #else
 static void edac_mc_workq_function(void *ptr)
 {
-	struct mem_ctl_info *mci = (struct mem_ctl_info *) ptr;
+	struct mem_ctl_info *mci = (struct mem_ctl_info *)ptr;
 #endif
 
 	mutex_lock(&mem_ctls_mutex);
@@ -264,7 +262,7 @@ static void edac_mc_workq_function(void 
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &mci->work,
-			msecs_to_jiffies(edac_mc_get_poll_msec()));
+			   msecs_to_jiffies(edac_mc_get_poll_msec()));
 }
 
 /*
@@ -320,7 +318,7 @@ void edac_reset_delay_period(struct mem_
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.
  */
-static int add_mc_to_global_list (struct mem_ctl_info *mci)
+static int add_mc_to_global_list(struct mem_ctl_info *mci)
 {
 	struct list_head *item, *insert_before;
 	struct mem_ctl_info *p;
@@ -346,13 +344,13 @@ static int add_mc_to_global_list (struct
 	atomic_inc(&edac_handlers);
 	return 0;
 
-fail0:
+      fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 		    "%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
 		    dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
-fail1:
+      fail1:
 	edac_printk(KERN_WARNING, EDAC_MC,
 		    "bug in low-level driver: attempt to assign\n"
 		    "    duplicate mc_idx %d in %s()\n", p->mc_idx, __func__);
@@ -385,7 +383,7 @@ static void del_mc_from_global_list(stru
  *
  * Caller must hold mem_ctls_mutex.
  */
-struct mem_ctl_info * edac_mc_find(int idx)
+struct mem_ctl_info *edac_mc_find(int idx)
 {
 	struct list_head *item;
 	struct mem_ctl_info *mci;
@@ -403,6 +401,7 @@ struct mem_ctl_info * edac_mc_find(int i
 
 	return NULL;
 }
+
 EXPORT_SYMBOL(edac_mc_find);
 
 /**
@@ -433,8 +432,8 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 			edac_mc_dump_csrow(&mci->csrows[i]);
 			for (j = 0; j < mci->csrows[i].nr_channels; j++)
-				edac_mc_dump_channel(
-					&mci->csrows[i].channels[j]);
+				edac_mc_dump_channel(&mci->csrows[i].
+						     channels[j]);
 		}
 	}
 #endif
@@ -448,7 +447,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 	if (edac_create_sysfs_mci_device(mci)) {
 		edac_mc_printk(mci, KERN_WARNING,
-			"failed to create sysfs device\n");
+			       "failed to create sysfs device\n");
 		goto fail1;
 	}
 
@@ -464,18 +463,19 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
-		mci->mod_name, mci->ctl_name, dev_name(mci));
+		       mci->mod_name, mci->ctl_name, dev_name(mci));
 
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
-fail1:
+      fail1:
 	del_mc_from_global_list(mci);
 
-fail0:
+      fail0:
 	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
 
 /**
@@ -485,7 +485,7 @@ EXPORT_SYMBOL_GPL(edac_mc_add_mc);
  *
  * Return pointer to removed mci structure, or NULL if device not found.
  */
-struct mem_ctl_info * edac_mc_del_mc(struct device *dev)
+struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 {
 	struct mem_ctl_info *mci;
 
@@ -507,10 +507,11 @@ struct mem_ctl_info * edac_mc_del_mc(str
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
-		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
-		mci->mod_name, mci->ctl_name, dev_name(mci));
+		    "Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
+		    mci->mod_name, mci->ctl_name, dev_name(mci));
 	return mci;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
 
 static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
@@ -523,7 +524,7 @@ static void edac_mc_scrub_block(unsigned
 	debugf3("%s()\n", __func__);
 
 	/* ECC error page was not in our memory. Ignore it. */
-	if(!pfn_valid(page))
+	if (!pfn_valid(page))
 		return;
 
 	/* Find the actual page structure then map it and fix */
@@ -575,18 +576,20 @@ int edac_mc_find_csrow_by_page(struct me
 
 	if (row == -1)
 		edac_mc_printk(mci, KERN_ERR,
-			"could not look up page error address %lx\n",
-			(unsigned long) page);
+			       "could not look up page error address %lx\n",
+			       (unsigned long)page);
 
 	return row;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
 /* FIXME - setable log (warning/emerg) levels */
 /* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
 void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		unsigned long syndrome, int row, int channel, const char *msg)
+		       unsigned long page_frame_number,
+		       unsigned long offset_in_page, unsigned long syndrome,
+		       int row, int channel, const char *msg)
 {
 	unsigned long remapped_page;
 
@@ -596,8 +599,8 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
+			       "INTERNAL ERROR: row out of range "
+			       "(%d >= %d)\n", row, mci->nr_csrows);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -605,9 +608,9 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range "
-			"(%d >= %d)\n", channel,
-			mci->csrows[row].nr_channels);
+			       "INTERNAL ERROR: channel out of range "
+			       "(%d >= %d)\n", channel,
+			       mci->csrows[row].nr_channels);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -615,11 +618,11 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
-			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
-			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
-			page_frame_number, offset_in_page,
-			mci->csrows[row].grain, syndrome, row, channel,
-			mci->csrows[row].channels[channel].label, msg);
+			       "CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
+			       "0x%lx, row %d, channel %d, label \"%s\": %s\n",
+			       page_frame_number, offset_in_page,
+			       mci->csrows[row].grain, syndrome, row, channel,
+			       mci->csrows[row].channels[channel].label, msg);
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
@@ -640,25 +643,27 @@ void edac_mc_handle_ce(struct mem_ctl_in
 		    page_frame_number;
 
 		edac_mc_scrub_block(remapped_page, offset_in_page,
-					mci->csrows[row].grain);
+				    mci->csrows[row].grain);
 	}
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
 {
 	if (edac_mc_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
-			"CE - no information available: %s\n", msg);
+			       "CE - no information available: %s\n", msg);
 
 	mci->ce_noinfo_count++;
 	mci->ce_count++;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
 
 void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		int row, const char *msg)
+		       unsigned long page_frame_number,
+		       unsigned long offset_in_page, int row, const char *msg)
 {
 	int len = EDAC_MC_LABEL_LEN * 4;
 	char labels[len + 1];
@@ -672,41 +677,42 @@ void edac_mc_handle_ue(struct mem_ctl_in
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
+			       "INTERNAL ERROR: row out of range "
+			       "(%d >= %d)\n", row, mci->nr_csrows);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
 
 	chars = snprintf(pos, len + 1, "%s",
-			mci->csrows[row].channels[0].label);
+			 mci->csrows[row].channels[0].label);
 	len -= chars;
 	pos += chars;
 
 	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
 	     chan++) {
 		chars = snprintf(pos, len + 1, ":%s",
-				mci->csrows[row].channels[chan].label);
+				 mci->csrows[row].channels[chan].label);
 		len -= chars;
 		pos += chars;
 	}
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
-			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
-			"labels \"%s\": %s\n", page_frame_number,
-			offset_in_page, mci->csrows[row].grain, row, labels,
-			msg);
+			       "UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
+			       "labels \"%s\": %s\n", page_frame_number,
+			       offset_in_page, mci->csrows[row].grain, row,
+			       labels, msg);
 
 	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
-			"row %d, labels \"%s\": %s\n", mci->mc_idx,
-			page_frame_number, offset_in_page,
-			mci->csrows[row].grain, row, labels, msg);
+		      "row %d, labels \"%s\": %s\n", mci->mc_idx,
+		      page_frame_number, offset_in_page,
+		      mci->csrows[row].grain, row, labels, msg);
 
 	mci->ue_count++;
 	mci->csrows[row].ue_count++;
 }
+
 EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
@@ -716,22 +722,21 @@ void edac_mc_handle_ue_no_info(struct me
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_WARNING,
-			"UE - no information available: %s\n", msg);
+			       "UE - no information available: %s\n", msg);
 	mci->ue_noinfo_count++;
 	mci->ue_count++;
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
 
+EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
 
 /*************************************************************
  * On Fully Buffered DIMM modules, this help function is
  * called to process UE events
  */
 void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-				unsigned int csrow,
-				unsigned int channela,
-				unsigned int channelb,
-				char *msg)
+			   unsigned int csrow,
+			   unsigned int channela,
+			   unsigned int channelb, char *msg)
 {
 	int len = EDAC_MC_LABEL_LEN * 4;
 	char labels[len + 1];
@@ -741,8 +746,8 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
+			       "INTERNAL ERROR: row out of range (%d >= %d)\n",
+			       csrow, mci->nr_csrows);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -750,9 +755,9 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (channela >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-a out of range "
-			"(%d >= %d)\n",
-			channela, mci->csrows[csrow].nr_channels);
+			       "INTERNAL ERROR: channel-a out of range "
+			       "(%d >= %d)\n",
+			       channela, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -760,9 +765,9 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (channelb >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-b out of range "
-			"(%d >= %d)\n",
-			channelb, mci->csrows[csrow].nr_channels);
+			       "INTERNAL ERROR: channel-b out of range "
+			       "(%d >= %d)\n",
+			       channelb, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -773,21 +778,23 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	/* Generate the DIMM labels from the specified channels */
 	chars = snprintf(pos, len + 1, "%s",
 			 mci->csrows[csrow].channels[channela].label);
-	len -= chars; pos += chars;
+	len -= chars;
+	pos += chars;
 	chars = snprintf(pos, len + 1, "-%s",
 			 mci->csrows[csrow].channels[channelb].label);
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
-			"UE row %d, channel-a= %d channel-b= %d "
-			"labels \"%s\": %s\n", csrow, channela, channelb,
-			labels, msg);
+			       "UE row %d, channel-a= %d channel-b= %d "
+			       "labels \"%s\": %s\n", csrow, channela, channelb,
+			       labels, msg);
 
 	if (edac_mc_get_panic_on_ue())
 		panic("UE row %d, channel-a= %d channel-b= %d "
-				"labels \"%s\": %s\n", csrow, channela,
-				channelb, labels, msg);
+		      "labels \"%s\": %s\n", csrow, channela,
+		      channelb, labels, msg);
 }
+
 EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
 
 /*************************************************************
@@ -795,25 +802,23 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
  * called to process CE events
  */
 void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-			   unsigned int csrow,
-			   unsigned int channel,
-			   char *msg)
+			   unsigned int csrow, unsigned int channel, char *msg)
 {
 
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
+			       "INTERNAL ERROR: row out of range (%d >= %d)\n",
+			       csrow, mci->nr_csrows);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
 	if (channel >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
-			channel, mci->csrows[csrow].nr_channels);
+			       "INTERNAL ERROR: channel out of range (%d >= %d)\n",
+			       channel, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -821,17 +826,16 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
-			"CE row %d, channel %d, label \"%s\": %s\n",
-			csrow, channel,
-			mci->csrows[csrow].channels[channel].label,
-			msg);
+			       "CE row %d, channel %d, label \"%s\": %s\n",
+			       csrow, channel,
+			       mci->csrows[csrow].channels[channel].label, msg);
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
 	mci->csrows[csrow].channels[channel].ce_count++;
 }
-EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
 
+EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
 
 /*
  * Iterate over all MC instances and check for ECC, et al, errors
diff -puN drivers/edac/edac_mc.h~drivers-edac-core-lindent-cleanup drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_mc.h
@@ -1,9 +1,7 @@
 
-
 /*
  * Older .h file for edac, until all drivers are modified
  *
  */
 
 #include "edac_core.h"
-
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -48,14 +48,13 @@ module_param(edac_mc_panic_on_ue, int, 0
 MODULE_PARM_DESC(edac_mc_panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
 module_param(edac_mc_log_ue, int, 0644);
 MODULE_PARM_DESC(edac_mc_log_ue,
-		"Log uncorrectable error to console: 0=off 1=on");
+		 "Log uncorrectable error to console: 0=off 1=on");
 module_param(edac_mc_log_ce, int, 0644);
 MODULE_PARM_DESC(edac_mc_log_ce,
-		"Log correctable error to console: 0=off 1=on");
+		 "Log correctable error to console: 0=off 1=on");
 module_param(edac_mc_poll_msec, int, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
-
 /*
  * various constants for Memory Controllers
  */
@@ -116,13 +115,13 @@ static struct completion edac_memctrl_ko
  */
 static ssize_t memctrl_int_show(void *ptr, char *buffer)
 {
-	int *value = (int*) ptr;
+	int *value = (int *)ptr;
 	return sprintf(buffer, "%u\n", *value);
 }
 
 static ssize_t memctrl_int_store(void *ptr, const char *buffer, size_t count)
 {
-	int *value = (int*) ptr;
+	int *value = (int *)ptr;
 
 	if (isdigit(*buffer))
 		*value = simple_strtoul(buffer, NULL, 0);
@@ -133,16 +132,16 @@ static ssize_t memctrl_int_store(void *p
 struct memctrl_dev_attribute {
 	struct attribute attr;
 	void *value;
-	ssize_t (*show)(void *,char *);
-	ssize_t (*store)(void *, const char *, size_t);
+	 ssize_t(*show) (void *, char *);
+	 ssize_t(*store) (void *, const char *, size_t);
 };
 
 /* Set of show/store abstract level functions for memory control object */
 static ssize_t memctrl_dev_show(struct kobject *kobj,
-		struct attribute *attr, char *buffer)
+				struct attribute *attr, char *buffer)
 {
 	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute*)attr;
+	memctrl_dev = (struct memctrl_dev_attribute *)attr;
 
 	if (memctrl_dev->show)
 		return memctrl_dev->show(memctrl_dev->value, buffer);
@@ -151,10 +150,10 @@ static ssize_t memctrl_dev_show(struct k
 }
 
 static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
+				 const char *buffer, size_t count)
 {
 	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute*)attr;
+	memctrl_dev = (struct memctrl_dev_attribute *)attr;
 
 	if (memctrl_dev->store)
 		return memctrl_dev->store(memctrl_dev->value, buffer, count);
@@ -163,8 +162,8 @@ static ssize_t memctrl_dev_store(struct 
 }
 
 static struct sysfs_ops memctrlfs_ops = {
-	.show   = memctrl_dev_show,
-	.store  = memctrl_dev_store
+	.show = memctrl_dev_show,
+	.store = memctrl_dev_store
 };
 
 #define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
@@ -185,24 +184,16 @@ static struct memctrl_dev_attribute attr
 
 /* csrow<id> control files */
 MEMCTRL_ATTR(edac_mc_panic_on_ue,
-		S_IRUGO | S_IWUSR,
-		memctrl_int_show,
-		memctrl_int_store);
+	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_log_ue,
-		S_IRUGO|S_IWUSR,
-		memctrl_int_show,
-		memctrl_int_store);
+	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_log_ce,
-		S_IRUGO|S_IWUSR,
-		memctrl_int_show,
-		memctrl_int_store);
+	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_poll_msec,
-		S_IRUGO|S_IWUSR,
-		memctrl_int_show,
-		memctrl_int_store);
+	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 /* Base Attributes of the memory ECC object */
 static struct memctrl_dev_attribute *memctrl_attr[] = {
@@ -223,7 +214,7 @@ static void edac_memctrl_master_release(
 static struct kobj_type ktype_memctrl = {
 	.release = edac_memctrl_master_release,
 	.sysfs_ops = &memctrlfs_ops,
-	.default_attrs = (struct attribute **) memctrl_attr,
+	.default_attrs = (struct attribute **)memctrl_attr,
 };
 
 /* Initialize the main sysfs entries for edac:
@@ -249,25 +240,25 @@ int edac_sysfs_memctrl_setup(void)
 	}
 
 	/* Init the MC's kobject */
-	memset(&edac_memctrl_kobj, 0, sizeof (edac_memctrl_kobj));
+	memset(&edac_memctrl_kobj, 0, sizeof(edac_memctrl_kobj));
 	edac_memctrl_kobj.parent = &edac_class->kset.kobj;
 	edac_memctrl_kobj.ktype = &ktype_memctrl;
 
 	/* generate sysfs "..../edac/mc"   */
-	err = kobject_set_name(&edac_memctrl_kobj,"mc");
+	err = kobject_set_name(&edac_memctrl_kobj, "mc");
 	if (err) {
-		debugf1("%s() Failed to set name '.../edac/mc'\n", __func__ );
+		debugf1("%s() Failed to set name '.../edac/mc'\n", __func__);
 		return err;
 	}
 
 	/* FIXME: maybe new sysdev_create_subdir() */
 	err = kobject_register(&edac_memctrl_kobj);
 	if (err) {
-		debugf1("%s() Failed to register '.../edac/mc'\n", __func__ );
+		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
 		return err;
 	}
 
-	debugf1("%s() Registered '.../edac/mc' kobject\n",__func__);
+	debugf1("%s() Registered '.../edac/mc' kobject\n", __func__);
 	return 0;
 }
 
@@ -286,63 +277,61 @@ void edac_sysfs_memctrl_teardown(void)
 	wait_for_completion(&edac_memctrl_kobj_complete);
 }
 
-
 /* EDAC sysfs CSROW data structures and methods
  */
 
 /* Set of more default csrow<id> attribute show/store functions */
 static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
-			int private)
+				   int private)
 {
-	return sprintf(data,"%u\n", csrow->ue_count);
+	return sprintf(data, "%u\n", csrow->ue_count);
 }
 
 static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
-			int private)
+				   int private)
 {
-	return sprintf(data,"%u\n", csrow->ce_count);
+	return sprintf(data, "%u\n", csrow->ce_count);
 }
 
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
-			int private)
+			       int private)
 {
-	return sprintf(data,"%u\n", PAGES_TO_MiB(csrow->nr_pages));
+	return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
 }
 
 static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
-			int private)
+				   int private)
 {
-	return sprintf(data,"%s\n", mem_types[csrow->mtype]);
+	return sprintf(data, "%s\n", mem_types[csrow->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
-			int private)
+				   int private)
 {
-	return sprintf(data,"%s\n", dev_types[csrow->dtype]);
+	return sprintf(data, "%s\n", dev_types[csrow->dtype]);
 }
 
 static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
-			int private)
+				    int private)
 {
-	return sprintf(data,"%s\n", edac_caps[csrow->edac_mode]);
+	return sprintf(data, "%s\n", edac_caps[csrow->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
 static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
-		char *data, int channel)
+				       char *data, int channel)
 {
-	return snprintf(data, EDAC_MC_LABEL_LEN,"%s",
+	return snprintf(data, EDAC_MC_LABEL_LEN, "%s",
 			csrow->channels[channel].label);
 }
 
 static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
-				const char *data,
-				size_t count,
-				int channel)
+					const char *data,
+					size_t count, int channel)
 {
 	ssize_t max_size = 0;
 
-	max_size = min((ssize_t)count,(ssize_t)EDAC_MC_LABEL_LEN-1);
+	max_size = min((ssize_t) count, (ssize_t) EDAC_MC_LABEL_LEN - 1);
 	strncpy(csrow->channels[channel].label, data, max_size);
 	csrow->channels[channel].label[max_size] = '\0';
 
@@ -351,8 +340,7 @@ static ssize_t channel_dimm_label_store(
 
 /* show function for dynamic chX_ce_count attribute */
 static ssize_t channel_ce_count_show(struct csrow_info *csrow,
-				char *data,
-				int channel)
+				     char *data, int channel)
 {
 	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
 }
@@ -360,9 +348,9 @@ static ssize_t channel_ce_count_show(str
 /* csrow specific attribute structure */
 struct csrowdev_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct csrow_info *,char *,int);
-	ssize_t (*store)(struct csrow_info *, const char *,size_t,int);
-	int    private;
+	 ssize_t(*show) (struct csrow_info *, char *, int);
+	 ssize_t(*store) (struct csrow_info *, const char *, size_t, int);
+	int private;
 };
 
 #define to_csrow(k) container_of(k, struct csrow_info, kobj)
@@ -370,36 +358,33 @@ struct csrowdev_attribute {
 
 /* Set of show/store higher level functions for default csrow attributes */
 static ssize_t csrowdev_show(struct kobject *kobj,
-			struct attribute *attr,
-			char *buffer)
+			     struct attribute *attr, char *buffer)
 {
 	struct csrow_info *csrow = to_csrow(kobj);
 	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
 
 	if (csrowdev_attr->show)
 		return csrowdev_attr->show(csrow,
-					buffer,
-					csrowdev_attr->private);
+					   buffer, csrowdev_attr->private);
 	return -EIO;
 }
 
 static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
+			      const char *buffer, size_t count)
 {
 	struct csrow_info *csrow = to_csrow(kobj);
-	struct csrowdev_attribute * csrowdev_attr = to_csrowdev_attr(attr);
+	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
 
 	if (csrowdev_attr->store)
 		return csrowdev_attr->store(csrow,
-					buffer,
-					count,
-					csrowdev_attr->private);
+					    buffer,
+					    count, csrowdev_attr->private);
 	return -EIO;
 }
 
 static struct sysfs_ops csrowfs_ops = {
-	.show   = csrowdev_show,
-	.store  = csrowdev_store
+	.show = csrowdev_show,
+	.store = csrowdev_store
 };
 
 #define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
@@ -411,12 +396,12 @@ static struct csrowdev_attribute attr_##
 };
 
 /* default cwrow<id>/attribute files */
-CSROWDEV_ATTR(size_mb,S_IRUGO,csrow_size_show,NULL,0);
-CSROWDEV_ATTR(dev_type,S_IRUGO,csrow_dev_type_show,NULL,0);
-CSROWDEV_ATTR(mem_type,S_IRUGO,csrow_mem_type_show,NULL,0);
-CSROWDEV_ATTR(edac_mode,S_IRUGO,csrow_edac_mode_show,NULL,0);
-CSROWDEV_ATTR(ue_count,S_IRUGO,csrow_ue_count_show,NULL,0);
-CSROWDEV_ATTR(ce_count,S_IRUGO,csrow_ce_count_show,NULL,0);
+CSROWDEV_ATTR(size_mb, S_IRUGO, csrow_size_show, NULL, 0);
+CSROWDEV_ATTR(dev_type, S_IRUGO, csrow_dev_type_show, NULL, 0);
+CSROWDEV_ATTR(mem_type, S_IRUGO, csrow_mem_type_show, NULL, 0);
+CSROWDEV_ATTR(edac_mode, S_IRUGO, csrow_edac_mode_show, NULL, 0);
+CSROWDEV_ATTR(ue_count, S_IRUGO, csrow_ue_count_show, NULL, 0);
+CSROWDEV_ATTR(ce_count, S_IRUGO, csrow_ce_count_show, NULL, 0);
 
 /* default attributes of the CSROW<id> object */
 static struct csrowdev_attribute *default_csrow_attr[] = {
@@ -429,98 +414,68 @@ static struct csrowdev_attribute *defaul
 	NULL,
 };
 
-
 /* possible dynamic channel DIMM Label attribute files */
-CSROWDEV_ATTR(ch0_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		0 );
-CSROWDEV_ATTR(ch1_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		1 );
-CSROWDEV_ATTR(ch2_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		2 );
-CSROWDEV_ATTR(ch3_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		3 );
-CSROWDEV_ATTR(ch4_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		4 );
-CSROWDEV_ATTR(ch5_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		5 );
+CSROWDEV_ATTR(ch0_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 0);
+CSROWDEV_ATTR(ch1_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 1);
+CSROWDEV_ATTR(ch2_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 2);
+CSROWDEV_ATTR(ch3_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 3);
+CSROWDEV_ATTR(ch4_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 4);
+CSROWDEV_ATTR(ch5_dimm_label, S_IRUGO | S_IWUSR,
+	      channel_dimm_label_show, channel_dimm_label_store, 5);
 
 /* Total possible dynamic DIMM Label attribute file table */
 static struct csrowdev_attribute *dynamic_csrow_dimm_attr[] = {
-		&attr_ch0_dimm_label,
-		&attr_ch1_dimm_label,
-		&attr_ch2_dimm_label,
-		&attr_ch3_dimm_label,
-		&attr_ch4_dimm_label,
-		&attr_ch5_dimm_label
+	&attr_ch0_dimm_label,
+	&attr_ch1_dimm_label,
+	&attr_ch2_dimm_label,
+	&attr_ch3_dimm_label,
+	&attr_ch4_dimm_label,
+	&attr_ch5_dimm_label
 };
 
 /* possible dynamic channel ce_count attribute files */
-CSROWDEV_ATTR(ch0_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		0 );
-CSROWDEV_ATTR(ch1_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		1 );
-CSROWDEV_ATTR(ch2_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		2 );
-CSROWDEV_ATTR(ch3_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		3 );
-CSROWDEV_ATTR(ch4_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		4 );
-CSROWDEV_ATTR(ch5_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		5 );
+CSROWDEV_ATTR(ch0_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 0);
+CSROWDEV_ATTR(ch1_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 1);
+CSROWDEV_ATTR(ch2_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 2);
+CSROWDEV_ATTR(ch3_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 3);
+CSROWDEV_ATTR(ch4_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 4);
+CSROWDEV_ATTR(ch5_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 5);
 
 /* Total possible dynamic ce_count attribute file table */
 static struct csrowdev_attribute *dynamic_csrow_ce_count_attr[] = {
-		&attr_ch0_ce_count,
-		&attr_ch1_ce_count,
-		&attr_ch2_ce_count,
-		&attr_ch3_ce_count,
-		&attr_ch4_ce_count,
-		&attr_ch5_ce_count
+	&attr_ch0_ce_count,
+	&attr_ch1_ce_count,
+	&attr_ch2_ce_count,
+	&attr_ch3_ce_count,
+	&attr_ch4_ce_count,
+	&attr_ch5_ce_count
 };
 
-
 #define EDAC_NR_CHANNELS	6
 
 /* Create dynamic CHANNEL files, indexed by 'chan',  under specifed CSROW */
 static int edac_create_channel_files(struct kobject *kobj, int chan)
 {
-	int err=-ENODEV;
+	int err = -ENODEV;
 
 	if (chan >= EDAC_NR_CHANNELS)
 		return err;
 
 	/* create the DIMM label attribute file */
 	err = sysfs_create_file(kobj,
-			(struct attribute *) dynamic_csrow_dimm_attr[chan]);
+				(struct attribute *)
+				dynamic_csrow_dimm_attr[chan]);
 
 	if (!err) {
 		/* create the CE Count attribute file */
 		err = sysfs_create_file(kobj,
-			(struct attribute *)dynamic_csrow_ce_count_attr[chan]);
+					(struct attribute *)
+					dynamic_csrow_ce_count_attr[chan]);
 	} else {
 		debugf1("%s()  dimm labels and ce_count files created",
 			__func__);
@@ -542,14 +497,12 @@ static void edac_csrow_instance_release(
 static struct kobj_type ktype_csrow = {
 	.release = edac_csrow_instance_release,
 	.sysfs_ops = &csrowfs_ops,
-	.default_attrs = (struct attribute **) default_csrow_attr,
+	.default_attrs = (struct attribute **)default_csrow_attr,
 };
 
 /* Create a CSROW object under specifed edac_mc_device */
-static int edac_create_csrow_object(
-		struct kobject *edac_mci_kobj,
-		struct csrow_info *csrow,
-		int index)
+static int edac_create_csrow_object(struct kobject *edac_mci_kobj,
+				    struct csrow_info *csrow, int index)
 {
 	int err = 0;
 	int chan;
@@ -562,7 +515,7 @@ static int edac_create_csrow_object(
 	csrow->kobj.ktype = &ktype_csrow;
 
 	/* name this instance of csrow<id> */
-	err = kobject_set_name(&csrow->kobj,"csrow%d",index);
+	err = kobject_set_name(&csrow->kobj, "csrow%d", index);
 	if (err)
 		goto error_exit;
 
@@ -573,20 +526,20 @@ static int edac_create_csrow_object(
 		 * namely, the DIMM labels and the channel ce_count
 		 */
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			err = edac_create_channel_files(&csrow->kobj,chan);
+			err = edac_create_channel_files(&csrow->kobj, chan);
 			if (err)
 				break;
 		}
 	}
 
-error_exit:
+      error_exit:
 	return err;
 }
 
 /* default sysfs methods and data structures for the main MCI kobject */
 
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
-		const char *data, size_t count)
+					const char *data, size_t count)
 {
 	int row, chan;
 
@@ -611,7 +564,7 @@ static ssize_t mci_reset_counters_store(
 
 /* memory scrubbing */
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					  const char *data, size_t count)
 {
 	u32 bandwidth = -1;
 
@@ -619,20 +572,20 @@ static ssize_t mci_sdram_scrub_rate_stor
 
 		memctrl_int_store(&bandwidth, data, count);
 
-		if (!(*mci->set_sdram_scrub_rate)(mci, &bandwidth)) {
+		if (!(*mci->set_sdram_scrub_rate) (mci, &bandwidth)) {
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set successfully, applied: %d\n",
-				bandwidth);
+				    "Scrub rate set successfully, applied: %d\n",
+				    bandwidth);
 		} else {
 			/* FIXME: error codes maybe? */
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set FAILED, could not apply: %d\n",
-				bandwidth);
+				    "Scrub rate set FAILED, could not apply: %d\n",
+				    bandwidth);
 		}
 	} else {
 		/* FIXME: produce "not implemented" ERROR for user-side. */
 		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'set'control is not implemented!\n");
+			    "Memory scrubbing 'set'control is not implemented!\n");
 	}
 	return count;
 }
@@ -642,20 +595,20 @@ static ssize_t mci_sdram_scrub_rate_show
 	u32 bandwidth = -1;
 
 	if (mci->get_sdram_scrub_rate) {
-		if (!(*mci->get_sdram_scrub_rate)(mci, &bandwidth)) {
+		if (!(*mci->get_sdram_scrub_rate) (mci, &bandwidth)) {
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate successfully, fetched: %d\n",
-				bandwidth);
+				    "Scrub rate successfully, fetched: %d\n",
+				    bandwidth);
 		} else {
 			/* FIXME: error codes maybe? */
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate fetch FAILED, got: %d\n",
-				bandwidth);
+				    "Scrub rate fetch FAILED, got: %d\n",
+				    bandwidth);
 		}
 	} else {
 		/* FIXME: produce "not implemented" ERROR for user-side.  */
 		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'get' control is not implemented\n");
+			    "Memory scrubbing 'get' control is not implemented\n");
 	}
 	return sprintf(data, "%d\n", bandwidth);
 }
@@ -663,32 +616,32 @@ static ssize_t mci_sdram_scrub_rate_show
 /* default attribute files for the MCI object */
 static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%d\n", mci->ue_count);
+	return sprintf(data, "%d\n", mci->ue_count);
 }
 
 static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%d\n", mci->ce_count);
+	return sprintf(data, "%d\n", mci->ce_count);
 }
 
 static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%d\n", mci->ce_noinfo_count);
+	return sprintf(data, "%d\n", mci->ce_noinfo_count);
 }
 
 static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%d\n", mci->ue_noinfo_count);
+	return sprintf(data, "%d\n", mci->ue_noinfo_count);
 }
 
 static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%ld\n", (jiffies - mci->start_time) / HZ);
+	return sprintf(data, "%ld\n", (jiffies - mci->start_time) / HZ);
 }
 
 static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data,"%s\n", mci->ctl_name);
+	return sprintf(data, "%s\n", mci->ctl_name);
 }
 
 static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
@@ -696,7 +649,7 @@ static ssize_t mci_size_mb_show(struct m
 	int total_pages, csrow_idx;
 
 	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
-			csrow_idx++) {
+	     csrow_idx++) {
 		struct csrow_info *csrow = &mci->csrows[csrow_idx];
 
 		if (!csrow->nr_pages)
@@ -705,13 +658,13 @@ static ssize_t mci_size_mb_show(struct m
 		total_pages += csrow->nr_pages;
 	}
 
-	return sprintf(data,"%u\n", PAGES_TO_MiB(total_pages));
+	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
 struct mcidev_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct mem_ctl_info *,char *);
-	ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+	 ssize_t(*show) (struct mem_ctl_info *, char *);
+	 ssize_t(*store) (struct mem_ctl_info *, const char *, size_t);
 };
 
 #define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
@@ -719,10 +672,10 @@ struct mcidev_attribute {
 
 /* MCI show/store functions for top most object */
 static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
-		char *buffer)
+			   char *buffer)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
+	struct mcidev_attribute *mcidev_attr = to_mcidev_attr(attr);
 
 	if (mcidev_attr->show)
 		return mcidev_attr->show(mem_ctl_info, buffer);
@@ -731,10 +684,10 @@ static ssize_t mcidev_show(struct kobjec
 }
 
 static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
+			    const char *buffer, size_t count)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
+	struct mcidev_attribute *mcidev_attr = to_mcidev_attr(attr);
 
 	if (mcidev_attr->store)
 		return mcidev_attr->store(mem_ctl_info, buffer, count);
@@ -755,20 +708,20 @@ static struct mcidev_attribute mci_attr_
 };
 
 /* default Control file */
-MCIDEV_ATTR(reset_counters,S_IWUSR,NULL,mci_reset_counters_store);
+MCIDEV_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
 
 /* default Attribute files */
-MCIDEV_ATTR(mc_name,S_IRUGO,mci_ctl_name_show,NULL);
-MCIDEV_ATTR(size_mb,S_IRUGO,mci_size_mb_show,NULL);
-MCIDEV_ATTR(seconds_since_reset,S_IRUGO,mci_seconds_show,NULL);
-MCIDEV_ATTR(ue_noinfo_count,S_IRUGO,mci_ue_noinfo_show,NULL);
-MCIDEV_ATTR(ce_noinfo_count,S_IRUGO,mci_ce_noinfo_show,NULL);
-MCIDEV_ATTR(ue_count,S_IRUGO,mci_ue_count_show,NULL);
-MCIDEV_ATTR(ce_count,S_IRUGO,mci_ce_count_show,NULL);
+MCIDEV_ATTR(mc_name, S_IRUGO, mci_ctl_name_show, NULL);
+MCIDEV_ATTR(size_mb, S_IRUGO, mci_size_mb_show, NULL);
+MCIDEV_ATTR(seconds_since_reset, S_IRUGO, mci_seconds_show, NULL);
+MCIDEV_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
+MCIDEV_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
+MCIDEV_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
+MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
 
 /* memory scrubber attribute file */
-MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,\
-			mci_sdram_scrub_rate_store);
+MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
+	    mci_sdram_scrub_rate_store);
 
 static struct mcidev_attribute *mci_attr[] = {
 	&mci_attr_reset_counters,
@@ -798,10 +751,9 @@ static void edac_mci_instance_release(st
 static struct kobj_type ktype_mci = {
 	.release = edac_mci_instance_release,
 	.sysfs_ops = &mci_ops,
-	.default_attrs = (struct attribute **) mci_attr,
+	.default_attrs = (struct attribute **)mci_attr,
 };
 
-
 #define EDAC_DEVICE_SYMLINK	"device"
 
 /*
@@ -817,13 +769,13 @@ int edac_create_sysfs_mci_device(struct 
 	int i;
 	int err;
 	struct csrow_info *csrow;
-	struct kobject *edac_mci_kobj=&mci->edac_mci_kobj;
+	struct kobject *edac_mci_kobj = &mci->edac_mci_kobj;
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
 	memset(edac_mci_kobj, 0, sizeof(*edac_mci_kobj));
 
 	/* set the name of the mc<id> object */
-	err = kobject_set_name(edac_mci_kobj,"mc%d",mci->mc_idx);
+	err = kobject_set_name(edac_mci_kobj, "mc%d", mci->mc_idx);
 	if (err)
 		return err;
 
@@ -850,7 +802,7 @@ int edac_create_sysfs_mci_device(struct 
 
 		/* Only expose populated CSROWs */
 		if (csrow->nr_pages > 0) {
-			err = edac_create_csrow_object(edac_mci_kobj,csrow,i);
+			err = edac_create_csrow_object(edac_mci_kobj, csrow, i);
 			if (err)
 				goto fail1;
 		}
@@ -859,8 +811,8 @@ int edac_create_sysfs_mci_device(struct 
 	return 0;
 
 	/* CSROW error: backout what has already been registered,  */
-fail1:
-	for ( i--; i >= 0; i--) {
+      fail1:
+	for (i--; i >= 0; i--) {
 		if (csrow->nr_pages > 0) {
 			init_completion(&csrow->kobj_complete);
 			kobject_unregister(&mci->csrows[i].kobj);
@@ -868,7 +820,7 @@ fail1:
 		}
 	}
 
-fail0:
+      fail0:
 	init_completion(&mci->kobj_complete);
 	kobject_unregister(edac_mci_kobj);
 	wait_for_completion(&mci->kobj_complete);
@@ -898,5 +850,3 @@ void edac_remove_sysfs_mci_device(struct
 	kobject_unregister(&mci->edac_mci_kobj);
 	wait_for_completion(&mci->kobj_complete);
 }
-
-
diff -puN drivers/edac/edac_module.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_module.c
@@ -37,7 +37,7 @@ static int edac_class_valid = 0;
 /*
  * edac_op_state_toString()
  */
-char * edac_op_state_toString(int opstate)
+char *edac_op_state_toString(int opstate)
 {
 	if (opstate == OP_RUNNING_POLL)
 		return "POLLED";
@@ -60,7 +60,7 @@ char * edac_op_state_toString(int opstat
  */
 struct sysdev_class *edac_get_edac_class(void)
 {
-	struct sysdev_class *classptr=NULL;
+	struct sysdev_class *classptr = NULL;
 
 	if (edac_class_valid)
 		classptr = &edac_class;
@@ -133,7 +133,6 @@ static void edac_workqueue_teardown(void
 	}
 }
 
-
 /*
  * edac_init
  *      module initialization entry point
@@ -148,8 +147,8 @@ static int __init edac_init(void)
 	 * Harvest and clear any boot/initialization PCI parity errors
 	 *
 	 * FIXME: This only clears errors logged by devices present at time of
-	 * 	module initialization.  We should also do an initial clear
-	 *	of each newly hotplugged device.
+	 *      module initialization.  We should also do an initial clear
+	 *      of each newly hotplugged device.
 	 */
 	edac_pci_clear_parity_errors();
 
@@ -158,7 +157,7 @@ static int __init edac_init(void)
 	 */
 	if (edac_register_sysfs_edac_name()) {
 		edac_printk(KERN_ERR, EDAC_MC,
-			"Error initializing 'edac' kobject\n");
+			    "Error initializing 'edac' kobject\n");
 		err = -ENODEV;
 		goto error;
 	}
@@ -167,7 +166,7 @@ static int __init edac_init(void)
 	 */
 	if (edac_sysfs_memctrl_setup()) {
 		edac_printk(KERN_ERR, EDAC_MC,
-			"Error initializing sysfs code\n");
+			    "Error initializing sysfs code\n");
 		err = -ENODEV;
 		goto error_sysfs;
 	}
@@ -182,11 +181,11 @@ static int __init edac_init(void)
 	return 0;
 
 	/* Error teardown stack */
-error_mem:
+      error_mem:
 	edac_sysfs_memctrl_teardown();
-error_sysfs:
+      error_sysfs:
 	edac_unregister_sysfs_edac_name();
-error:
+      error:
 	return err;
 }
 
@@ -198,7 +197,7 @@ static void __exit edac_exit(void)
 {
 	debugf0("%s()\n", __func__);
 
-	/* tear down the various subsystems*/
+	/* tear down the various subsystems */
 	edac_workqueue_teardown();
 	edac_sysfs_memctrl_teardown();
 	edac_unregister_sysfs_edac_name();
@@ -220,4 +219,3 @@ MODULE_DESCRIPTION("Core library routine
 module_param(edac_debug_level, int, 0644);
 MODULE_PARM_DESC(edac_debug_level, "Debug level");
 #endif
-
diff -puN drivers/edac/edac_module.h~drivers-edac-core-lindent-cleanup drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_module.h
@@ -40,12 +40,10 @@ extern struct sysdev_class *edac_get_eda
 /* edac core workqueue: single CPU mode */
 extern struct workqueue_struct *edac_workqueue;
 extern void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
-				unsigned msec);
+				    unsigned msec);
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
-extern void edac_device_reset_delay_period(
-			struct edac_device_ctl_info *edac_dev,
-			unsigned long value);
-
+extern void edac_device_reset_delay_period(struct edac_device_ctl_info
+					   *edac_dev, unsigned long value);
 
 /*
  * EDAC PCI functions
@@ -57,7 +55,7 @@ extern int edac_sysfs_pci_setup(void);
 extern void edac_sysfs_pci_teardown(void);
 extern int edac_pci_get_check_errors(void);
 extern int edac_pci_get_poll_msec(void);
-#else   /* CONFIG_PCI */
+#else				/* CONFIG_PCI */
 /* pre-process these away */
 #define edac_pci_do_parity_check()
 #define edac_pci_clear_parity_errors()
@@ -65,8 +63,6 @@ extern int edac_pci_get_poll_msec(void);
 #define edac_sysfs_pci_teardown()
 #define edac_pci_get_check_errors()
 #define edac_pci_get_poll_msec()
-#endif  /* CONFIG_PCI */
-
-
-#endif	/* __EDAC_MODULE_H__ */
+#endif				/* CONFIG_PCI */
 
+#endif				/* __EDAC_MODULE_H__ */
diff -puN drivers/edac/edac_pci.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_pci.c
@@ -46,9 +46,8 @@ static inline void edac_unlock_pci_list(
  * structure. The chip driver will allocate one of these for each
  * edac_pci it is going to control/register with the EDAC CORE.
  */
-struct edac_pci_ctl_info * edac_pci_alloc_ctl_info(
-	unsigned int sz_pvt,
-	const char *edac_pci_name)
+struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
+						  const char *edac_pci_name)
 {
 	struct edac_pci_ctl_info *pci;
 	void *pvt;
@@ -67,10 +66,11 @@ struct edac_pci_ctl_info * edac_pci_allo
 
 	pci->op_state = OP_ALLOC;
 
-	snprintf(pci->name, strlen(edac_pci_name)+1, "%s", edac_pci_name);
+	snprintf(pci->name, strlen(edac_pci_name) + 1, "%s", edac_pci_name);
 
 	return pci;
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
 
 /*
@@ -81,13 +81,14 @@ void edac_pci_free_ctl_info(struct edac_
 {
 	kfree(pci);
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_free_ctl_info);
 
 /*
  * find_edac_pci_by_dev()
  * 	scans the edac_pci list for a specific 'struct device *'
  */
-static struct edac_pci_ctl_info * find_edac_pci_by_dev(struct device *dev)
+static struct edac_pci_ctl_info *find_edac_pci_by_dev(struct device *dev)
 {
 	struct edac_pci_ctl_info *pci;
 	struct list_head *item;
@@ -139,17 +140,18 @@ static int add_edac_pci_to_global_list(s
 	list_add_tail_rcu(&pci->link, insert_before);
 	return 0;
 
-fail0:
+      fail0:
 	edac_printk(KERN_WARNING, EDAC_PCI,
-		"%s (%s) %s %s already assigned %d\n",
-		rover->dev->bus_id, dev_name(rover),
-		rover->mod_name, rover->ctl_name, rover->pci_idx);
+		    "%s (%s) %s %s already assigned %d\n",
+		    rover->dev->bus_id, dev_name(rover),
+		    rover->mod_name, rover->ctl_name, rover->pci_idx);
 	return 1;
 
-fail1:
+      fail1:
 	edac_printk(KERN_WARNING, EDAC_PCI,
-		"but in low-level driver: attempt to assign\n"
-		"\tduplicate pci_idx %d in %s()\n", rover->pci_idx, __func__);
+		    "but in low-level driver: attempt to assign\n"
+		    "\tduplicate pci_idx %d in %s()\n", rover->pci_idx,
+		    __func__);
 	return 1;
 }
 
@@ -185,7 +187,7 @@ static void del_edac_pci_from_global_lis
  *
  * Caller must hold pci_ctls_mutex.
  */
-struct edac_pci_ctl_info * edac_pci_find(int idx)
+struct edac_pci_ctl_info *edac_pci_find(int idx)
 {
 	struct list_head *item;
 	struct edac_pci_ctl_info *pci;
@@ -198,13 +200,14 @@ struct edac_pci_ctl_info * edac_pci_find
 			if (pci->pci_idx == idx)
 				return pci;
 
-		/* not on list, so terminate early */
+			/* not on list, so terminate early */
 			break;
 		}
 	}
 
 	return NULL;
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_find);
 
 /*
@@ -225,15 +228,14 @@ static void edac_pci_workq_function(void
 	edac_lock_pci_list();
 
 	if ((pci->op_state == OP_RUNNING_POLL) &&
-		(pci->edac_check != NULL) &&
-		(edac_pci_get_check_errors()))
+	    (pci->edac_check != NULL) && (edac_pci_get_check_errors()))
 		pci->edac_check(pci);
 
 	edac_unlock_pci_list();
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &pci->work,
-			msecs_to_jiffies(edac_pci_get_poll_msec()));
+			   msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -242,7 +244,7 @@ static void edac_pci_workq_function(void
  * 	passing in the new delay period in msec
  */
 static void edac_pci_workq_setup(struct edac_pci_ctl_info *pci,
-		unsigned int msec)
+				 unsigned int msec)
 {
 	debugf0("%s()\n", __func__);
 
@@ -252,7 +254,7 @@ static void edac_pci_workq_setup(struct 
 	INIT_WORK(&pci->work, edac_pci_workq_function, pci);
 #endif
 	queue_delayed_work(edac_workqueue, &pci->work,
-			msecs_to_jiffies(edac_pci_get_poll_msec()));
+			   msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -272,7 +274,7 @@ static void edac_pci_workq_teardown(stru
  * edac_pci_reset_delay_period
  */
 void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
-		unsigned long value)
+				 unsigned long value)
 {
 	edac_lock_pci_list();
 
@@ -282,6 +284,7 @@ void edac_pci_reset_delay_period(struct 
 
 	edac_unlock_pci_list();
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
 
 /*
@@ -324,22 +327,22 @@ int edac_pci_add_device(struct edac_pci_
 	}
 
 	edac_pci_printk(pci, KERN_INFO,
-		"Giving out device to module '%s' controller '%s':"
-		" DEV '%s' (%s)\n",
-		pci->mod_name,
-		pci->ctl_name,
-		dev_name(pci),
-		edac_op_state_toString(pci->op_state));
+			"Giving out device to module '%s' controller '%s':"
+			" DEV '%s' (%s)\n",
+			pci->mod_name,
+			pci->ctl_name,
+			dev_name(pci), edac_op_state_toString(pci->op_state));
 
 	edac_unlock_pci_list();
 	return 0;
 
-fail1:
+      fail1:
 	del_edac_pci_from_global_list(pci);
-fail0:
+      fail0:
 	edac_unlock_pci_list();
 	return 1;
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_add_device);
 
 /*
@@ -355,7 +358,7 @@ EXPORT_SYMBOL_GPL(edac_pci_add_device);
  * 	Pointer to removed edac_pci structure,
  * 	or NULL if device not found
  */
-struct edac_pci_ctl_info * edac_pci_del_device(struct device *dev)
+struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev)
 {
 	struct edac_pci_ctl_info *pci;
 
@@ -379,14 +382,12 @@ struct edac_pci_ctl_info * edac_pci_del_
 	edac_unlock_pci_list();
 
 	edac_printk(KERN_INFO, EDAC_PCI,
-		"Removed device %d for %s %s: DEV %s\n",
-		pci->pci_idx,
-		pci->mod_name,
-		pci->ctl_name,
-		dev_name(pci));
+		    "Removed device %d for %s %s: DEV %s\n",
+		    pci->pci_idx, pci->mod_name, pci->ctl_name, dev_name(pci));
 
 	return pci;
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_del_device);
 
 void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
@@ -401,8 +402,8 @@ struct edac_pci_gen_data {
 	int edac_idx;
 };
 
-struct edac_pci_ctl_info *
-edac_pci_create_generic_ctl(struct device *dev, const char *mod_name)
+struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev,
+						      const char *mod_name)
 {
 	struct edac_pci_ctl_info *pci;
 	struct edac_pci_gen_data *pdata;
@@ -430,6 +431,7 @@ edac_pci_create_generic_ctl(struct devic
 
 	return pci;
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_create_generic_ctl);
 
 void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci)
@@ -437,4 +439,5 @@ void edac_pci_release_generic_ctl(struct
 	edac_pci_del_device(pci->dev);
 	edac_pci_free_ctl_info(pci);
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_release_generic_ctl);
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -13,7 +13,6 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-
 #ifdef CONFIG_PCI
 
 #define EDAC_PCI_SYMLINK	"device"
@@ -26,7 +25,7 @@ static atomic_t pci_parity_count = ATOMI
 static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
 static int edac_pci_poll_msec = 1000;
 
-static struct kobject edac_pci_kobj; /* /sys/devices/system/edac/pci */
+static struct kobject edac_pci_kobj;	/* /sys/devices/system/edac/pci */
 static struct completion edac_pci_kobj_complete;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
 
@@ -58,13 +57,13 @@ int edac_pci_get_poll_msec(void)
 /**************************** EDAC PCI sysfs instance *******************/
 static ssize_t instance_pe_count_show(struct edac_pci_ctl_info *pci, char *data)
 {
-        return sprintf(data,"%u\n", atomic_read(&pci->counters.pe_count));
+	return sprintf(data, "%u\n", atomic_read(&pci->counters.pe_count));
 }
 
 static ssize_t instance_npe_count_show(struct edac_pci_ctl_info *pci,
-		char *data)
+				       char *data)
 {
-        return sprintf(data,"%u\n", atomic_read(&pci->counters.npe_count));
+	return sprintf(data, "%u\n", atomic_read(&pci->counters.npe_count));
 }
 
 #define to_instance(k) container_of(k, struct edac_pci_ctl_info, kobj)
@@ -83,36 +82,34 @@ static void edac_pci_instance_release(st
 
 /* instance specific attribute structure */
 struct instance_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct edac_pci_ctl_info *, char *);
-        ssize_t (*store)(struct edac_pci_ctl_info *, const char *, size_t);
+	struct attribute attr;
+	 ssize_t(*show) (struct edac_pci_ctl_info *, char *);
+	 ssize_t(*store) (struct edac_pci_ctl_info *, const char *, size_t);
 };
 
 /* Function to 'show' fields from the edac_pci 'instance' structure */
 static ssize_t edac_pci_instance_show(struct kobject *kobj,
-                        struct attribute *attr,
-                        char *buffer)
+				      struct attribute *attr, char *buffer)
 {
-        struct edac_pci_ctl_info *pci = to_instance(kobj);
-        struct instance_attribute *instance_attr = to_instance_attr(attr);
+	struct edac_pci_ctl_info *pci = to_instance(kobj);
+	struct instance_attribute *instance_attr = to_instance_attr(attr);
 
-        if (instance_attr->show)
-                return instance_attr->show(pci, buffer);
-        return -EIO;
+	if (instance_attr->show)
+		return instance_attr->show(pci, buffer);
+	return -EIO;
 }
 
-
 /* Function to 'store' fields into the edac_pci 'instance' structure */
 static ssize_t edac_pci_instance_store(struct kobject *kobj,
-                        struct attribute *attr,
-                	const char *buffer, size_t count)
+				       struct attribute *attr,
+				       const char *buffer, size_t count)
 {
-        struct edac_pci_ctl_info *pci = to_instance(kobj);
-        struct instance_attribute *instance_attr = to_instance_attr(attr);
+	struct edac_pci_ctl_info *pci = to_instance(kobj);
+	struct instance_attribute *instance_attr = to_instance_attr(attr);
 
-        if (instance_attr->store)
-                return instance_attr->store(pci, buffer, count);
-        return -EIO;
+	if (instance_attr->store)
+		return instance_attr->store(pci, buffer, count);
+	return -EIO;
 }
 
 static struct sysfs_ops pci_instance_ops = {
@@ -158,7 +155,7 @@ static int edac_pci_create_instance_kobj
 	err = kobject_register(&pci->kobj);
 	if (err != 0) {
 		debugf2("%s() failed to register instance pci%d\n",
-				__func__, idx);
+			__func__, idx);
 		return err;
 	}
 
@@ -182,7 +179,7 @@ edac_pci_delete_instance_kobj(struct eda
 static ssize_t edac_pci_int_show(void *ptr, char *buffer)
 {
 	int *value = ptr;
-	return sprintf(buffer,"%d\n",*value);
+	return sprintf(buffer, "%d\n", *value);
 }
 
 static ssize_t edac_pci_int_store(void *ptr, const char *buffer, size_t count)
@@ -190,7 +187,7 @@ static ssize_t edac_pci_int_store(void *
 	int *value = ptr;
 
 	if (isdigit(*buffer))
-		*value = simple_strtoul(buffer,NULL,0);
+		*value = simple_strtoul(buffer, NULL, 0);
 
 	return count;
 }
@@ -198,16 +195,16 @@ static ssize_t edac_pci_int_store(void *
 struct edac_pci_dev_attribute {
 	struct attribute attr;
 	void *value;
-	ssize_t (*show)(void *,char *);
-	ssize_t (*store)(void *, const char *,size_t);
+	 ssize_t(*show) (void *, char *);
+	 ssize_t(*store) (void *, const char *, size_t);
 };
 
 /* Set of show/store abstract level functions for PCI Parity object */
 static ssize_t edac_pci_dev_show(struct kobject *kobj, struct attribute *attr,
-		char *buffer)
+				 char *buffer)
 {
 	struct edac_pci_dev_attribute *edac_pci_dev;
-	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
+	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
 
 	if (edac_pci_dev->show)
 		return edac_pci_dev->show(edac_pci_dev->value, buffer);
@@ -215,10 +212,11 @@ static ssize_t edac_pci_dev_show(struct 
 }
 
 static ssize_t edac_pci_dev_store(struct kobject *kobj,
-		struct attribute *attr, const char *buffer, size_t count)
+				  struct attribute *attr, const char *buffer,
+				  size_t count)
 {
 	struct edac_pci_dev_attribute *edac_pci_dev;
-	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
+	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
 
 	if (edac_pci_dev->show)
 		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
@@ -226,8 +224,8 @@ static ssize_t edac_pci_dev_store(struct
 }
 
 static struct sysfs_ops edac_pci_sysfs_ops = {
-	.show   = edac_pci_dev_show,
-	.store  = edac_pci_dev_store
+	.show = edac_pci_dev_show,
+	.store = edac_pci_dev_store
 };
 
 #define EDAC_PCI_ATTR(_name,_mode,_show,_store)			\
@@ -247,14 +245,14 @@ static struct edac_pci_dev_attribute eda
 };
 
 /* PCI Parity control files */
-EDAC_PCI_ATTR(check_pci_errors, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
-EDAC_PCI_ATTR(edac_pci_log_pe, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
-EDAC_PCI_ATTR(edac_pci_log_npe, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
-EDAC_PCI_ATTR(edac_pci_panic_on_pe, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
+EDAC_PCI_ATTR(check_pci_errors, S_IRUGO | S_IWUSR, edac_pci_int_show,
+	      edac_pci_int_store);
+EDAC_PCI_ATTR(edac_pci_log_pe, S_IRUGO | S_IWUSR, edac_pci_int_show,
+	      edac_pci_int_store);
+EDAC_PCI_ATTR(edac_pci_log_npe, S_IRUGO | S_IWUSR, edac_pci_int_show,
+	      edac_pci_int_store);
+EDAC_PCI_ATTR(edac_pci_panic_on_pe, S_IRUGO | S_IWUSR, edac_pci_int_show,
+	      edac_pci_int_store);
 EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
 EDAC_PCI_ATTR(pci_nonparity_count, S_IRUGO, edac_pci_int_show, NULL);
 
@@ -283,7 +281,7 @@ static void edac_pci_release(struct kobj
 static struct kobj_type ktype_edac_pci = {
 	.release = edac_pci_release,
 	.sysfs_ops = &edac_pci_sysfs_ops,
-	.default_attrs = (struct attribute **) edac_pci_attr,
+	.default_attrs = (struct attribute **)edac_pci_attr,
 };
 
 /**
@@ -310,7 +308,7 @@ int edac_pci_register_main_kobj(void)
 	edac_pci_kobj.parent = &edac_class->kset.kobj;
 
 	err = kobject_set_name(&edac_pci_kobj, "pci");
-	if(err)
+	if (err)
 		return err;
 
 	/* Instanstiate the pci object */
@@ -359,15 +357,12 @@ int edac_pci_create_sysfs(struct edac_pc
 			edac_pci_unregister_main_kobj();
 	}
 
-
 	debugf0("%s() idx=%d\n", __func__, pci->pci_idx);
 
-	err = sysfs_create_link(edac_kobj,
-			&pci->dev->kobj,
-			EDAC_PCI_SYMLINK);
+	err = sysfs_create_link(edac_kobj, &pci->dev->kobj, EDAC_PCI_SYMLINK);
 	if (err) {
 		debugf0("%s() sysfs_create_link() returned err= %d\n",
-				__func__, err);
+			__func__, err);
 		return err;
 	}
 
@@ -410,7 +405,7 @@ static u16 get_pci_parity_status(struct 
 	}
 
 	status &= PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR |
-		PCI_STATUS_PARITY;
+	    PCI_STATUS_PARITY;
 
 	if (status)
 		/* reset only the bits we are interested in */
@@ -419,7 +414,7 @@ static u16 get_pci_parity_status(struct 
 	return status;
 }
 
-typedef void (*pci_parity_check_fn_t) (struct pci_dev *dev);
+typedef void (*pci_parity_check_fn_t) (struct pci_dev * dev);
 
 /* Clear any PCI parity errors logged by this device. */
 static void edac_pci_dev_parity_clear(struct pci_dev *dev)
@@ -442,35 +437,35 @@ static void edac_pci_dev_parity_clear(st
 static void edac_pci_dev_parity_test(struct pci_dev *dev)
 {
 	u16 status;
-	u8  header_type;
+	u8 header_type;
 
 	/* read the STATUS register on this device
 	 */
 	status = get_pci_parity_status(dev, 0);
 
-	debugf2("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id );
+	debugf2("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
 	/* check the status reg for errors */
 	if (status) {
 		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Signaled System Error on %s\n",
-				pci_name(dev));
+				    "Signaled System Error on %s\n",
+				    pci_name(dev));
 			atomic_inc(&pci_nonparity_count);
 		}
 
 		if (status & (PCI_STATUS_PARITY)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Master Data Parity Error on %s\n",
-				pci_name(dev));
+				    "Master Data Parity Error on %s\n",
+				    pci_name(dev));
 
 			atomic_inc(&pci_parity_count);
 		}
 
 		if (status & (PCI_STATUS_DETECTED_PARITY)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Detected Parity Error on %s\n",
-				pci_name(dev));
+				    "Detected Parity Error on %s\n",
+				    pci_name(dev));
 
 			atomic_inc(&pci_parity_count);
 		}
@@ -479,36 +474,35 @@ static void edac_pci_dev_parity_test(str
 	/* read the device TYPE, looking for bridges */
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
 
-	debugf2("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id );
+	debugf2("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id);
 
 	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 		/* On bridges, need to examine secondary status register  */
 		status = get_pci_parity_status(dev, 1);
 
-		debugf2("PCI SEC_STATUS= 0x%04x %s\n",
-				status, dev->dev.bus_id );
+		debugf2("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
 		/* check the secondary status reg for errors */
 		if (status) {
 			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Signaled System Error on %s\n",
-					pci_name(dev));
+					    "Signaled System Error on %s\n",
+					    pci_name(dev));
 				atomic_inc(&pci_nonparity_count);
 			}
 
 			if (status & (PCI_STATUS_PARITY)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Master Data Parity Error on "
-					"%s\n", pci_name(dev));
+					    "Master Data Parity Error on "
+					    "%s\n", pci_name(dev));
 
 				atomic_inc(&pci_parity_count);
 			}
 
 			if (status & (PCI_STATUS_DETECTED_PARITY)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Detected Parity Error on %s\n",
-					pci_name(dev));
+					    "Detected Parity Error on %s\n",
+					    pci_name(dev));
 
 				atomic_inc(&pci_parity_count);
 			}
@@ -529,7 +523,7 @@ static inline void edac_pci_dev_parity_i
 	 * and while we are looking at it have its reference count
 	 * bumped until we are done with it
 	 */
-	while((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		fn(dev);
 	}
 }
@@ -590,6 +584,7 @@ void edac_pci_handle_pe(struct edac_pci_
 	 */
 	edac_pci_do_parity_check();
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_handle_pe);
 
 void edac_pci_handle_npe(struct edac_pci_ctl_info *pci, const char *msg)
@@ -609,6 +604,7 @@ void edac_pci_handle_npe(struct edac_pci
 	 */
 	edac_pci_do_parity_check();
 }
+
 EXPORT_SYMBOL_GPL(edac_pci_handle_npe);
 
 /*
@@ -616,9 +612,9 @@ EXPORT_SYMBOL_GPL(edac_pci_handle_npe);
  */
 module_param(check_pci_errors, int, 0644);
 MODULE_PARM_DESC(check_pci_errors,
-		"Check for PCI bus parity errors: 0=off 1=on");
+		 "Check for PCI bus parity errors: 0=off 1=on");
 module_param(edac_pci_panic_on_pe, int, 0644);
 MODULE_PARM_DESC(edac_pci_panic_on_pe,
-		"Panic on PCI Bus Parity error: 0=off 1=on");
+		 "Panic on PCI Bus Parity error: 0=off 1=on");
 
-#endif	/* CONFIG_PCI */
+#endif				/* CONFIG_PCI */
diff -puN drivers/edac/edac_stub.c~drivers-edac-core-lindent-cleanup drivers/edac/edac_stub.c
--- a/drivers/edac/edac_stub.c~drivers-edac-core-lindent-cleanup
+++ a/drivers/edac/edac_stub.c
@@ -30,6 +30,7 @@ inline int edac_handler_set(void)
 
 	return atomic_read(&edac_handlers);
 }
+
 EXPORT_SYMBOL(edac_handler_set);
 
 /*
@@ -39,4 +40,5 @@ inline void edac_atomic_assert_error(voi
 {
 	edac_err_assert++;
 }
+
 EXPORT_SYMBOL(edac_atomic_assert_error);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
