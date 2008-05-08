From: akpm@linux-foundation.org
Subject: + page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch added to -mm tree
Date: Thu, 08 May 2008 16:45:43 -0700
Message-ID: <200805082356.m48NuclQ012631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYEHX52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 19:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie


The patch titled
     page-allocator-inlnie-some-__alloc_pages-wrappers-fix
has been added to the -mm tree.  Its filename is
     page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch

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
Subject: page-allocator-inlnie-some-__alloc_pages-wrappers-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "__alloc_pages_internal" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "__alloc_pages_internal" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "__alloc_pages_internal" [net/sunrpc/auth_gss/auth_rpcgss.ko] undefined!
ERROR: "__alloc_pages_internal" [net/ipv6/ipv6.ko] undefined!
ERROR: "__alloc_pages_internal" [net/core/pktgen.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/xfs/xfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/reiser4/reiser4.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ntfs/ntfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/nfs/nfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ncpfs/ncpfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/isofs/isofs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/gfs2/gfs2.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/fuse/fuse.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/dlm/dlm.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/virtio/virtio_balloon.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/scsi/st.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/scsi/sg.ko] undefined!
...

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers-fix
+++ a/mm/page_alloc.c
@@ -1657,6 +1657,7 @@ nopage:
 got_pg:
 	return page;
 }
+EXPORT_SYMBOL(__alloc_pages_internal);
 
 /*
  * Common helper functions.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
fix-hfsplus-oops-on-image-without-extents-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
arch-x86-kernel-setupc-printk-warning-fix.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fix-driver-core-prepare-for-removal-of-20-char-limit-from-struct-device.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-fix.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
revert-git-block.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
logfs-unbork.patch
logfs-is-busted.patch
drivers-usb-core-sysfsc-fix-types.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

