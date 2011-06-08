From: akpm@linux-foundation.org
Subject: [merged] drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch removed from -mm tree
Date: Wed, 08 Jun 2011 12:52:57 -0700
Message-ID: <201106081951.p58JpnsW024806__5466.79350450194$1307562764$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab1FHTwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 15:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, blueness@gentoo.org, gregkh@suse.de, stable@kernel.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/base/platform.c: don't mark platform_device_register_resnd=
ata() as __init_or_module
has been removed from the -mm tree.  Its filename was
     drivers-base-platformc-dont-mark-platform_device_register_resndata=
-as-__init_or_module.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/base/platform.c: don't mark platform_device_register_r=
esndata() as __init_or_module
=46rom: Andrew Morton <akpm@linux-foundation.org>

This reverts 737a3bb9416ce2a7c7a4 ("Driver core: move platform device
creation helpers to .init.text (if MODULE=3Dn)").  That patch assumed t=
hat
platform_device_register_resndata() is only ever called from __init cod=
e
but that isn't true in the case ioctl->drm_ioctl->radeon_cp_init().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D35192

Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Reported-by: Anthony Basile <blueness@gentoo.org>
Cc: Greg KH <gregkh@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/platform.c~drivers-base-platformc-dont-mark-plat=
form_device_register_resndata-as-__init_or_module drivers/base/platform=
=2Ec
--- a/drivers/base/platform.c~drivers-base-platformc-dont-mark-platform=
_device_register_resndata-as-__init_or_module
+++ a/drivers/base/platform.c
@@ -367,7 +367,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on=
 error.
  */
-struct platform_device *__init_or_module platform_device_register_resn=
data(
+struct platform_device *platform_device_register_resndata(
 		struct device *parent,
 		const char *name, int id,
 		const struct resource *res, unsigned int num,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machine=
s-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
