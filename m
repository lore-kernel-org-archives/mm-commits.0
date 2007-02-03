From: akpm@osdl.org
Subject: - rewrite-a-number-of-files-to-use-the-field_size-macro.patch removed from -mm tree
Date: Fri, 02 Feb 2007 18:05:25 -0800
Message-ID: <200702030206.l1326OU1027031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbXBCCK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 21:10:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, agruen@suse.de, amitkale@netxen.com, auke-jan.h.kok@intel.com, benh@kernel.crashing.org, dale@farnsworth.org, duncan.sands@free.fr, greg@kroah.com, jeff@garzik.org, kelly@au.ibm.com, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Rewrite a number of files to use the FIELD_SIZE() macro
has been removed from the -mm tree.  Its filename was
     rewrite-a-number-of-files-to-use-the-field_size-macro.patch

This patch was dropped because naming clashes over FIELD_SIZE

------------------------------------------------------
Subject: Rewrite a number of files to use the FIELD_SIZE() macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rename the macro FIELD_SIZEOF to simply FIELD_SIZE in kernel.h, and replace
explicit code in a number of files to use that macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kelly Daly <kelly@au.ibm.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Amit S. Kale <amitkale@netxen.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/CodingStyle               |    2 -
 arch/m68k/kernel/signal.c               |   30 +++++++++++-----------
 arch/um/drivers/net_kern.c              |    2 -
 drivers/block/viodasd.c                 |    2 -
 drivers/net/e1000/e1000_ethtool.c       |    2 -
 drivers/net/ixgb/ixgb_ethtool.c         |    2 -
 drivers/net/mv643xx_eth.c               |    2 -
 drivers/net/netxen/netxen_nic_ethtool.c |    2 -
 drivers/usb/atm/usbatm.c                |    2 -
 drivers/usb/net/cdc_ether.c             |    2 -
 drivers/usb/net/usbnet.c                |    2 -
 drivers/usb/serial/io_usbvend.h         |    8 ++---
 fs/ext2/xattr.c                         |    2 -
 fs/ext3/xattr.c                         |    2 -
 fs/ext4/xattr.c                         |    2 -
 fs/mbcache.c                            |    2 -
 include/asm-powerpc/fs_pd.h             |    2 -
 include/linux/kernel.h                  |    2 -
 include/net/sctp/sctp.h                 |    2 -
 19 files changed, 36 insertions(+), 36 deletions(-)

diff -puN Documentation/CodingStyle~rewrite-a-number-of-files-to-use-the-field_size-macro Documentation/CodingStyle
--- a/Documentation/CodingStyle~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/Documentation/CodingStyle
@@ -693,7 +693,7 @@ of the macro
 
 Similarly, if you need to calculate the size of some structure member, use
 
-  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+  #define FIELD_SIZE(t, f) (sizeof(((t*)0)->f))
 
 There are also min() and max() macros that do strict type checking if you
 need them.  Feel free to peruse that header file to see what else is already
