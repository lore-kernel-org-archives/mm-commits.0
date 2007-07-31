From: akpm@linux-foundation.org
Subject: - make-nf_ct_ipv6_skip_exthdr-static.patch removed from -mm tree
Date: Mon, 30 Jul 2007 22:01:21 -0700
Message-ID: <200707310501.l6V51Lxw016545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968350AbXGaFBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 01:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make nf_ct_ipv6_skip_exthdr() static
has been removed from the -mm tree.  Its filename was
     make-nf_ct_ipv6_skip_exthdr-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make nf_ct_ipv6_skip_exthdr() static


nf_ct_ipv6_skip_exthdr() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    3 ---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/net/netfilter/ipv6/nf_conntrack_ipv6.h~make-nf_ct_ipv6_skip_exthdr-static include/net/netfilter/ipv6/nf_conntrack_ipv6.h
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h~make-nf_ct_ipv6_skip_exthdr-static
+++ a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -7,9 +7,6 @@ extern struct nf_conntrack_l4proto nf_co
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
-extern int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
-				  u8 *nexthdrp, int len);
-
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
 extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
diff -puN net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c~make-nf_ct_ipv6_skip_exthdr-static net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c~make-nf_ct_ipv6_skip_exthdr-static
+++ a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -86,8 +86,8 @@ static int ipv6_print_conntrack(struct s
  *        - Note also special handling of AUTH header. Thanks to IPsec wizards.
  */
 
-int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
-			   int len)
+static int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
+				  u8 *nexthdrp, int len)
 {
 	u8 nexthdr = *nexthdrp;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-the-arm26-port.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-net.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
