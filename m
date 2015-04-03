From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 03 Apr 2015 12:11:37 -0700
Message-ID: <551ee5e9.MMNmM8okZ4ABrwQm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbDCTLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 15:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/entry_64.S          |   18 ----------------
 drivers/gpu/drm/i915/intel_sprite.c |   28 --------------------------
 net/ipv4/tcp_ipv4.c                 |    4 ---
 net/ipv6/tcp_ipv6.c                 |    4 ---
 4 files changed, 54 deletions(-)

diff -puN arch/x86/kernel/entry_64.S~linux-next-git-rejects arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~linux-next-git-rejects
+++ a/arch/x86/kernel/entry_64.S
@@ -716,25 +716,7 @@ retint_swapgs:		/* return to user-space
 	cmpq %r11,EFLAGS(%rsp)		/* R11 == RFLAGS */
 	jne opportunistic_sysret_failed
 
-<<<<<<< HEAD
-	/*
-	 * SYSRET can't restore RF.  SYSRET can restore TF, but unlike IRET,
-	 * restoring TF results in a trap from userspace immediately after
-	 * SYSRET.  This would cause an infinite loop whenever #DB happens
-	 * with register state that satisfies the opportunistic SYSRET
-	 * conditions.  For example, single-stepping this user code:
-	 *
-	 *           movq $stuck_here,%rcx
-	 *           pushfq
-	 *           popq %r11
-	 *   stuck_here:
-	 *
-	 * would never get past 'stuck_here'.
-	 */
-	testq $(X86_EFLAGS_RF|X86_EFLAGS_TF), %r11
-=======
 	testq $X86_EFLAGS_RF,%r11	/* sysret can't restore RF */
->>>>>>> linux-next/akpm-base
 	jnz opportunistic_sysret_failed
 
 	/* nothing to check for RSP */
diff -puN drivers/gpu/drm/i915/intel_sprite.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_sprite.c
--- a/drivers/gpu/drm/i915/intel_sprite.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_sprite.c
@@ -1119,35 +1119,7 @@ int intel_sprite_set_colorkey(struct drm
 	}
 
 	intel_plane = to_intel_plane(plane);
-<<<<<<< HEAD
-	ret = intel_plane->update_colorkey(plane, set);
-
-out_unlock:
-	drm_modeset_unlock_all(dev);
-	return ret;
-}
-
-int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv)
-{
-	struct drm_intel_sprite_colorkey *get = data;
-	struct drm_plane *plane;
-	struct intel_plane *intel_plane;
-	int ret = 0;
-
-	if (!drm_core_check_feature(dev, DRIVER_MODESET))
-		return -ENODEV;
-
-	drm_modeset_lock_all(dev);
-
-	plane = drm_plane_find(dev, get->plane_id);
-	if (!plane || plane->type != DRM_PLANE_TYPE_OVERLAY) {
-		ret = -ENOENT;
-		goto out_unlock;
-	}
-=======
 	intel_plane->ckey = *set;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * The only way this could fail would be due to
diff -puN net/ipv4/tcp_ipv4.c~linux-next-git-rejects net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~linux-next-git-rejects
+++ a/net/ipv4/tcp_ipv4.c
@@ -1468,11 +1468,7 @@ void tcp_v4_early_demux(struct sk_buff *
 	if (sk) {
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
-<<<<<<< HEAD
-		if (sk->sk_state != TCP_TIME_WAIT) {
-=======
 		if (sk_fullsock(sk)) {
->>>>>>> linux-next/akpm-base
 			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
 
 			if (dst)
diff -puN net/ipv6/tcp_ipv6.c~linux-next-git-rejects net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~linux-next-git-rejects
+++ a/net/ipv6/tcp_ipv6.c
@@ -1532,11 +1532,7 @@ static void tcp_v6_early_demux(struct sk
 	if (sk) {
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
-<<<<<<< HEAD
-		if (sk->sk_state != TCP_TIME_WAIT) {
-=======
 		if (sk_fullsock(sk)) {
->>>>>>> linux-next/akpm-base
 			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
 
 			if (dst)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix-fix.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-cpu-commonc-fix-warning.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