diff -puN arch/m68k/kernel/signal.c~rewrite-a-number-of-files-to-use-the-field_size-macro arch/m68k/kernel/signal.c
--- a/arch/m68k/kernel/signal.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/arch/m68k/kernel/signal.c
@@ -54,21 +54,21 @@
 asmlinkage int do_signal(sigset_t *oldset, struct pt_regs *regs);
 
 const int frame_extra_sizes[16] = {
-  [1]	= -1, /* sizeof(((struct frame *)0)->un.fmt1), */
-  [2]	= sizeof(((struct frame *)0)->un.fmt2),
-  [3]	= sizeof(((struct frame *)0)->un.fmt3),
-  [4]	= sizeof(((struct frame *)0)->un.fmt4),
-  [5]	= -1, /* sizeof(((struct frame *)0)->un.fmt5), */
-  [6]	= -1, /* sizeof(((struct frame *)0)->un.fmt6), */
-  [7]	= sizeof(((struct frame *)0)->un.fmt7),
-  [8]	= -1, /* sizeof(((struct frame *)0)->un.fmt8), */
-  [9]	= sizeof(((struct frame *)0)->un.fmt9),
-  [10]	= sizeof(((struct frame *)0)->un.fmta),
-  [11]	= sizeof(((struct frame *)0)->un.fmtb),
-  [12]	= -1, /* sizeof(((struct frame *)0)->un.fmtc), */
-  [13]	= -1, /* sizeof(((struct frame *)0)->un.fmtd), */
-  [14]	= -1, /* sizeof(((struct frame *)0)->un.fmte), */
-  [15]	= -1, /* sizeof(((struct frame *)0)->un.fmtf), */
+  [1]	= -1, /* FIELD_SIZE(struct frame, un.fmt1), */
+  [2]	= FIELD_SIZE(struct frame, un.fmt2),
+  [3]	= FIELD_SIZE(struct frame, un.fmt3),
+  [4]	= FIELD_SIZE(struct frame, un.fmt4),
+  [5]	= -1, /* FIELD_SIZE(struct frame, un.fmt5), */
+  [6]	= -1, /* FIELD_SIZE(struct frame, un.fmt6), */
+  [7]	= FIELD_SIZE(struct frame, un.fmt7),
+  [8]	= -1, /* FIELD_SIZE(struct frame, un.fmt8), */
+  [9]	= FIELD_SIZE(struct frame, un.fmt9),
+  [10]	= FIELD_SIZE(struct frame, un.fmta),
+  [11]	= FIELD_SIZE(struct frame, un.fmtb),
+  [12]	= -1, /* FIELD_SIZE(struct frame, un.fmtc), */
+  [13]	= -1, /* FIELD_SIZE(struct frame, un.fmtd), */
+  [14]	= -1, /* FIELD_SIZE(struct frame, un.fmte), */
+  [15]	= -1, /* FIELD_SIZE(struct frame, un.fmtf), */
 };
 
 /*
diff -puN arch/um/drivers/net_kern.c~rewrite-a-number-of-files-to-use-the-field_size-macro arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/arch/um/drivers/net_kern.c
@@ -334,7 +334,7 @@ static int eth_configure(int n, void *in
 	int save, err, size;
 
 	size = transport->private_size + sizeof(struct uml_net_private) +
-		sizeof(((struct uml_net_private *) 0)->user);
+		FIELD_SIZE(struct uml_net_private, user);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
diff -puN drivers/block/viodasd.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/block/viodasd.c
--- a/drivers/block/viodasd.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/block/viodasd.c
@@ -69,7 +69,7 @@ MODULE_LICENSE("GPL");
 enum {
 	PARTITION_SHIFT = 3,
 	MAX_DISKNO = HVMAXARCHITECTEDVIRTUALDISKS,
-	MAX_DISK_NAME = sizeof(((struct gendisk *)0)->disk_name)
+	MAX_DISK_NAME = FIELD_SIZE(struct gendisk, disk_name)
 };
 
 static DEFINE_SPINLOCK(viodasd_spinlock);
diff -puN drivers/net/e1000/e1000_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/net/e1000/e1000_ethtool.c
--- a/drivers/net/e1000/e1000_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/net/e1000/e1000_ethtool.c
@@ -53,7 +53,7 @@ struct e1000_stats {
 	int stat_offset;
 };
 
-#define E1000_STAT(m) sizeof(((struct e1000_adapter *)0)->m), \
+#define E1000_STAT(m) FIELD_SIZE(struct e1000_adapter, m), \
 		      offsetof(struct e1000_adapter, m)
 static const struct e1000_stats e1000_gstrings_stats[] = {
 	{ "rx_packets", E1000_STAT(stats.gprc) },
diff -puN drivers/net/ixgb/ixgb_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/net/ixgb/ixgb_ethtool.c
--- a/drivers/net/ixgb/ixgb_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/net/ixgb/ixgb_ethtool.c
@@ -52,7 +52,7 @@ struct ixgb_stats {
 	int stat_offset;
 };
 
-#define IXGB_STAT(m) sizeof(((struct ixgb_adapter *)0)->m), \
+#define IXGB_STAT(m) FIELD_SIZE(struct ixgb_adapter, m), \
 		      offsetof(struct ixgb_adapter, m)
 static struct ixgb_stats ixgb_gstrings_stats[] = {
 	{"rx_packets", IXGB_STAT(net_stats.rx_packets)},
diff -puN drivers/net/mv643xx_eth.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/net/mv643xx_eth.c
@@ -2659,7 +2659,7 @@ struct mv643xx_stats {
 	int stat_offset;
 };
 
-#define MV643XX_STAT(m) sizeof(((struct mv643xx_private *)0)->m), \
+#define MV643XX_STAT(m) FIELD_SIZE(struct mv643xx_private, m), \
 					offsetof(struct mv643xx_private, m)
 
 static const struct mv643xx_stats mv643xx_gstrings_stats[] = {
diff -puN drivers/net/netxen/netxen_nic_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/net/netxen/netxen_nic_ethtool.c
--- a/drivers/net/netxen/netxen_nic_ethtool.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/net/netxen/netxen_nic_ethtool.c
@@ -49,7 +49,7 @@ struct netxen_nic_stats {
 	int stat_offset;
 };
 
-#define NETXEN_NIC_STAT(m) sizeof(((struct netxen_port *)0)->m), \
+#define NETXEN_NIC_STAT(m) FIELD_SIZE(struct netxen_port, m), \
 			offsetof(struct netxen_port, m)
 
 #define NETXEN_NIC_PORT_WINDOW 0x10000
diff -puN drivers/usb/atm/usbatm.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/usb/atm/usbatm.c
@@ -1332,7 +1332,7 @@ static int __init usbatm_usb_init(void)
 {
 	dbg("%s: driver version %s", __func__, DRIVER_VERSION);
 
-	if (sizeof(struct usbatm_control) > sizeof(((struct sk_buff *) 0)->cb)) {
+	if (sizeof(struct usbatm_control) > FIELD_SIZE(struct sk_buff, cb)) {
 		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
 		return -EIO;
 	}
diff -puN drivers/usb/net/cdc_ether.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/usb/net/cdc_ether.c
--- a/drivers/usb/net/cdc_ether.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/usb/net/cdc_ether.c
@@ -553,7 +553,7 @@ static struct usb_driver cdc_driver = {
 
 static int __init cdc_init(void)
 {
-	BUILD_BUG_ON((sizeof(((struct usbnet *)0)->data)
+	BUILD_BUG_ON((FIELD_SIZE(struct usbnet, data)
 			< sizeof(struct cdc_state)));
 
  	return usb_register(&cdc_driver);
diff -puN drivers/usb/net/usbnet.c~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/usb/net/usbnet.c
--- a/drivers/usb/net/usbnet.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/usb/net/usbnet.c
@@ -1283,7 +1283,7 @@ EXPORT_SYMBOL_GPL(usbnet_resume);
 static int __init usbnet_init(void)
 {
 	/* compiler should optimize this out */
