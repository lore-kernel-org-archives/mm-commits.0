From: akpm@linux-foundation.org
Subject: + drivers-net-mlx4-profilec-fix-min-warning.patch added to -mm tree
Date: Thu, 15 Jan 2009 13:32:36 -0800
Message-ID: <200901152149.n0FLnA1P007251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbZAOVuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 16:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, jackm@dev.mellanox.co.il, mst@dev.mellanox.co.il, rolandd@cisco.com, vlad@mellanox.co.il, yevgenyp@mellanox.co.il


The patch titled
     drivers/net/mlx4/profile.c: fix min() warning
has been added to the -mm tree.  Its filename is
     drivers-net-mlx4-profilec-fix-min-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/mlx4/profile.c: fix min() warning
From: Andrew Morton <akpm@linux-foundation.org>

sparc64 allmodconfig:

drivers/net/mlx4/profile.c: In function `mlx4_make_profile':
drivers/net/mlx4/profile.c:110: warning: comparison of distinct pointer types lacks a cast

This happened because num_possible_cpus() was secretly changed (by
ae7a47e72e1a0b5e2b46d1596bc2c22942a73023) from returning `int' to (now)
returning `unsigned int'.  I think that was a good change, so we should just
swallow the fallout.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Vladimir Sokolovsky <vlad@mellanox.co.il>
Cc: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mlx4/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/mlx4/profile.c~drivers-net-mlx4-profilec-fix-min-warning drivers/net/mlx4/profile.c
--- a/drivers/net/mlx4/profile.c~drivers-net-mlx4-profilec-fix-min-warning
+++ a/drivers/net/mlx4/profile.c
@@ -107,7 +107,7 @@ u64 mlx4_make_profile(struct mlx4_dev *d
 	profile[MLX4_RES_AUXC].num    = request->num_qp;
 	profile[MLX4_RES_SRQ].num     = request->num_srq;
 	profile[MLX4_RES_CQ].num      = request->num_cq;
-	profile[MLX4_RES_EQ].num      = min(dev_cap->max_eqs,
+	profile[MLX4_RES_EQ].num      = min_t(unsigned, dev_cap->max_eqs,
 					    dev_cap->reserved_eqs +
 					    num_possible_cpus() + 1);
 	profile[MLX4_RES_DMPT].num    = request->num_mpt;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

