From: akpm@osdl.org
Subject: + rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:46:21 -0800
Message-ID: <200612210046.kBL0kLQI011507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161092AbWLUArA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:47:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, agruen@suse.de, auke-jan.h.kok@intel.com, benh@kernel.crashing.org, geert@linux-m68k.org, greg@kroah.com, jdike@addtoit.com, jeff@garzik.org, paulus@samba.org, zippel@linux-m68k.org


The patch titled
     Rewrite unnecessary duplicated code to use FIELD_SIZEOF()
has been added to the -mm tree.  Its filename is
     rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Rewrite unnecessary duplicated code to use FIELD_SIZEOF()
From: "Robert P. J. Day" <rpjday@mindspring.com>

As with ARRAY_SIZE(), there are a number of places (mercifully, far fewer)
that recode what could be done with the FIELD_SIZEOF() macro in kernel.h.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

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
 include/net/sctp/sctp.h                 |    2 -
 17 files changed, 34 insertions(+), 34 deletions(-)

diff -puN arch/m68k/kernel/signal.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof arch/m68k/kernel/signal.c
--- a/arch/m68k/kernel/signal.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
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
+  [1]	= -1, /* FIELD_SIZEOF(struct frame, un.fmt1), */
+  [2]	= FIELD_SIZEOF(struct frame, un.fmt2),
+  [3]	= FIELD_SIZEOF(struct frame, un.fmt3),
+  [4]	= FIELD_SIZEOF(struct frame, un.fmt4),
+  [5]	= -1, /* FIELD_SIZEOF(struct frame, un.fmt5), */
+  [6]	= -1, /* FIELD_SIZEOF(struct frame, un.fmt6), */
+  [7]	= FIELD_SIZEOF(struct frame, un.fmt7),
+  [8]	= -1, /* FIELD_SIZEOF(struct frame, un.fmt8), */
+  [9]	= FIELD_SIZEOF(struct frame, un.fmt9),
+  [10]	= FIELD_SIZEOF(struct frame, un.fmta),
+  [11]	= FIELD_SIZEOF(struct frame, un.fmtb),
+  [12]	= -1, /* FIELD_SIZEOF(struct frame, un.fmtc), */
+  [13]	= -1, /* FIELD_SIZEOF(struct frame, un.fmtd), */
+  [14]	= -1, /* FIELD_SIZEOF(struct frame, un.fmte), */
+  [15]	= -1, /* FIELD_SIZEOF(struct frame, un.fmtf), */
 };
 
 /*
diff -puN arch/um/drivers/net_kern.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/arch/um/drivers/net_kern.c
@@ -334,7 +334,7 @@ static int eth_configure(int n, void *in
 	int save, err, size;
 
 	size = transport->private_size + sizeof(struct uml_net_private) + 
-		sizeof(((struct uml_net_private *) 0)->user);
+		FIELD_SIZEOF(struct uml_net_private, user);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
diff -puN drivers/block/viodasd.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/block/viodasd.c
--- a/drivers/block/viodasd.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/block/viodasd.c
@@ -69,7 +69,7 @@ MODULE_LICENSE("GPL");
 enum {
 	PARTITION_SHIFT = 3,
 	MAX_DISKNO = HVMAXARCHITECTEDVIRTUALDISKS,
-	MAX_DISK_NAME = sizeof(((struct gendisk *)0)->disk_name)
+	MAX_DISK_NAME = FIELD_SIZEOF(struct gendisk, disk_name)
 };
 
 static DEFINE_SPINLOCK(viodasd_spinlock);
diff -puN drivers/net/e1000/e1000_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/net/e1000/e1000_ethtool.c
--- a/drivers/net/e1000/e1000_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/net/e1000/e1000_ethtool.c
@@ -53,7 +53,7 @@ struct e1000_stats {
 	int stat_offset;
 };
 
-#define E1000_STAT(m) sizeof(((struct e1000_adapter *)0)->m), \
+#define E1000_STAT(m) FIELD_SIZEOF(struct e1000_adapter, m), \
 		      offsetof(struct e1000_adapter, m)
 static const struct e1000_stats e1000_gstrings_stats[] = {
 	{ "rx_packets", E1000_STAT(stats.gprc) },
diff -puN drivers/net/ixgb/ixgb_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/net/ixgb/ixgb_ethtool.c
--- a/drivers/net/ixgb/ixgb_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/net/ixgb/ixgb_ethtool.c
@@ -52,7 +52,7 @@ struct ixgb_stats {
 	int stat_offset;
 };
 
-#define IXGB_STAT(m) sizeof(((struct ixgb_adapter *)0)->m), \
+#define IXGB_STAT(m) FIELD_SIZEOF(struct ixgb_adapter, m), \
 		      offsetof(struct ixgb_adapter, m)
 static struct ixgb_stats ixgb_gstrings_stats[] = {
 	{"rx_packets", IXGB_STAT(net_stats.rx_packets)},
diff -puN drivers/net/mv643xx_eth.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/net/mv643xx_eth.c
@@ -2652,7 +2652,7 @@ struct mv643xx_stats {
 	int stat_offset;
 };
 
-#define MV643XX_STAT(m) sizeof(((struct mv643xx_private *)0)->m), \
+#define MV643XX_STAT(m) FIELD_SIZEOF(struct mv643xx_private, m), \
 					offsetof(struct mv643xx_private, m)
 
 static const struct mv643xx_stats mv643xx_gstrings_stats[] = {
diff -puN drivers/net/netxen/netxen_nic_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/net/netxen/netxen_nic_ethtool.c
--- a/drivers/net/netxen/netxen_nic_ethtool.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/net/netxen/netxen_nic_ethtool.c
@@ -50,7 +50,7 @@ struct netxen_nic_stats {
 	int stat_offset;
 };
 
-#define NETXEN_NIC_STAT(m) sizeof(((struct netxen_port *)0)->m), \
+#define NETXEN_NIC_STAT(m) FIELD_SIZEOF(struct netxen_port, m), \
 			offsetof(struct netxen_port, m)
 
 #define NETXEN_NIC_PORT_WINDOW 0x10000
diff -puN drivers/usb/atm/usbatm.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/usb/atm/usbatm.c
@@ -1332,7 +1332,7 @@ static int __init usbatm_usb_init(void)
 {
 	dbg("%s: driver version %s", __func__, DRIVER_VERSION);
 
-	if (sizeof(struct usbatm_control) > sizeof(((struct sk_buff *) 0)->cb)) {
+	if (sizeof(struct usbatm_control) > FIELD_SIZEOF(struct sk_buff, cb)) {
 		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
 		return -EIO;
 	}
diff -puN drivers/usb/net/cdc_ether.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/usb/net/cdc_ether.c
--- a/drivers/usb/net/cdc_ether.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/usb/net/cdc_ether.c
@@ -497,7 +497,7 @@ static struct usb_driver cdc_driver = {
 
 static int __init cdc_init(void)
 {
-	BUILD_BUG_ON((sizeof(((struct usbnet *)0)->data)
+	BUILD_BUG_ON((FIELD_SIZEOF(struct usbnet, data)
 			< sizeof(struct cdc_state)));
 
  	return usb_register(&cdc_driver);
diff -puN drivers/usb/net/usbnet.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/usb/net/usbnet.c
--- a/drivers/usb/net/usbnet.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/usb/net/usbnet.c
@@ -1283,7 +1283,7 @@ EXPORT_SYMBOL_GPL(usbnet_resume);
 static int __init usbnet_init(void)
 {
 	/* compiler should optimize this out */
