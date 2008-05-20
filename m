From: akpm@linux-foundation.org
Subject: - nfs-make-nfs4_drop_state_owner-static.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:25 -0700
Message-ID: <200805202114.m4KLEPY7011463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932431AbYETVPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nfs: make nfs4_drop_state_owner() static
has been removed from the -mm tree.  Its filename was
     nfs-make-nfs4_drop_state_owner-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: make nfs4_drop_state_owner() static
From: Adrian Bunk <bunk@kernel.org>

nfs4_drop_state_owner() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4_fs.h   |    1 -
 fs/nfs/nfs4state.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nfs/nfs4_fs.h~nfs-make-nfs4_drop_state_owner-static fs/nfs/nfs4_fs.h
--- a/fs/nfs/nfs4_fs.h~nfs-make-nfs4_drop_state_owner-static
+++ a/fs/nfs/nfs4_fs.h
@@ -206,7 +206,6 @@ struct rpc_cred *nfs4_get_renew_cred(str
 
 extern struct nfs4_state_owner * nfs4_get_state_owner(struct nfs_server *, struct rpc_cred *);
 extern void nfs4_put_state_owner(struct nfs4_state_owner *);
-extern void nfs4_drop_state_owner(struct nfs4_state_owner *);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
 extern void nfs4_close_state(struct path *, struct nfs4_state *, mode_t);
diff -puN fs/nfs/nfs4state.c~nfs-make-nfs4_drop_state_owner-static fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~nfs-make-nfs4_drop_state_owner-static
+++ a/fs/nfs/nfs4state.c
@@ -282,7 +282,7 @@ nfs4_alloc_state_owner(void)
 	return sp;
 }
 
-void
+static void
 nfs4_drop_state_owner(struct nfs4_state_owner *sp)
 {
 	if (!RB_EMPTY_NODE(&sp->so_client_node)) {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
if-0-ses_match_host.patch
git-sparc64.patch
git-watchdog.patch
git-xtensa.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-the-oss-trident-driver.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

