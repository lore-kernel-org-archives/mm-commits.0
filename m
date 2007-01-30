From: akpm@osdl.org
Subject: - drivers-char-pcmcia-ipwireless_cs_-possible-cleanups.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:56 -0800
Message-ID: <200701302147.l0ULluaW030227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXA3VvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     drivers/char/pcmcia/ipwireless_cs_*: possible cleanups
has been removed from the -mm tree.  Its filename was
     drivers-char-pcmcia-ipwireless_cs_-possible-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/pcmcia/ipwireless_cs_*: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- proper prototypes for global functions in header files
- make the following needlessly global function static:
  - ipwireless_cs_hardware.c: data_type()
- make the following needlessly global struct static:
  - ipwireless_cs_tty.c: ipw_tty_driver
- #if 0 the following unused global functions:
  - ipwireless_cs_hardware.c: ipwireless_get_config()
  - ipwireless_cs_tty.c: ipw_flush_buffer()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/pcmcia/ipwireless_cs_hardware.c |    4 +++-
 drivers/char/pcmcia/ipwireless_cs_hardware.h |    5 ++---
 drivers/char/pcmcia/ipwireless_cs_network.h  |    2 ++
 drivers/char/pcmcia/ipwireless_cs_tty.c      |   10 +++-------
 4 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/char/pcmcia/ipwireless_cs_hardware.c~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups drivers/char/pcmcia/ipwireless_cs_hardware.c
--- a/drivers/char/pcmcia/ipwireless_cs_hardware.c~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups
+++ a/drivers/char/pcmcia/ipwireless_cs_hardware.c
@@ -375,7 +375,7 @@ int ipwireless_dump_hardware_state(char 
 
 
 
-char *data_type(const u_char * buf, unsigned length)
+static char *data_type(const u_char * buf, unsigned length)
 {
 	NLPacketHeader *hdr = (NLPacketHeader *) buf;
 	if (length == 0)
@@ -1586,10 +1586,12 @@ void ipwireless_hardware_free(ipw_hardwa
 	kfree(hw);
 }
 
+#if 0
 ipw_config_t *ipwireless_get_config(struct ipw_hardware_t *hw)
 {
 	return &hw->config;
 }
+#endif  /*  0  */
 
 /* Associate the specified network with this hardware, so it will receive events
  * from it. */
diff -puN drivers/char/pcmcia/ipwireless_cs_hardware.h~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups drivers/char/pcmcia/ipwireless_cs_hardware.h
--- a/drivers/char/pcmcia/ipwireless_cs_hardware.h~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups
+++ a/drivers/char/pcmcia/ipwireless_cs_hardware.h
@@ -43,9 +43,6 @@ void ipwireless_send_packet(struct ipw_h
 			    unsigned int, ipw_packet_sent_callback_t,
 			    void *);
 
-/* Get the configuration settings for this modem instance. */
-struct ipw_config_t *ipwireless_get_config(struct ipw_hardware_t *);
-
 /* Associate the specified network with this hardware */
 void ipwireless_associate_network(struct ipw_hardware_t *, struct ipw_network_t *);
 
@@ -64,4 +61,6 @@ void ipwireless_init_hardware2(struct ip
 
 void ipwireless_sleep(u_int tenths);
 
+int ipwireless_dump_hardware_state(char *p, struct ipw_hardware_t *hw);
+
 #endif
diff -puN drivers/char/pcmcia/ipwireless_cs_network.h~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups drivers/char/pcmcia/ipwireless_cs_network.h
--- a/drivers/char/pcmcia/ipwireless_cs_network.h~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups
+++ a/drivers/char/pcmcia/ipwireless_cs_network.h
@@ -43,4 +43,6 @@ void ipwireless_ppp_close(struct ipw_net
 int ipwireless_ppp_channel_index(struct ipw_network_t *);
 int ipwireless_ppp_unit_number(struct ipw_network_t *);
 
+int ipwireless_dump_network_state(char *p, struct ipw_network_t *network);
+
 #endif
diff -puN drivers/char/pcmcia/ipwireless_cs_tty.c~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups drivers/char/pcmcia/ipwireless_cs_tty.c
--- a/drivers/char/pcmcia/ipwireless_cs_tty.c~drivers-char-pcmcia-ipwireless_cs_-possible-cleanups
+++ a/drivers/char/pcmcia/ipwireless_cs_tty.c
@@ -463,10 +463,12 @@ ipw_ioctl(struct tty_struct *linux_tty, 
 	return ppp_ioctl(linux_tty, file, cmd, arg);
 }
 
+#if 0
 void ipw_flush_buffer(struct tty_struct *tty)
 {
 	wake_up_interruptible(&tty->write_wait);
 }
+#endif  /*  0  */
 
 static void add_tty(int first, int *j, dev_node_t ** nodesp,
 		    struct pcmcia_device *link,
@@ -577,7 +579,7 @@ static struct tty_operations tty_ops = {
 	.tiocmset = ipw_tiocmset,
 };
 
-struct tty_driver *ipw_tty_driver;
+static struct tty_driver *ipw_tty_driver;
 
 static int proc_read(char *page, char **start, off_t off, int count,
 		     int *eof, void *data)
@@ -585,12 +587,6 @@ static int proc_read(char *page, char **
 	int i, j;
 	char *p = page;
 	int len;
-#ifdef IPWIRELESS_STATE_DEBUG
-	int ipwireless_dump_hardware_state(char *p,
-					   struct ipw_hardware_t *hw);
-	int ipwireless_dump_network_state(char *p,
-					  struct ipw_network_t *network);
-#endif
 
 	if (off == 0) {
 		p += sprintf(p, "driver: %s\nversion: %s\n\n",
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
uml-fix-signal-frame-alignment.patch
git-acpi.patch
drivers-acpi-hotkeyc-make-2-structs-static.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
if-0-v4l_printk_ioctl_arg.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
cleanup-x86_64-mm-vmi-timer.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
