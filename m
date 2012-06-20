From: akpm@linux-foundation.org
Subject: [merged] drivers-power-power_supply_corec-partially-fix.patch removed from -mm tree
Date: Wed, 20 Jun 2012 12:26:50 -0700
Message-ID: <20120620192650.6C676A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38359 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab2FTT0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 15:26:53 -0400
Received: by wgbdt11 with SMTP id dt11so449601wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 12:26:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cbouatmailru@gmail.com, jenny.tc@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/power/power_supply_core.c: partially fix
has been removed from the -mm tree.  Its filename was
     drivers-power-power_supply_corec-partially-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/power/power_supply_core.c: partially fix

drivers/power/power_supply_core.c: In function 'psy_register_thermal':
drivers/power/power_supply_core.c:204: warning: passing argument 1 of 'thermal_zone_device_register' discards qualifiers from pointer target type
include/linux/thermal.h:149: note: expected 'char *' but argument is of type 'const char *'
drivers/power/power_supply_core.c:204: warning: passing argument 3 of 'thermal_zone_device_register' makes integer from pointer without a cast
include/linux/thermal.h:149: note: expected 'int' but argument is of type 'struct power_supply *'
drivers/power/power_supply_core.c:204: error: too few arguments to function 'thermal_zone_device_register'

make the error go away.  The warnings remain unfixed.

Cc: Jenny TC <jenny.tc@intel.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/power_supply_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/power_supply_core.c~drivers-power-power_supply_corec-partially-fix drivers/power/power_supply_core.c
--- a/drivers/power/power_supply_core.c~drivers-power-power_supply_corec-partially-fix
+++ a/drivers/power/power_supply_core.c
@@ -201,7 +201,7 @@ static int psy_register_thermal(struct p
 	for (i = 0; i < psy->num_properties; i++) {
 		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
 			psy->tzd = thermal_zone_device_register(psy->name, 0,
-					psy, &psy_tzd_ops, 0, 0, 0, 0);
+					0, psy, &psy_tzd_ops, 0, 0, 0, 0);
 			if (IS_ERR(psy->tzd))
 				return PTR_ERR(psy->tzd);
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