-	BUILD_BUG_ON (sizeof (((struct sk_buff *)0)->cb)
+	BUILD_BUG_ON (FIELD_SIZEOF(struct sk_buff, cb)
 			< sizeof (struct skb_data));
 
 	random_ether_addr(node_id);
diff -puN drivers/usb/serial/io_usbvend.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof drivers/usb/serial/io_usbvend.h
--- a/drivers/usb/serial/io_usbvend.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/drivers/usb/serial/io_usbvend.h
@@ -507,10 +507,10 @@ struct edge_manuf_descriptor {
 
 #define MANUF_BOARD_REV_A		1	// First rev of 251+Netchip design
 
-#define	MANUF_SERNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->SerialNumber)
-#define	MANUF_ASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->AssemblyNumber)
-#define	MANUF_OEMASSYNUM_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->OemAssyNumber)
-#define	MANUF_MANUFDATE_LENGTH		sizeof(((struct edge_manuf_descriptor *)0)->ManufDate)
+#define	MANUF_SERNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, SerialNumber)
+#define	MANUF_ASSYNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, AssemblyNumber)
+#define	MANUF_OEMASSYNUM_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, OemAssyNumber)
+#define	MANUF_MANUFDATE_LENGTH		FIELD_SIZEOF(struct edge_manuf_descriptor, ManufDate)
 
 #define	MANUF_ION_CONFIG_DIAG_NO_LOOP	0x20	// As below but no ext loopback test
 #define	MANUF_ION_CONFIG_DIAG		0x40	// 930 based device: 1=Run h/w diags, 0=norm
diff -puN fs/ext2/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/fs/ext2/xattr.c
@@ -1024,7 +1024,7 @@ init_ext2_xattr(void)
 {
 	ext2_xattr_cache = mb_cache_create("ext2_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZEOF(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext2_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ext3/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/fs/ext3/xattr.c
@@ -1299,7 +1299,7 @@ init_ext3_xattr(void)
 {
 	ext3_xattr_cache = mb_cache_create("ext3_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZEOF(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext3_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ext4/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/fs/ext4/xattr.c
@@ -1299,7 +1299,7 @@ init_ext4_xattr(void)
 {
 	ext4_xattr_cache = mb_cache_create("ext4_xattr", NULL,
 		sizeof(struct mb_cache_entry) +
-		sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]), 1, 6);
+		FIELD_SIZEOF(struct mb_cache_entry, e_indexes[0]), 1, 6);
 	if (!ext4_xattr_cache)
 		return -ENOMEM;
 	return 0;
diff -puN fs/mbcache.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof fs/mbcache.c
--- a/fs/mbcache.c~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/fs/mbcache.c
@@ -255,7 +255,7 @@ mb_cache_create(const char *name, struct
 	struct mb_cache *cache = NULL;
 
 	if(entry_size < sizeof(struct mb_cache_entry) +
-	   indexes_count * sizeof(((struct mb_cache_entry *) 0)->e_indexes[0]))
+	   indexes_count * FIELD_SIZEOF(struct mb_cache_entry, e_indexes[0]))
 		return NULL;
 
 	cache = kmalloc(sizeof(struct mb_cache) +
diff -puN include/asm-powerpc/fs_pd.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof include/asm-powerpc/fs_pd.h
--- a/include/asm-powerpc/fs_pd.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/include/asm-powerpc/fs_pd.h
@@ -29,7 +29,7 @@ static inline int uart_clock(void)
 ({									\
 	u32 offset = offsetof(cpm2_map_t, member);			\
 	void *addr = ioremap (CPM_MAP_ADDR + offset,			\
-			      sizeof( ((cpm2_map_t*)0)->member));	\
+			      FIELD_SIZEOF(cpm2_map_t, member));	\
 	addr;								\
 })
 
diff -puN include/net/sctp/sctp.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h~rewrite-unnecessary-duplicated-code-to-use-field_sizeof
+++ a/include/net/sctp/sctp.h
@@ -601,7 +601,7 @@ static inline int param_type2af(__be16 t
 static inline int sctp_sanity_check(void)
 {
 	SCTP_ASSERT(sizeof(struct sctp_ulpevent) <=
-		    sizeof(((struct sk_buff *)0)->cb),
+		    FIELD_SIZEOF(struct sk_buff, cb),
 		    "SCTP: ulpevent does not fit in skb!\n", return 0);
 
 	return 1;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
git-alsa.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch

