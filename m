Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C54C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbhKXWVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:21:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243516AbhKXWVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90AFC60F55;
        Wed, 24 Nov 2021 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792314;
        bh=BHK01bJQjUWxR2/B8KOanLIkety1x3RFbKbo3q47JKI=;
        h=Date:From:To:Subject:From;
        b=2r0S/3fa7fc1pdUJ0kxzpAX5nBXTJtAkny5g0roc+9z/ue7g1ymAx5cwKoZvNUHVV
         8G1/5ux9ei+7WePmC19m1mUBTr22NPSgk3Oz31U6L+gedfXP1MmLtRSxmhcHhYijnG
         MwPsBjseGGdCkwv1UbFvIJj1JwJfP7U+4ffp9x7w=
Date:   Wed, 24 Nov 2021 14:18:34 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [to-be-updated]
 fs-proc-replace-pde_datainode-with-inode-i_private.patch removed from -mm
 tree
Message-ID: <20211124221834.BFprNnbrh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: replace PDE_DATA(inode) with inode->i_private
has been removed from the -mm tree.  Its filename was
     fs-proc-replace-pde_datainode-with-inode-i_private.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: proc: replace PDE_DATA(inode) with inode->i_private

Since the user can get their private data by inode->i_private, so replace
all PDE_DATA(inode) with inode->i_private.  Finally we can remove
PDE_DATA() completely.

Link: https://lkml.kernel.org/r/20211101093518.86845-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/srm_env.c                            |    4 -
 arch/arm/kernel/atags_proc.c                           |    2 
 arch/ia64/kernel/salinfo.c                             |   10 ++--
 arch/powerpc/kernel/proc_powerpc.c                     |    4 -
 arch/sh/mm/alignment.c                                 |    2 
 arch/xtensa/platforms/iss/simdisk.c                    |    4 -
 drivers/acpi/proc.c                                    |    2 
 drivers/hwmon/dell-smm-hwmon.c                         |    4 -
 drivers/net/bonding/bond_procfs.c                      |    8 +--
 drivers/net/wireless/cisco/airo.c                      |   22 ++++-----
 drivers/net/wireless/intersil/hostap/hostap_ap.c       |   16 +++---
 drivers/net/wireless/intersil/hostap/hostap_download.c |    2 
 drivers/net/wireless/intersil/hostap/hostap_proc.c     |   24 +++++-----
 drivers/net/wireless/ray_cs.c                          |    2 
 drivers/nubus/proc.c                                   |    2 
 drivers/parisc/led.c                                   |    4 -
 drivers/pci/proc.c                                     |   10 ++--
 drivers/platform/x86/thinkpad_acpi.c                   |    4 -
 drivers/platform/x86/toshiba_acpi.c                    |   16 +++---
 drivers/pnp/isapnp/proc.c                              |    2 
 drivers/pnp/pnpbios/proc.c                             |    4 -
 drivers/scsi/scsi_proc.c                               |    4 -
 drivers/usb/gadget/function/rndis.c                    |    4 -
 drivers/zorro/proc.c                                   |    2 
 fs/afs/proc.c                                          |    6 +-
 fs/ext4/mballoc.c                                      |   14 ++---
 fs/jbd2/journal.c                                      |    2 
 fs/proc/proc_net.c                                     |   12 ++---
 include/linux/seq_file.h                               |    2 
 ipc/util.c                                             |    2 
 kernel/irq/proc.c                                      |    8 +--
 kernel/resource.c                                      |    4 -
 net/atm/proc.c                                         |    4 -
 net/bluetooth/af_bluetooth.c                           |    8 +--
 net/can/bcm.c                                          |    2 
 net/can/proc.c                                         |    2 
 net/core/neighbour.c                                   |    6 +-
 net/core/pktgen.c                                      |    6 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                     |    6 +-
 net/ipv4/raw.c                                         |    8 +--
 net/ipv4/tcp_ipv4.c                                    |    2 
 net/ipv4/udp.c                                         |    6 +-
 net/netfilter/x_tables.c                               |   10 ++--
 net/netfilter/xt_hashlimit.c                           |   18 +++----
 net/netfilter/xt_recent.c                              |    4 -
 net/sunrpc/auth_gss/svcauth_gss.c                      |    4 -
 net/sunrpc/cache.c                                     |   24 +++++-----
 net/sunrpc/stats.c                                     |    2 
 sound/core/info.c                                      |    4 -
 49 files changed, 162 insertions(+), 162 deletions(-)

--- a/arch/alpha/kernel/srm_env.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/alpha/kernel/srm_env.c
@@ -83,14 +83,14 @@ static int srm_env_proc_show(struct seq_
 
 static int srm_env_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, srm_env_proc_show, PDE_DATA(inode));
+	return single_open(file, srm_env_proc_show, inode->i_private);
 }
 
 static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int res;
-	unsigned long	id = (unsigned long)PDE_DATA(file_inode(file));
+	unsigned long	id = (unsigned long)file_inode(file)->i_private;
 	char		*buf = (char *) __get_free_page(GFP_USER);
 	unsigned long	ret1, ret2;
 
--- a/arch/arm/kernel/atags_proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/arm/kernel/atags_proc.c
@@ -13,7 +13,7 @@ struct buffer {
 static ssize_t atags_read(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos)
 {
-	struct buffer *b = PDE_DATA(file_inode(file));
+	struct buffer *b = file_inode(file)->i_private;
 	return simple_read_from_buffer(buf, count, ppos, b->data, b->size);
 }
 
--- a/arch/ia64/kernel/salinfo.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/ia64/kernel/salinfo.c
@@ -282,7 +282,7 @@ salinfo_event_open(struct inode *inode,
 static ssize_t
 salinfo_event_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct salinfo_data *data = PDE_DATA(file_inode(file));
+	struct salinfo_data *data = file_inode(file)->i_private;
 	char cmd[32];
 	size_t size;
 	int i, n, cpu = -1;
@@ -340,7 +340,7 @@ static const struct proc_ops salinfo_eve
 static int
 salinfo_log_open(struct inode *inode, struct file *file)
 {
-	struct salinfo_data *data = PDE_DATA(inode);
+	struct salinfo_data *data = inode->i_private;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -365,7 +365,7 @@ salinfo_log_open(struct inode *inode, st
 static int
 salinfo_log_release(struct inode *inode, struct file *file)
 {
-	struct salinfo_data *data = PDE_DATA(inode);
+	struct salinfo_data *data = inode->i_private;
 
 	if (data->state == STATE_NO_DATA) {
 		vfree(data->log_buffer);
@@ -433,7 +433,7 @@ retry:
 static ssize_t
 salinfo_log_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct salinfo_data *data = PDE_DATA(file_inode(file));
+	struct salinfo_data *data = file_inode(file)->i_private;
 	u8 *buf;
 	u64 bufsize;
 
@@ -494,7 +494,7 @@ salinfo_log_clear(struct salinfo_data *d
 static ssize_t
 salinfo_log_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct salinfo_data *data = PDE_DATA(file_inode(file));
+	struct salinfo_data *data = file_inode(file)->i_private;
 	char cmd[32];
 	size_t size;
 	u32 offset;
--- a/arch/powerpc/kernel/proc_powerpc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/powerpc/kernel/proc_powerpc.c
@@ -25,7 +25,7 @@ static ssize_t page_map_read( struct fil
 			      loff_t *ppos)
 {
 	return simple_read_from_buffer(buf, nbytes, ppos,
-			PDE_DATA(file_inode(file)), PAGE_SIZE);
+			file_inode(file)->i_private, PAGE_SIZE);
 }
 
 static int page_map_mmap( struct file *file, struct vm_area_struct *vma )
@@ -34,7 +34,7 @@ static int page_map_mmap( struct file *f
 		return -EINVAL;
 
 	remap_pfn_range(vma, vma->vm_start,
-			__pa(PDE_DATA(file_inode(file))) >> PAGE_SHIFT,
+			__pa(file_inode(file)->i_private) >> PAGE_SHIFT,
 			PAGE_SIZE, vma->vm_page_prot);
 	return 0;
 }
--- a/arch/sh/mm/alignment.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/sh/mm/alignment.c
@@ -140,7 +140,7 @@ static int alignment_proc_open(struct in
 static ssize_t alignment_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
-	int *data = PDE_DATA(file_inode(file));
+	int *data = file_inode(file)->i_private;
 	char mode;
 
 	if (count > 0) {
--- a/arch/xtensa/platforms/iss/simdisk.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/arch/xtensa/platforms/iss/simdisk.c
@@ -208,7 +208,7 @@ static int simdisk_detach(struct simdisk
 static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 			size_t size, loff_t *ppos)
 {
-	struct simdisk *dev = PDE_DATA(file_inode(file));
+	struct simdisk *dev = file_inode(file)->i_private;
 	const char *s = dev->filename;
 	if (s) {
 		ssize_t n = simple_read_from_buffer(buf, size, ppos,
@@ -225,7 +225,7 @@ static ssize_t proc_write_simdisk(struct
 			size_t count, loff_t *ppos)
 {
 	char *tmp = memdup_user_nul(buf, count);
-	struct simdisk *dev = PDE_DATA(file_inode(file));
+	struct simdisk *dev = file_inode(file)->i_private;
 	int err;
 
 	if (IS_ERR(tmp))
--- a/drivers/acpi/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/acpi/proc.c
@@ -127,7 +127,7 @@ static int
 acpi_system_wakeup_device_open_fs(struct inode *inode, struct file *file)
 {
 	return single_open(file, acpi_system_wakeup_device_seq_show,
-			   PDE_DATA(inode));
+			   inode->i_private);
 }
 
 static const struct proc_ops acpi_system_wakeup_device_proc_ops = {
--- a/drivers/hwmon/dell-smm-hwmon.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/hwmon/dell-smm-hwmon.c
@@ -550,7 +550,7 @@ i8k_ioctl_unlocked(struct file *fp, stru
 
 static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
-	struct dell_smm_data *data = PDE_DATA(file_inode(fp));
+	struct dell_smm_data *data = file_inode(fp)->i_private;
 	long ret;
 
 	mutex_lock(&data->i8k_mutex);
@@ -607,7 +607,7 @@ static int i8k_proc_show(struct seq_file
 
 static int i8k_open_fs(struct inode *inode, struct file *file)
 {
-	return single_open(file, i8k_proc_show, PDE_DATA(inode));
+	return single_open(file, i8k_proc_show, inode->i_private);
 }
 
 static const struct proc_ops i8k_proc_ops = {
--- a/drivers/net/bonding/bond_procfs.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/bonding/bond_procfs.c
@@ -11,7 +11,7 @@
 static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
-	struct bonding *bond = PDE_DATA(file_inode(seq->file));
+	struct bonding *bond = file_inode(seq->file)->i_private;
 	struct list_head *iter;
 	struct slave *slave;
 	loff_t off = 0;
@@ -30,7 +30,7 @@ static void *bond_info_seq_start(struct
 
 static void *bond_info_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct bonding *bond = PDE_DATA(file_inode(seq->file));
+	struct bonding *bond = file_inode(seq->file)->i_private;
 	struct list_head *iter;
 	struct slave *slave;
 	bool found = false;
@@ -57,7 +57,7 @@ static void bond_info_seq_stop(struct se
 
 static void bond_info_show_master(struct seq_file *seq)
 {
-	struct bonding *bond = PDE_DATA(file_inode(seq->file));
+	struct bonding *bond = file_inode(seq->file)->i_private;
 	const struct bond_opt_value *optval;
 	struct slave *curr, *primary;
 	int i;
@@ -173,7 +173,7 @@ static void bond_info_show_master(struct
 static void bond_info_show_slave(struct seq_file *seq,
 				 const struct slave *slave)
 {
-	struct bonding *bond = PDE_DATA(file_inode(seq->file));
+	struct bonding *bond = file_inode(seq->file)->i_private;
 
 	seq_printf(seq, "\nSlave Interface: %s\n", slave->dev->name);
 	seq_printf(seq, "MII Status: %s\n", bond_slave_link_status(slave->link));
--- a/drivers/net/wireless/cisco/airo.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/wireless/cisco/airo.c
@@ -4672,7 +4672,7 @@ static ssize_t proc_write(struct file *f
 static int proc_status_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *apriv = dev->ml_priv;
 	CapabilityRid cap_rid;
 	StatusRid status_rid;
@@ -4756,7 +4756,7 @@ static int proc_stats_rid_open(struct in
 				u16 rid)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *apriv = dev->ml_priv;
 	StatsRid stats;
 	int i, j;
@@ -4819,7 +4819,7 @@ static inline int sniffing_mode(struct a
 static void proc_config_on_close(struct inode *inode, struct file *file)
 {
 	struct proc_data *data = file->private_data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	char *line;
 
@@ -5030,7 +5030,7 @@ static const char *get_rmode(__le16 mode
 static int proc_config_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	int i;
 	__le16 mode;
@@ -5120,7 +5120,7 @@ static int proc_config_open(struct inode
 static void proc_SSID_on_close(struct inode *inode, struct file *file)
 {
 	struct proc_data *data = file->private_data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	SsidRid SSID_rid;
 	int i;
@@ -5156,7 +5156,7 @@ static void proc_SSID_on_close(struct in
 static void proc_APList_on_close(struct inode *inode, struct file *file)
 {
 	struct proc_data *data = file->private_data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	APListRid *APList_rid = &ai->APList;
 	int i;
@@ -5280,7 +5280,7 @@ static int set_wep_tx_idx(struct airo_in
 static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	int i, rc;
 	char key[16];
@@ -5331,7 +5331,7 @@ static void proc_wepkey_on_close(struct
 static int proc_wepkey_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	char *ptr;
 	WepKeyRid wkr;
@@ -5379,7 +5379,7 @@ static int proc_wepkey_open(struct inode
 static int proc_SSID_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	int i;
 	char *ptr;
@@ -5423,7 +5423,7 @@ static int proc_SSID_open(struct inode *
 static int proc_APList_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	int i;
 	char *ptr;
@@ -5462,7 +5462,7 @@ static int proc_APList_open(struct inode
 static int proc_BSSList_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
-	struct net_device *dev = PDE_DATA(inode);
+	struct net_device *dev = inode->i_private;
 	struct airo_info *ai = dev->ml_priv;
 	char *ptr;
 	BSSListRid BSSList_rid;
--- a/drivers/net/wireless/intersil/hostap/hostap_ap.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -69,7 +69,7 @@ static void prism2_send_mgmt(struct net_
 #if !defined(PRISM2_NO_PROCFS_DEBUG) && defined(CONFIG_PROC_FS)
 static int ap_debug_proc_show(struct seq_file *m, void *v)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 
 	seq_printf(m, "BridgedUnicastFrames=%u\n", ap->bridged_unicast);
 	seq_printf(m, "BridgedMulticastFrames=%u\n", ap->bridged_multicast);
@@ -320,7 +320,7 @@ void hostap_deauth_all_stas(struct net_d
 
 static int ap_control_proc_show(struct seq_file *m, void *v)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	char *policy_txt;
 	struct mac_entry *entry;
 
@@ -352,20 +352,20 @@ static int ap_control_proc_show(struct s
 
 static void *ap_control_proc_start(struct seq_file *m, loff_t *_pos)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	spin_lock_bh(&ap->mac_restrictions.lock);
 	return seq_list_start_head(&ap->mac_restrictions.mac_list, *_pos);
 }
 
 static void *ap_control_proc_next(struct seq_file *m, void *v, loff_t *_pos)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	return seq_list_next(v, &ap->mac_restrictions.mac_list, _pos);
 }
 
 static void ap_control_proc_stop(struct seq_file *m, void *v)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	spin_unlock_bh(&ap->mac_restrictions.lock);
 }
 
@@ -554,20 +554,20 @@ static int prism2_ap_proc_show(struct se
 
 static void *prism2_ap_proc_start(struct seq_file *m, loff_t *_pos)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	spin_lock_bh(&ap->sta_table_lock);
 	return seq_list_start_head(&ap->sta_list, *_pos);
 }
 
 static void *prism2_ap_proc_next(struct seq_file *m, void *v, loff_t *_pos)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	return seq_list_next(v, &ap->sta_list, _pos);
 }
 
 static void prism2_ap_proc_stop(struct seq_file *m, void *v)
 {
-	struct ap_data *ap = PDE_DATA(file_inode(m->file));
+	struct ap_data *ap = file_inode(m->file)->i_private;
 	spin_unlock_bh(&ap->sta_table_lock);
 }
 
--- a/drivers/net/wireless/intersil/hostap/hostap_download.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/wireless/intersil/hostap/hostap_download.c
@@ -227,7 +227,7 @@ static int prism2_download_aux_dump_proc
 				   sizeof(struct prism2_download_aux_dump));
 	if (ret == 0) {
 		struct seq_file *m = file->private_data;
-		m->private = PDE_DATA(inode);
+		m->private = inode->i_private;
 	}
 	return ret;
 }
--- a/drivers/net/wireless/intersil/hostap/hostap_proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -97,20 +97,20 @@ static int prism2_wds_proc_show(struct s
 
 static void *prism2_wds_proc_start(struct seq_file *m, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	read_lock_bh(&local->iface_lock);
 	return seq_list_start(&local->hostap_interfaces, *_pos);
 }
 
 static void *prism2_wds_proc_next(struct seq_file *m, void *v, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	return seq_list_next(v, &local->hostap_interfaces, _pos);
 }
 
 static void prism2_wds_proc_stop(struct seq_file *m, void *v)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	read_unlock_bh(&local->iface_lock);
 }
 
@@ -123,7 +123,7 @@ static const struct seq_operations prism
 
 static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	struct list_head *ptr = v;
 	struct hostap_bss_info *bss;
 
@@ -151,21 +151,21 @@ static int prism2_bss_list_proc_show(str
 static void *prism2_bss_list_proc_start(struct seq_file *m, loff_t *_pos)
 	__acquires(&local->lock)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	spin_lock_bh(&local->lock);
 	return seq_list_start_head(&local->bss_list, *_pos);
 }
 
 static void *prism2_bss_list_proc_next(struct seq_file *m, void *v, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	return seq_list_next(v, &local->bss_list, _pos);
 }
 
 static void prism2_bss_list_proc_stop(struct seq_file *m, void *v)
 	__releases(&local->lock)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	spin_unlock_bh(&local->lock);
 }
 
@@ -198,7 +198,7 @@ static int prism2_crypt_proc_show(struct
 static ssize_t prism2_pda_proc_read(struct file *file, char __user *buf,
 				    size_t count, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(file));
+	local_info_t *local = file_inode(file)->i_private;
 	size_t off;
 
 	if (local->pda == NULL || *_pos >= PRISM2_PDA_SIZE)
@@ -272,7 +272,7 @@ static int prism2_io_debug_proc_read(cha
 #ifndef PRISM2_NO_STATION_MODES
 static int prism2_scan_results_proc_show(struct seq_file *m, void *v)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	unsigned long entry;
 	int i, len;
 	struct hfa384x_hostscan_result *scanres;
@@ -322,7 +322,7 @@ static int prism2_scan_results_proc_show
 
 static void *prism2_scan_results_proc_start(struct seq_file *m, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	spin_lock_bh(&local->lock);
 
 	/* We have a header (pos 0) + N results to show (pos 1...N) */
@@ -333,7 +333,7 @@ static void *prism2_scan_results_proc_st
 
 static void *prism2_scan_results_proc_next(struct seq_file *m, void *v, loff_t *_pos)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 
 	++*_pos;
 	if (*_pos > local->last_scan_results_count)
@@ -343,7 +343,7 @@ static void *prism2_scan_results_proc_ne
 
 static void prism2_scan_results_proc_stop(struct seq_file *m, void *v)
 {
-	local_info_t *local = PDE_DATA(file_inode(m->file));
+	local_info_t *local = file_inode(m->file)->i_private;
 	spin_unlock_bh(&local->lock);
 }
 
--- a/drivers/net/wireless/ray_cs.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/net/wireless/ray_cs.c
@@ -2746,7 +2746,7 @@ static ssize_t int_proc_write(struct fil
 		nr = nr * 10 + c;
 		p++;
 	} while (--len);
-	*(int *)PDE_DATA(file_inode(file)) = nr;
+	*(int *)file_inode(file)->i_private = nr;
 	return count;
 }
 
--- a/drivers/nubus/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/nubus/proc.c
@@ -109,7 +109,7 @@ static int nubus_proc_rsrc_show(struct s
 	struct inode *inode = m->private;
 	struct nubus_proc_pde_data *pde_data;
 
-	pde_data = PDE_DATA(inode);
+	pde_data = inode->i_private;
 	if (!pde_data)
 		return 0;
 
--- a/drivers/parisc/led.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/parisc/led.c
@@ -168,14 +168,14 @@ static int led_proc_show(struct seq_file
 
 static int led_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, led_proc_show, PDE_DATA(inode));
+	return single_open(file, led_proc_show, inode->i_private);
 }
 
 
 static ssize_t led_proc_write(struct file *file, const char __user *buf,
 	size_t count, loff_t *pos)
 {
-	void *data = PDE_DATA(file_inode(file));
+	void *data = file_inode(file)->i_private;
 	char *cur, lbuf[32];
 	int d;
 
--- a/drivers/pci/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/pci/proc.c
@@ -21,14 +21,14 @@ static int proc_initialized;	/* = 0 */
 
 static loff_t proc_bus_pci_lseek(struct file *file, loff_t off, int whence)
 {
-	struct pci_dev *dev = PDE_DATA(file_inode(file));
+	struct pci_dev *dev = file_inode(file)->i_private;
 	return fixed_size_llseek(file, off, whence, dev->cfg_size);
 }
 
 static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 				 size_t nbytes, loff_t *ppos)
 {
-	struct pci_dev *dev = PDE_DATA(file_inode(file));
+	struct pci_dev *dev = file_inode(file)->i_private;
 	unsigned int pos = *ppos;
 	unsigned int cnt, size;
 
@@ -114,7 +114,7 @@ static ssize_t proc_bus_pci_write(struct
 				  size_t nbytes, loff_t *ppos)
 {
 	struct inode *ino = file_inode(file);
-	struct pci_dev *dev = PDE_DATA(ino);
+	struct pci_dev *dev = ino->i_private;
 	int pos = *ppos;
 	int size = dev->cfg_size;
 	int cnt, ret;
@@ -196,7 +196,7 @@ struct pci_filp_private {
 static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 			       unsigned long arg)
 {
-	struct pci_dev *dev = PDE_DATA(file_inode(file));
+	struct pci_dev *dev = file_inode(file)->i_private;
 #ifdef HAVE_PCI_MMAP
 	struct pci_filp_private *fpriv = file->private_data;
 #endif /* HAVE_PCI_MMAP */
@@ -244,7 +244,7 @@ static long proc_bus_pci_ioctl(struct fi
 #ifdef HAVE_PCI_MMAP
 static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct pci_dev *dev = PDE_DATA(file_inode(file));
+	struct pci_dev *dev = file_inode(file)->i_private;
 	struct pci_filp_private *fpriv = file->private_data;
 	int i, ret, write_combine = 0, res_bit = IORESOURCE_MEM;
 
--- a/drivers/platform/x86/thinkpad_acpi.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -881,14 +881,14 @@ static int dispatch_proc_show(struct seq
 
 static int dispatch_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, dispatch_proc_show, PDE_DATA(inode));
+	return single_open(file, dispatch_proc_show, inode->i_private);
 }
 
 static ssize_t dispatch_proc_write(struct file *file,
 			const char __user *userbuf,
 			size_t count, loff_t *pos)
 {
-	struct ibm_struct *ibm = PDE_DATA(file_inode(file));
+	struct ibm_struct *ibm = file_inode(file)->i_private;
 	char *kernbuf;
 	int ret;
 
--- a/drivers/platform/x86/toshiba_acpi.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -1368,7 +1368,7 @@ static int lcd_proc_show(struct seq_file
 
 static int lcd_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, lcd_proc_show, PDE_DATA(inode));
+	return single_open(file, lcd_proc_show, inode->i_private);
 }
 
 static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
@@ -1404,7 +1404,7 @@ static int set_lcd_status(struct backlig
 static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 			      size_t count, loff_t *pos)
 {
-	struct toshiba_acpi_dev *dev = PDE_DATA(file_inode(file));
+	struct toshiba_acpi_dev *dev = file_inode(file)->i_private;
 	char cmd[42];
 	size_t len;
 	int levels;
@@ -1469,13 +1469,13 @@ static int video_proc_show(struct seq_fi
 
 static int video_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, video_proc_show, PDE_DATA(inode));
+	return single_open(file, video_proc_show, inode->i_private);
 }
 
 static ssize_t video_proc_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *pos)
 {
-	struct toshiba_acpi_dev *dev = PDE_DATA(file_inode(file));
+	struct toshiba_acpi_dev *dev = file_inode(file)->i_private;
 	char *buffer;
 	char *cmd;
 	int lcd_out = -1, crt_out = -1, tv_out = -1;
@@ -1580,13 +1580,13 @@ static int fan_proc_show(struct seq_file
 
 static int fan_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, fan_proc_show, PDE_DATA(inode));
+	return single_open(file, fan_proc_show, inode->i_private);
 }
 
 static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 			      size_t count, loff_t *pos)
 {
-	struct toshiba_acpi_dev *dev = PDE_DATA(file_inode(file));
+	struct toshiba_acpi_dev *dev = file_inode(file)->i_private;
 	char cmd[42];
 	size_t len;
 	int value;
@@ -1628,13 +1628,13 @@ static int keys_proc_show(struct seq_fil
 
 static int keys_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, keys_proc_show, PDE_DATA(inode));
+	return single_open(file, keys_proc_show, inode->i_private);
 }
 
 static ssize_t keys_proc_write(struct file *file, const char __user *buf,
 			       size_t count, loff_t *pos)
 {
-	struct toshiba_acpi_dev *dev = PDE_DATA(file_inode(file));
+	struct toshiba_acpi_dev *dev = file_inode(file)->i_private;
 	char cmd[42];
 	size_t len;
 	int value;
--- a/drivers/pnp/isapnp/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/pnp/isapnp/proc.c
@@ -22,7 +22,7 @@ static loff_t isapnp_proc_bus_lseek(stru
 static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 				    size_t nbytes, loff_t * ppos)
 {
-	struct pnp_dev *dev = PDE_DATA(file_inode(file));
+	struct pnp_dev *dev = file_inode(file)->i_private;
 	int pos = *ppos;
 	int cnt, size = 256;
 
--- a/drivers/pnp/pnpbios/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/pnp/pnpbios/proc.c
@@ -173,13 +173,13 @@ static int pnpbios_proc_show(struct seq_
 
 static int pnpbios_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, pnpbios_proc_show, PDE_DATA(inode));
+	return single_open(file, pnpbios_proc_show, inode->i_private);
 }
 
 static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
 				  size_t count, loff_t *pos)
 {
-	void *data = PDE_DATA(file_inode(file));
+	void *data = file_inode(file)->i_private;
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
 	u8 nodenum = (long)data;
--- a/drivers/scsi/scsi_proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/scsi/scsi_proc.c
@@ -49,7 +49,7 @@ static DEFINE_MUTEX(global_host_template
 static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
                            size_t count, loff_t *ppos)
 {
-	struct Scsi_Host *shost = PDE_DATA(file_inode(file));
+	struct Scsi_Host *shost = file_inode(file)->i_private;
 	ssize_t ret = -ENOMEM;
 	char *page;
     
@@ -79,7 +79,7 @@ static int proc_scsi_show(struct seq_fil
 
 static int proc_scsi_host_open(struct inode *inode, struct file *file)
 {
-	return single_open_size(file, proc_scsi_show, PDE_DATA(inode),
+	return single_open_size(file, proc_scsi_show, inode->i_private,
 				4 * PAGE_SIZE);
 }
 
--- a/drivers/usb/gadget/function/rndis.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/usb/gadget/function/rndis.c
@@ -1117,7 +1117,7 @@ static int rndis_proc_show(struct seq_fi
 static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
-	rndis_params *p = PDE_DATA(file_inode(file));
+	rndis_params *p = file_inode(file)->i_private;
 	u32 speed = 0;
 	int i, fl_speed = 0;
 
@@ -1161,7 +1161,7 @@ static ssize_t rndis_proc_write(struct f
 
 static int rndis_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, rndis_proc_show, PDE_DATA(inode));
+	return single_open(file, rndis_proc_show, inode->i_private);
 }
 
 static const struct proc_ops rndis_proc_ops = {
--- a/drivers/zorro/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/drivers/zorro/proc.c
@@ -30,7 +30,7 @@ proc_bus_zorro_lseek(struct file *file,
 static ssize_t
 proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	struct zorro_dev *z = PDE_DATA(file_inode(file));
+	struct zorro_dev *z = file_inode(file)->i_private;
 	struct ConfigDev cd;
 	loff_t pos = *ppos;
 
--- a/fs/afs/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/fs/afs/proc.c
@@ -227,7 +227,7 @@ static int afs_proc_cell_volumes_show(st
 static void *afs_proc_cell_volumes_start(struct seq_file *m, loff_t *_pos)
 	__acquires(cell->proc_lock)
 {
-	struct afs_cell *cell = PDE_DATA(file_inode(m->file));
+	struct afs_cell *cell = file_inode(m->file)->i_private;
 
 	rcu_read_lock();
 	return seq_hlist_start_head_rcu(&cell->proc_volumes, *_pos);
@@ -236,7 +236,7 @@ static void *afs_proc_cell_volumes_start
 static void *afs_proc_cell_volumes_next(struct seq_file *m, void *v,
 					loff_t *_pos)
 {
-	struct afs_cell *cell = PDE_DATA(file_inode(m->file));
+	struct afs_cell *cell = file_inode(m->file)->i_private;
 
 	return seq_hlist_next_rcu(v, &cell->proc_volumes, _pos);
 }
@@ -322,7 +322,7 @@ static void *afs_proc_cell_vlservers_sta
 {
 	struct afs_vl_seq_net_private *priv = m->private;
 	struct afs_vlserver_list *vllist;
-	struct afs_cell *cell = PDE_DATA(file_inode(m->file));
+	struct afs_cell *cell = file_inode(m->file)->i_private;
 	loff_t pos = *_pos;
 
 	rcu_read_lock();
--- a/fs/ext4/mballoc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/fs/ext4/mballoc.c
@@ -2834,7 +2834,7 @@ out:
 
 static void *ext4_mb_seq_groups_start(struct seq_file *seq, loff_t *pos)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	ext4_group_t group;
 
 	if (*pos < 0 || *pos >= ext4_get_groups_count(sb))
@@ -2845,7 +2845,7 @@ static void *ext4_mb_seq_groups_start(st
 
 static void *ext4_mb_seq_groups_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	ext4_group_t group;
 
 	++*pos;
@@ -2857,7 +2857,7 @@ static void *ext4_mb_seq_groups_next(str
 
 static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	ext4_group_t group = (ext4_group_t) ((unsigned long) v);
 	int i;
 	int err, buddy_loaded = 0;
@@ -2985,7 +2985,7 @@ int ext4_seq_mb_stats_show(struct seq_fi
 static void *ext4_mb_seq_structs_summary_start(struct seq_file *seq, loff_t *pos)
 __acquires(&EXT4_SB(sb)->s_mb_rb_lock)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	unsigned long position;
 
 	read_lock(&EXT4_SB(sb)->s_mb_rb_lock);
@@ -2998,7 +2998,7 @@ __acquires(&EXT4_SB(sb)->s_mb_rb_lock)
 
 static void *ext4_mb_seq_structs_summary_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	unsigned long position;
 
 	++*pos;
@@ -3010,7 +3010,7 @@ static void *ext4_mb_seq_structs_summary
 
 static int ext4_mb_seq_structs_summary_show(struct seq_file *seq, void *v)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long position = ((unsigned long) v);
 	struct ext4_group_info *grp;
@@ -3058,7 +3058,7 @@ static int ext4_mb_seq_structs_summary_s
 static void ext4_mb_seq_structs_summary_stop(struct seq_file *seq, void *v)
 __releases(&EXT4_SB(sb)->s_mb_rb_lock)
 {
-	struct super_block *sb = PDE_DATA(file_inode(seq->file));
+	struct super_block *sb = file_inode(seq->file)->i_private;
 
 	read_unlock(&EXT4_SB(sb)->s_mb_rb_lock);
 }
--- a/fs/jbd2/journal.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/fs/jbd2/journal.c
@@ -1210,7 +1210,7 @@ static const struct seq_operations jbd2_
 
 static int jbd2_seq_info_open(struct inode *inode, struct file *file)
 {
-	journal_t *journal = PDE_DATA(inode);
+	journal_t *journal = inode->i_private;
 	struct jbd2_stats_proc_session *s;
 	int rc, size;
 
--- a/fs/proc/proc_net.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/fs/proc/proc_net.c
@@ -125,7 +125,7 @@ EXPORT_SYMBOL_GPL(proc_create_net_data);
  * @parent: The parent directory in which to create.
  * @ops: The seq_file ops with which to read the file.
  * @write: The write method with which to 'modify' the file.
- * @data: Data for retrieval by PDE_DATA().
+ * @data: Data for retrieval by inode->i_private.
  *
  * Create a network namespaced proc file in the @parent directory with the
  * specified @name and @mode that allows reading of a file that displays a
@@ -139,8 +139,8 @@ EXPORT_SYMBOL_GPL(proc_create_net_data);
  * scratch buffer and has a NUL appended for convenience.  The buffer may be
  * modified by the @write function.  @write should return 0 on success.
  *
- * The @data value is accessible from the @show and @write functions by calling
- * PDE_DATA() on the file inode.  The network namespace must be accessed by
+ * The @data value is accessible from the @show and @write functions by accessing
+ * ->i_private of the file inode.  The network namespace must be accessed by
  * calling seq_file_net() on the seq_file struct.
  */
 struct proc_dir_entry *proc_create_net_data_write(const char *name, umode_t mode,
@@ -217,7 +217,7 @@ EXPORT_SYMBOL_GPL(proc_create_net_single
  * @parent: The parent directory in which to create.
  * @show: The seqfile show method with which to read the file.
  * @write: The write method with which to 'modify' the file.
- * @data: Data for retrieval by PDE_DATA().
+ * @data: Data for retrieval by inode->i_private.
  *
  * Create a network-namespaced proc file in the @parent directory with the
  * specified @name and @mode that allows reading of a file that displays a
@@ -231,8 +231,8 @@ EXPORT_SYMBOL_GPL(proc_create_net_single
  * scratch buffer and has a NUL appended for convenience.  The buffer may be
  * modified by the @write function.  @write should return 0 on success.
  *
- * The @data value is accessible from the @show and @write functions by calling
- * PDE_DATA() on the file inode.  The network namespace must be accessed by
+ * The @data value is accessible from the @show and @write functions by accessing
+ * ->i_private of the file inode.  The network namespace must be accessed by
  * calling seq_file_single_net() on the seq_file struct.
  */
 struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mode,
--- a/include/linux/seq_file.h~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/include/linux/seq_file.h
@@ -209,7 +209,7 @@ static const struct file_operations __na
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
 static int __name ## _open(struct inode *inode, struct file *file)	\
 {									\
-	return single_open(file, __name ## _show, PDE_DATA(inode));	\
+	return single_open(file, __name ## _show, inode->i_private);	\
 }									\
 									\
 static const struct proc_ops __name ## _proc_ops = {			\
--- a/ipc/util.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/ipc/util.c
@@ -894,7 +894,7 @@ static int sysvipc_proc_open(struct inod
 	if (!iter)
 		return -ENOMEM;
 
-	iter->iface = PDE_DATA(inode);
+	iter->iface = inode->i_private;
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
 	iter->pid_ns = get_pid_ns(task_active_pid_ns(current));
 
--- a/kernel/irq/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/kernel/irq/proc.c
@@ -137,7 +137,7 @@ static inline int irq_select_affinity_us
 static ssize_t write_irq_affinity(int type, struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
-	unsigned int irq = (int)(long)PDE_DATA(file_inode(file));
+	unsigned int irq = (int)(long)file_inode(file)->i_private;
 	cpumask_var_t new_value;
 	int err;
 
@@ -190,12 +190,12 @@ static ssize_t irq_affinity_list_proc_wr
 
 static int irq_affinity_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_affinity_proc_show, PDE_DATA(inode));
+	return single_open(file, irq_affinity_proc_show, inode->i_private);
 }
 
 static int irq_affinity_list_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_affinity_list_proc_show, PDE_DATA(inode));
+	return single_open(file, irq_affinity_list_proc_show, inode->i_private);
 }
 
 static const struct proc_ops irq_affinity_proc_ops = {
@@ -265,7 +265,7 @@ out:
 
 static int default_affinity_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, default_affinity_show, PDE_DATA(inode));
+	return single_open(file, default_affinity_show, inode->i_private);
 }
 
 static const struct proc_ops default_affinity_proc_ops = {
--- a/kernel/resource.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/kernel/resource.c
@@ -99,7 +99,7 @@ enum { MAX_IORES_LEVEL = 5 };
 static void *r_start(struct seq_file *m, loff_t *pos)
 	__acquires(resource_lock)
 {
-	struct resource *p = PDE_DATA(file_inode(m->file));
+	struct resource *p = file_inode(m->file)->i_private;
 	loff_t l = 0;
 	read_lock(&resource_lock);
 	for (p = p->child; p && l < *pos; p = r_next(m, p, &l))
@@ -115,7 +115,7 @@ static void r_stop(struct seq_file *m, v
 
 static int r_show(struct seq_file *m, void *v)
 {
-	struct resource *root = PDE_DATA(file_inode(m->file));
+	struct resource *root = file_inode(m->file)->i_private;
 	struct resource *r = v, *p;
 	unsigned long long start, end;
 	int width = root->end < 0x10000 ? 4 : 8;
--- a/net/atm/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/atm/proc.c
@@ -108,7 +108,7 @@ out:
 static inline void *vcc_walk(struct seq_file *seq, loff_t l)
 {
 	struct vcc_state *state = seq->private;
-	int family = (uintptr_t)(PDE_DATA(file_inode(seq->file)));
+	int family = (uintptr_t)(file_inode(seq->file)->i_private);
 
 	return __vcc_walk(&state->sk, family, &state->bucket, l) ?
 	       state : NULL;
@@ -324,7 +324,7 @@ static ssize_t proc_dev_atm_read(struct
 	page = get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
-	dev = PDE_DATA(file_inode(file));
+	dev = file_inode(file)->i_private;
 	if (!dev->ops->proc_read)
 		length = -EINVAL;
 	else {
--- a/net/bluetooth/af_bluetooth.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/bluetooth/af_bluetooth.c
@@ -611,7 +611,7 @@ EXPORT_SYMBOL(bt_sock_wait_ready);
 static void *bt_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(seq->private->l->lock)
 {
-	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
+	struct bt_sock_list *l = file_inode(seq->file)->i_private;
 
 	read_lock(&l->lock);
 	return seq_hlist_start_head(&l->head, *pos);
@@ -619,7 +619,7 @@ static void *bt_seq_start(struct seq_fil
 
 static void *bt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
+	struct bt_sock_list *l = file_inode(seq->file)->i_private;
 
 	return seq_hlist_next(v, &l->head, pos);
 }
@@ -627,14 +627,14 @@ static void *bt_seq_next(struct seq_file
 static void bt_seq_stop(struct seq_file *seq, void *v)
 	__releases(seq->private->l->lock)
 {
-	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
+	struct bt_sock_list *l = file_inode(seq->file)->i_private;
 
 	read_unlock(&l->lock);
 }
 
 static int bt_seq_show(struct seq_file *seq, void *v)
 {
-	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
+	struct bt_sock_list *l = file_inode(seq->file)->i_private;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, "sk               RefCnt Rmem   Wmem   User   Inode  Parent");
--- a/net/can/bcm.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/can/bcm.c
@@ -193,7 +193,7 @@ static int bcm_proc_show(struct seq_file
 {
 	char ifname[IFNAMSIZ];
 	struct net *net = m->private;
-	struct sock *sk = (struct sock *)PDE_DATA(m->file->f_inode);
+	struct sock *sk = m->file->f_inode->i_private;
 	struct bcm_sock *bo = bcm_sk(sk);
 	struct bcm_op *op;
 
--- a/net/can/proc.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/can/proc.c
@@ -305,7 +305,7 @@ static inline void can_rcvlist_proc_show
 static int can_rcvlist_proc_show(struct seq_file *m, void *v)
 {
 	/* double cast to prevent GCC warning */
-	int idx = (int)(long)PDE_DATA(m->file->f_inode);
+	int idx = (int)(long)(m->file->f_inode->i_private);
 	struct net_device *dev;
 	struct can_dev_rcv_lists *dev_rcv_lists;
 	struct net *net = m->private;
--- a/net/core/neighbour.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/core/neighbour.c
@@ -3365,7 +3365,7 @@ EXPORT_SYMBOL(neigh_seq_stop);
 
 static void *neigh_stat_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
+	struct neigh_table *tbl = file_inode(seq->file)->i_private;
 	int cpu;
 
 	if (*pos == 0)
@@ -3382,7 +3382,7 @@ static void *neigh_stat_seq_start(struct
 
 static void *neigh_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
+	struct neigh_table *tbl = file_inode(seq->file)->i_private;
 	int cpu;
 
 	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
@@ -3402,7 +3402,7 @@ static void neigh_stat_seq_stop(struct s
 
 static int neigh_stat_seq_show(struct seq_file *seq, void *v)
 {
-	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
+	struct neigh_table *tbl = file_inode(seq->file)->i_private;
 	struct neigh_statistics *st = v;
 
 	if (v == SEQ_START_TOKEN) {
--- a/net/core/pktgen.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/core/pktgen.c
@@ -545,7 +545,7 @@ static ssize_t pgctrl_write(struct file
 
 static int pgctrl_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, pgctrl_show, PDE_DATA(inode));
+	return single_open(file, pgctrl_show, inode->i_private);
 }
 
 static const struct proc_ops pktgen_proc_ops = {
@@ -1810,7 +1810,7 @@ static ssize_t pktgen_if_write(struct fi
 
 static int pktgen_if_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, pktgen_if_show, PDE_DATA(inode));
+	return single_open(file, pktgen_if_show, inode->i_private);
 }
 
 static const struct proc_ops pktgen_if_proc_ops = {
@@ -1947,7 +1947,7 @@ out:
 
 static int pktgen_thread_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, pktgen_thread_show, PDE_DATA(inode));
+	return single_open(file, pktgen_thread_show, inode->i_private);
 }
 
 static const struct proc_ops pktgen_thread_proc_ops = {
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -773,7 +773,7 @@ static int clusterip_proc_open(struct in
 
 	if (!ret) {
 		struct seq_file *sf = file->private_data;
-		struct clusterip_config *c = PDE_DATA(inode);
+		struct clusterip_config *c = inode->i_private;
 
 		sf->private = c;
 
@@ -785,7 +785,7 @@ static int clusterip_proc_open(struct in
 
 static int clusterip_proc_release(struct inode *inode, struct file *file)
 {
-	struct clusterip_config *c = PDE_DATA(inode);
+	struct clusterip_config *c = inode->i_private;
 	int ret;
 
 	ret = seq_release(inode, file);
@@ -799,7 +799,7 @@ static int clusterip_proc_release(struct
 static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 				size_t size, loff_t *ofs)
 {
-	struct clusterip_config *c = PDE_DATA(file_inode(file));
+	struct clusterip_config *c = file_inode(file)->i_private;
 #define PROC_WRITELEN	10
 	char buffer[PROC_WRITELEN+1];
 	unsigned long nodenum;
--- a/net/ipv4/raw.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/ipv4/raw.c
@@ -971,7 +971,7 @@ struct proto raw_prot = {
 static struct sock *raw_get_first(struct seq_file *seq)
 {
 	struct sock *sk;
-	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
+	struct raw_hashinfo *h = file_inode(seq->file)->i_private;
 	struct raw_iter_state *state = raw_seq_private(seq);
 
 	for (state->bucket = 0; state->bucket < RAW_HTABLE_SIZE;
@@ -987,7 +987,7 @@ found:
 
 static struct sock *raw_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
+	struct raw_hashinfo *h = file_inode(seq->file)->i_private;
 	struct raw_iter_state *state = raw_seq_private(seq);
 
 	do {
@@ -1016,7 +1016,7 @@ static struct sock *raw_get_idx(struct s
 void *raw_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(&h->lock)
 {
-	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
+	struct raw_hashinfo *h = file_inode(seq->file)->i_private;
 
 	read_lock(&h->lock);
 	return *pos ? raw_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
@@ -1039,7 +1039,7 @@ EXPORT_SYMBOL_GPL(raw_seq_next);
 void raw_seq_stop(struct seq_file *seq, void *v)
 	__releases(&h->lock)
 {
-	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
+	struct raw_hashinfo *h = file_inode(seq->file)->i_private;
 
 	read_unlock(&h->lock);
 }
--- a/net/ipv4/tcp_ipv4.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/ipv4/tcp_ipv4.c
@@ -2991,7 +2991,7 @@ static unsigned short seq_file_family(co
 #endif
 
 	/* Iterated from proc fs */
-	afinfo = PDE_DATA(file_inode(seq->file));
+	afinfo = file_inode(seq->file)->i_private;
 	return afinfo->family;
 }
 
--- a/net/ipv4/udp.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/ipv4/udp.c
@@ -2952,7 +2952,7 @@ static struct sock *udp_get_first(struct
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
 	else
-		afinfo = PDE_DATA(file_inode(seq->file));
+		afinfo = file_inode(seq->file)->i_private;
 
 	for (state->bucket = start; state->bucket <= afinfo->udp_table->mask;
 	     ++state->bucket) {
@@ -2985,7 +2985,7 @@ static struct sock *udp_get_next(struct
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
 	else
-		afinfo = PDE_DATA(file_inode(seq->file));
+		afinfo = file_inode(seq->file)->i_private;
 
 	do {
 		sk = sk_next(sk);
@@ -3042,7 +3042,7 @@ void udp_seq_stop(struct seq_file *seq,
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
 	else
-		afinfo = PDE_DATA(file_inode(seq->file));
+		afinfo = file_inode(seq->file)->i_private;
 
 	if (state->bucket <= afinfo->udp_table->mask)
 		spin_unlock_bh(&afinfo->udp_table->hash[state->bucket].lock);
--- a/net/netfilter/x_tables.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/netfilter/x_tables.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
 #ifdef CONFIG_PROC_FS
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	u8 af = (unsigned long)PDE_DATA(file_inode(seq->file));
+	u8 af = (unsigned long)file_inode(seq->file)->i_private;
 	struct net *net = seq_file_net(seq);
 	struct xt_pernet *xt_net;
 
@@ -1529,7 +1529,7 @@ static void *xt_table_seq_start(struct s
 
 static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	u8 af = (unsigned long)PDE_DATA(file_inode(seq->file));
+	u8 af = (unsigned long)file_inode(seq->file)->i_private;
 	struct net *net = seq_file_net(seq);
 	struct xt_pernet *xt_net;
 
@@ -1540,7 +1540,7 @@ static void *xt_table_seq_next(struct se
 
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
-	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
+	u_int8_t af = (unsigned long)file_inode(seq->file)->i_private;
 
 	mutex_unlock(&xt[af].mutex);
 }
@@ -1584,7 +1584,7 @@ static void *xt_mttg_seq_next(struct seq
 		[MTTG_TRAV_NFP_UNSPEC] = MTTG_TRAV_NFP_SPEC,
 		[MTTG_TRAV_NFP_SPEC]   = MTTG_TRAV_DONE,
 	};
-	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
+	uint8_t nfproto = (unsigned long)file_inode(seq->file)->i_private;
 	struct nf_mttg_trav *trav = seq->private;
 
 	if (ppos != NULL)
@@ -1633,7 +1633,7 @@ static void *xt_mttg_seq_start(struct se
 
 static void xt_mttg_seq_stop(struct seq_file *seq, void *v)
 {
-	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
+	uint8_t nfproto = (unsigned long)file_inode(seq->file)->i_private;
 	struct nf_mttg_trav *trav = seq->private;
 
 	switch (trav->class) {
--- a/net/netfilter/xt_hashlimit.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/netfilter/xt_hashlimit.c
@@ -1052,7 +1052,7 @@ static struct xt_match hashlimit_mt_reg[
 static void *dl_seq_start(struct seq_file *s, loff_t *pos)
 	__acquires(htable->lock)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket;
 
 	spin_lock_bh(&htable->lock);
@@ -1069,7 +1069,7 @@ static void *dl_seq_start(struct seq_fil
 
 static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket = v;
 
 	*pos = ++(*bucket);
@@ -1083,7 +1083,7 @@ static void *dl_seq_next(struct seq_file
 static void dl_seq_stop(struct seq_file *s, void *v)
 	__releases(htable->lock)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket = v;
 
 	if (!IS_ERR(bucket))
@@ -1125,7 +1125,7 @@ static void dl_seq_print(struct dsthash_
 static int dl_seq_real_show_v2(struct dsthash_ent *ent, u_int8_t family,
 			       struct seq_file *s)
 {
-	struct xt_hashlimit_htable *ht = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *ht = file_inode(s->file)->i_private;
 
 	spin_lock(&ent->lock);
 	/* recalculate to show accurate numbers */
@@ -1140,7 +1140,7 @@ static int dl_seq_real_show_v2(struct ds
 static int dl_seq_real_show_v1(struct dsthash_ent *ent, u_int8_t family,
 			       struct seq_file *s)
 {
-	struct xt_hashlimit_htable *ht = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *ht = file_inode(s->file)->i_private;
 
 	spin_lock(&ent->lock);
 	/* recalculate to show accurate numbers */
@@ -1155,7 +1155,7 @@ static int dl_seq_real_show_v1(struct ds
 static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 			    struct seq_file *s)
 {
-	struct xt_hashlimit_htable *ht = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *ht = file_inode(s->file)->i_private;
 
 	spin_lock(&ent->lock);
 	/* recalculate to show accurate numbers */
@@ -1169,7 +1169,7 @@ static int dl_seq_real_show(struct dstha
 
 static int dl_seq_show_v2(struct seq_file *s, void *v)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket = (unsigned int *)v;
 	struct dsthash_ent *ent;
 
@@ -1183,7 +1183,7 @@ static int dl_seq_show_v2(struct seq_fil
 
 static int dl_seq_show_v1(struct seq_file *s, void *v)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket = v;
 	struct dsthash_ent *ent;
 
@@ -1197,7 +1197,7 @@ static int dl_seq_show_v1(struct seq_fil
 
 static int dl_seq_show(struct seq_file *s, void *v)
 {
-	struct xt_hashlimit_htable *htable = PDE_DATA(file_inode(s->file));
+	struct xt_hashlimit_htable *htable = file_inode(s->file)->i_private;
 	unsigned int *bucket = v;
 	struct dsthash_ent *ent;
 
--- a/net/netfilter/xt_recent.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/netfilter/xt_recent.c
@@ -551,7 +551,7 @@ static int recent_seq_open(struct inode
 	if (st == NULL)
 		return -ENOMEM;
 
-	st->table    = PDE_DATA(inode);
+	st->table    = inode->i_private;
 	return 0;
 }
 
@@ -559,7 +559,7 @@ static ssize_t
 recent_mt_proc_write(struct file *file, const char __user *input,
 		     size_t size, loff_t *loff)
 {
-	struct recent_table *t = PDE_DATA(file_inode(file));
+	struct recent_table *t = file_inode(file)->i_private;
 	struct recent_entry *e;
 	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:5afe:c0de")];
 	const char *c = buf;
--- a/net/sunrpc/auth_gss/svcauth_gss.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1433,7 +1433,7 @@ static bool use_gss_proxy(struct net *ne
 static ssize_t write_gssp(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	struct net *net = PDE_DATA(file_inode(file));
+	struct net *net = file_inode(file)->i_private;
 	char tbuf[20];
 	unsigned long i;
 	int res;
@@ -1461,7 +1461,7 @@ static ssize_t write_gssp(struct file *f
 static ssize_t read_gssp(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	struct net *net = PDE_DATA(file_inode(file));
+	struct net *net = file_inode(file)->i_private;
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
 	unsigned long p = *ppos;
 	char tbuf[10];
--- a/net/sunrpc/cache.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/sunrpc/cache.c
@@ -1536,7 +1536,7 @@ static ssize_t write_flush(struct file *
 static ssize_t cache_read_procfs(struct file *filp, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE_DATA(file_inode(filp));
+	struct cache_detail *cd = file_inode(filp)->i_private;
 
 	return cache_read(filp, buf, count, ppos, cd);
 }
@@ -1544,14 +1544,14 @@ static ssize_t cache_read_procfs(struct
 static ssize_t cache_write_procfs(struct file *filp, const char __user *buf,
 				  size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE_DATA(file_inode(filp));
+	struct cache_detail *cd = file_inode(filp)->i_private;
 
 	return cache_write(filp, buf, count, ppos, cd);
 }
 
 static __poll_t cache_poll_procfs(struct file *filp, poll_table *wait)
 {
-	struct cache_detail *cd = PDE_DATA(file_inode(filp));
+	struct cache_detail *cd = file_inode(filp)->i_private;
 
 	return cache_poll(filp, wait, cd);
 }
@@ -1560,21 +1560,21 @@ static long cache_ioctl_procfs(struct fi
 			       unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return cache_ioctl(inode, filp, cmd, arg, cd);
 }
 
 static int cache_open_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return cache_open(inode, filp, cd);
 }
 
 static int cache_release_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return cache_release(inode, filp, cd);
 }
@@ -1591,14 +1591,14 @@ static const struct proc_ops cache_chann
 
 static int content_open_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return content_open(inode, filp, cd);
 }
 
 static int content_release_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return content_release(inode, filp, cd);
 }
@@ -1612,14 +1612,14 @@ static const struct proc_ops content_pro
 
 static int open_flush_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return open_flush(inode, filp, cd);
 }
 
 static int release_flush_procfs(struct inode *inode, struct file *filp)
 {
-	struct cache_detail *cd = PDE_DATA(inode);
+	struct cache_detail *cd = inode->i_private;
 
 	return release_flush(inode, filp, cd);
 }
@@ -1627,7 +1627,7 @@ static int release_flush_procfs(struct i
 static ssize_t read_flush_procfs(struct file *filp, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE_DATA(file_inode(filp));
+	struct cache_detail *cd = file_inode(filp)->i_private;
 
 	return read_flush(filp, buf, count, ppos, cd);
 }
@@ -1636,7 +1636,7 @@ static ssize_t write_flush_procfs(struct
 				  const char __user *buf,
 				  size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE_DATA(file_inode(filp));
+	struct cache_detail *cd = file_inode(filp)->i_private;
 
 	return write_flush(filp, buf, count, ppos, cd);
 }
--- a/net/sunrpc/stats.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/net/sunrpc/stats.c
@@ -66,7 +66,7 @@ static int rpc_proc_show(struct seq_file
 
 static int rpc_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, rpc_proc_show, PDE_DATA(inode));
+	return single_open(file, rpc_proc_show, inode->i_private);
 }
 
 static const struct proc_ops rpc_proc_ops = {
--- a/sound/core/info.c~fs-proc-replace-pde_datainode-with-inode-i_private
+++ a/sound/core/info.c
@@ -234,7 +234,7 @@ static int snd_info_entry_mmap(struct fi
 
 static int snd_info_entry_open(struct inode *inode, struct file *file)
 {
-	struct snd_info_entry *entry = PDE_DATA(inode);
+	struct snd_info_entry *entry = inode->i_private;
 	struct snd_info_private_data *data;
 	int mode, err;
 
@@ -365,7 +365,7 @@ static int snd_info_seq_show(struct seq_
 
 static int snd_info_text_entry_open(struct inode *inode, struct file *file)
 {
-	struct snd_info_entry *entry = PDE_DATA(inode);
+	struct snd_info_entry *entry = inode->i_private;
 	struct snd_info_private_data *data;
 	int err;
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
proc-remove-pde_data-completely.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

