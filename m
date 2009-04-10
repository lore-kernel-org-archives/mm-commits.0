From: akpm@linux-foundation.org
Subject: + gru-support-for-asynchronous-gru-instructions-fix.patch added to -mm tree
Date: Fri, 10 Apr 2009 01:37:00 -0700
Message-ID: <200904100837.n3A8b0X3027012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbZDJIir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 04:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, steiner@sgi.com


The patch titled
     gru-support-for-asynchronous-gru-instructions-fix
has been added to the -mm tree.  Its filename is
     gru-support-for-asynchronous-gru-instructions-fix.patch

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
Subject: gru-support-for-asynchronous-gru-instructions-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

drivers/misc/sgi-gru/grufault.c: In function 'gru_intr':
drivers/misc/sgi-gru/grufault.c:475: error: 'chiplet' undeclared (first use in this function)
drivers/misc/sgi-gru/grufault.c:475: error: (Each undeclared identifier is reported only once
drivers/misc/sgi-gru/grufault.c:475: error: for each function it appears in.)


and what's this?

drivers/misc/sgi-gru/grufault.c: In function 'gru_try_dropin':
drivers/misc/sgi-gru/grufault.c:281: warning: 'ps' may be used uninitialized in this function
drivers/misc/sgi-gru/grufault.c:280: warning: 'paddr' may be used uninitialized in this function

Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-support-for-asynchronous-gru-instructions-fix drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-support-for-asynchronous-gru-instructions-fix
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -472,10 +472,6 @@ irqreturn_t gru_intr(int irq, void *dev_
 		return IRQ_NONE;
 	}
 	get_clear_fault_map(gru, &imap, &dmap);
-	gru_dbg(grudev,
-		"chiplet %d, gid %d, imap %016lx %016lx, dmap %016lx %016lx\n",
-		chiplet, gru->gs_gid, imap.fault_bits[0], imap.fault_bits[1],
-		dmap.fault_bits[0], dmap.fault_bits[1]);
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		complete(gru->gs_blade->bs_async_wq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
hfs-fix-memory-leak-when-unmounting-fix.patch
memcg-remove-warning-when-config_debug_vm=n-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-consolidate-init_mm-definition-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
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
gru-support-for-asynchronous-gru-instructions-fix.patch

