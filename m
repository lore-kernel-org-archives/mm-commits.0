From: akpm@linux-foundation.org
Subject: - net-uninline-skb_put-fix.patch removed from -mm tree
Date: Sat, 24 Mar 2007 07:39:03 -0800
Message-ID: <200703241539.l2OFd31V008579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbXCXPmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 24 Mar 2007 11:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make net/core/skbuff.c:skb_over_panic() static
has been removed from the -mm tree.  Its filename was
     net-uninline-skb_put-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: make net/core/skbuff.c:skb_over_panic() static
From: Adrian Bunk <bunk@stusta.de>

skb_over_panic() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |    2 --
 net/core/skbuff.c      |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/skbuff.h~net-uninline-skb_put-fix include/linux/skbuff.h
--- a/include/linux/skbuff.h~net-uninline-skb_put-fix
+++ a/include/linux/skbuff.h
@@ -365,8 +365,6 @@ extern struct sk_buff *skb_copy_expand(c
 				       gfp_t priority);
 extern int	       skb_pad(struct sk_buff *skb, int pad);
 #define dev_kfree_skb(a)	kfree_skb(a)
-extern void	      skb_over_panic(struct sk_buff *skb, int len,
-				     void *here);
 extern void	      skb_under_panic(struct sk_buff *skb, int len,
 				      void *here);
 extern void	      skb_truesize_bug(struct sk_buff *skb);
diff -puN net/core/skbuff.c~net-uninline-skb_put-fix net/core/skbuff.c
--- a/net/core/skbuff.c~net-uninline-skb_put-fix
+++ a/net/core/skbuff.c
@@ -84,7 +84,7 @@ static struct kmem_cache *skbuff_fclone_
  *
  *	Out of line support code for skb_put(). Not user callable.
  */
-void skb_over_panic(struct sk_buff *skb, int sz, void *here)
+static void skb_over_panic(struct sk_buff *skb, int sz, void *here)
 {
 	printk(KERN_EMERG "skb_over_panic: text:%p len:%d put:%d head:%p "
 			  "data:%p tail:%p end:%p dev:%s\n",
@@ -2097,7 +2097,6 @@ EXPORT_SYMBOL(skb_copy_and_csum_bits);
 EXPORT_SYMBOL(skb_copy_and_csum_dev);
 EXPORT_SYMBOL(skb_copy_bits);
 EXPORT_SYMBOL(skb_copy_expand);
-EXPORT_SYMBOL(skb_over_panic);
 EXPORT_SYMBOL(skb_pad);
 EXPORT_SYMBOL(skb_realloc_headroom);
 EXPORT_SYMBOL(skb_under_panic);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
