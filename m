From: akpm@linux-foundation.org
Subject: - net-sunrpc-svcsockc-fix-a-check.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:30 -0700
Message-ID: <200704062008.l36K8Ufm017853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXDFULq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     net/sunrpc/svcsock.c: fix a check
has been removed from the -mm tree.  Its filename was
     net-sunrpc-svcsockc-fix-a-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/sunrpc/svcsock.c: fix a check
From: Adrian Bunk <bunk@stusta.de>

The return value of kernel_recvmsg() should be assigned to "err", not
compared with the random value of a never initialized "err" (and the "< 0"
check wrongly always returned false since == comparisons never have a
result < 0).

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/sunrpc/svcsock.c~net-sunrpc-svcsockc-fix-a-check net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~net-sunrpc-svcsockc-fix-a-check
+++ a/net/sunrpc/svcsock.c
@@ -779,8 +779,8 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
-				      0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
+	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+				     0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
 	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
 		if (err == -EAGAIN) {
 			svc_sock_received(svsk);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
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