-	BUILD_BUG_ON (sizeof (((struct sk_buff *)0)->cb)
+	BUILD_BUG_ON (FIELD_SIZE(struct sk_buff, cb)
 			< sizeof (struct skb_data));
 
 	random_ether_addr(node_id);
diff -puN drivers/usb/serial/io_usbvend.h~rewrite-a-number-of-files-to-use-the-field_size-macro drivers/usb/serial/io_usbvend.h
--- a/drivers/usb/serial/io_usbvend.h~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/drivers/usb/serial/io_usbvend.h
@@ -512,10 +512,10 @@ struct edge_manuf_descriptor {
 
 #define MANUF_BOARD_REV_A		1	// First rev of 251+Netchip design
 
-#define	MANUF_SERNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->SerialNumber)
-#define	MANUF_ASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->AssemblyNumber)
-#define	MANUF_OEMASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->OemAssyNumber)
-#define	MANUF_MANUFDATE_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->ManufDate)
+#define	MANUF_SERNUM_LENGTH		FIELD_SIZE(struct edge_manuf_descriptor, SerialNumber)
+#define	MANUF_ASSYNUM_LENGTH		FIELD_SIZE(struct edge_manuf_descriptor, AssemblyNumber)
+#define	MANUF_OEMASSYNUM_LENGTH		FIELD_SIZE(struct edge_manuf_descriptor, OemAssyNumber)
+#define	MANUF_MANUFDATE_LENGTH		FIELD_SIZE(struct edge_manuf_descriptor, ManufDate)
 
 #define	MANUF_ION_CONFIG_DIAG_NO_LOOP	0x20	// As below but no ext loopback test
 #define	MANUF_ION_CONFIG_DIAG		0x40	// 930 based device: 1=Run h/w diags, 0=norm
diff -puN fs/ext2/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/fs/ext2/xattr.c
@@ -1024,7 +1024,7 @@ init_ext2_xattr(void)
 {
 	ext2_xattr_cache = mb_cache_create("ext2_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZE(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext2_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ext3/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/fs/ext3/xattr.c
@@ -1299,7 +1299,7 @@ init_ext3_xattr(void)
 {
 	ext3_xattr_cache = mb_cache_create("ext3_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZE(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext3_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ext4/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/fs/ext4/xattr.c
@@ -1299,7 +1299,7 @@ init_ext4_xattr(void)
 {
 	ext4_xattr_cache = mb_cache_create("ext4_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZE(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext4_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/mbcache.c~rewrite-a-number-of-files-to-use-the-field_size-macro fs/mbcache.c
--- a/fs/mbcache.c~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/fs/mbcache.c
@@ -255,7 +255,7 @@ mb_cache_create(const char *name, struct
 	struct mb_cache *cache = NULL;
 
 	if(entry_size < sizeof(struct mb_cache_entry) +
-	   indexes_count * sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]))
+	   indexes_count * FIELD_SIZE(struct mb_cache_entry, e_indexes[0]))
 		return NULL;
 
 	cache = kmalloc(sizeof(struct mb_cache) +
diff -puN include/asm-powerpc/fs_pd.h~rewrite-a-number-of-files-to-use-the-field_size-macro include/asm-powerpc/fs_pd.h
--- a/include/asm-powerpc/fs_pd.h~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/include/asm-powerpc/fs_pd.h
@@ -29,7 +29,7 @@ static inline int uart_clock(void)
 ({									\
 	u32 offset = offsetof(cpm2_map_t, member);			\
 	void *addr = ioremap (CPM_MAP_ADDR + offset,			\
-			      sizeof( ((cpm2_map_t*)0)->member));	\
+			      FIELD_SIZE(cpm2_map_t, member));	\
 	addr;								\
 })
 
diff -puN include/linux/kernel.h~rewrite-a-number-of-files-to-use-the-field_size-macro include/linux/kernel.h
--- a/include/linux/kernel.h~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/include/linux/kernel.h
@@ -36,7 +36,7 @@ extern const char linux_proc_banner[];
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+#define FIELD_SIZE(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
diff -puN include/net/sctp/sctp.h~rewrite-a-number-of-files-to-use-the-field_size-macro include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h~rewrite-a-number-of-files-to-use-the-field_size-macro
+++ a/include/net/sctp/sctp.h
@@ -599,7 +599,7 @@ static inline int param_type2af(__be16 t
 static inline int sctp_sanity_check(void)
 {
 	SCTP_ASSERT(sizeof(struct sctp_ulpevent) <=
-		    sizeof(((struct sk_buff *)0)->cb),
+		    FIELD_SIZE(struct sk_buff, cb),
 		    "SCTP: ulpevent does not fit in skb!\n", return 0);
 
 	return 1;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-acpi.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
rename-ipw2100-debugging-macros-to-not-look-like-config.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
add-is_power_of_2-checking-to-log2h.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
rewrite-a-number-of-files-to-use-the-field_size-macro.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
