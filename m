From: akpm@linux-foundation.org
Subject: + nfs-make-nfs4_drop_state_owner-static.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:03:37 -0700
Message-ID: <200804300003.m3U03bJX017080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734AbYD3AE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     nfs: make nfs4_drop_state_owner() static
has been added to the -mm tree.  Its filename is
     nfs-make-nfs4_drop_state_owner-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
git-nfsd.patch
git-ocfs2.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
usb-storage-onetouchc-make-a-function-static.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch
nfs-make-nfs4_drop_state_owner-static.patch

