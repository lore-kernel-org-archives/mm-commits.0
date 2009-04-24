From: akpm@linux-foundation.org
Subject: + net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n.patch added to -mm tree
Date: Fri, 24 Apr 2009 15:26:02 -0700
Message-ID: <200904242244.n3OMipvN018777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbZDXWuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 18:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, IvDoorn@gmail.com, Larry.Finger@lwfinger.net, davem@davemloft.net, hmh@hmh.eng.br, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     net/rfkill/rfkill.c: fix build with CONFIG_RFKILL_LEDS=n
has been added to the -mm tree.  Its filename is
     net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n.patch

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
Subject: net/rfkill/rfkill.c: fix build with CONFIG_RFKILL_LEDS=n
From: Andrew Morton <akpm@linux-foundation.org>

net/rfkill/rfkill.c: In function 'update_rfkill_state':
net/rfkill/rfkill.c:99: error: implicit declaration of function 'rfkill_led_trigger'

Caused by

: commit 492301fb5d12e4a77a1010ad2b6f1ed306014123
: Author: Larry Finger <Larry.Finger@lwfinger.net>
: Date:   Thu Apr 9 22:14:19 2009 -0500
: 
:     rfkill: Fix broken rfkill LED in 2.6.30-rc1

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rfkill/rfkill.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN net/rfkill/rfkill.c~net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n net/rfkill/rfkill.c
--- a/net/rfkill/rfkill.c~net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n
+++ a/net/rfkill/rfkill.c
@@ -75,6 +75,11 @@ static void rfkill_led_trigger_activate(
 
 	rfkill_led_trigger(rfkill, rfkill->state);
 }
+#else
+static inline void rfkill_led_trigger(struct rfkill *rfkill,
+					enum rfkill_state state)
+{
+}
 #endif /* CONFIG_RFKILL_LEDS */
 
 static void rfkill_uevent(struct rfkill *rfkill)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
block-turn-some-buggy-macros-into-c-functions.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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

