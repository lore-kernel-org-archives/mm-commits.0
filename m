From: akpm@linux-foundation.org
Subject: [folded] proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:57:53 -0800
Message-ID: <200912212357.nBLNvsua003748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbZLUX6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, isdn@linux-pingi.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     proc_fops-convert-drivers-isdn-to-seq_file-fix2
has been removed from the -mm tree.  Its filename was
     proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch

This patch was dropped because it was folded into proc_fops-convert-drivers-isdn-to-seq_file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fops-convert-drivers-isdn-to-seq_file-fix2
From: Andrew Morton <akpm@linux-foundation.org>

when CONFIG_PROC_FS=n:

drivers/isdn/gigaset/capi.c:2206: error: implicit declaration of function 'PDE'
drivers/isdn/gigaset/capi.c:2206: error: invalid type argument of '->'


when CONFIG_PROC_FS=y:

drivers/isdn/hysdn/hycapi.c:469: error: implicit declaration of function 'PDE'
drivers/isdn/hysdn/hycapi.c:469: error: invalid type argument of '->'
drivers/isdn/hysdn/hycapi.c:472: error: variable 'hycapi_proc_fops' has initializer but incomplete type
drivers/isdn/hysdn/hycapi.c:473: error: unknown field 'owner' specified in initializer
drivers/isdn/hysdn/hycapi.c:473: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:473: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:474: error: unknown field 'open' specified in initializer
drivers/isdn/hysdn/hycapi.c:474: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:474: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:475: error: unknown field 'read' specified in initializer
drivers/isdn/hysdn/hycapi.c:475: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:475: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:476: error: unknown field 'llseek' specified in initializer
drivers/isdn/hysdn/hycapi.c:476: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:476: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:477: error: unknown field 'release' specified in initializer
drivers/isdn/hysdn/hycapi.c:477: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:477: warning: (near initialization for 'hycapi_proc_fops')

Needs to #include <linux/proc_fs.h>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/capi.c |    1 +
 drivers/isdn/hysdn/hycapi.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2 drivers/isdn/gigaset/capi.c
--- a/drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2
+++ a/drivers/isdn/gigaset/capi.c
@@ -13,6 +13,7 @@
 
 #include "gigaset.h"
 #include <linux/ctype.h>
+#include <linux/proc_fs.h>
 #include <linux/isdn/capilli.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
diff -puN drivers/isdn/hysdn/hycapi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2 drivers/isdn/hysdn/hycapi.c
--- a/drivers/isdn/hysdn/hycapi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2
+++ a/drivers/isdn/hysdn/hycapi.c
@@ -14,6 +14,7 @@
 #include <linux/signal.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/proc_fs.h>
 #include <linux/netdevice.h>
 
 #define	VER_DRIVER	0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

