From: akpm@linux-foundation.org
Subject: [merged] kernel-trace-ring_bufferc-use-div_round_up.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:21 -0800
Message-ID: <200901161918.n0GJIL9g026930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765828AbZAPTSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     kernel/trace/ring_buffer.c: use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     kernel-trace-ring_bufferc-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/trace/ring_buffer.c: use DIV_ROUND_UP
From: Andrew Morton <akpm@linux-foundation.org>

Instead of open-coding it.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ring_buffer.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up
+++ a/kernel/trace/ring_buffer.c
@@ -123,8 +123,7 @@ void ring_buffer_normalize_time_stamp(in
 EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
 #define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
-#define RB_ALIGNMENT_SHIFT	2
-#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
+#define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	28
 
 enum {
@@ -151,7 +150,7 @@ rb_event_length(struct ring_buffer_event
 
 	case RINGBUF_TYPE_DATA:
 		if (event->len)
-			length = event->len << RB_ALIGNMENT_SHIFT;
+			length = event->len * RB_ALIGNMENT;
 		else
 			length = event->array[0];
 		return length + RB_EVNT_HDR_SIZE;
@@ -937,15 +936,11 @@ rb_update_event(struct ring_buffer_event
 		break;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
-		event->len =
-			(RB_LEN_TIME_EXTEND + (RB_ALIGNMENT-1))
-			>> RB_ALIGNMENT_SHIFT;
+		event->len = DIV_ROUND_UP(RB_LEN_TIME_EXTEND, RB_ALIGNMENT);
 		break;
 
 	case RINGBUF_TYPE_TIME_STAMP:
-		event->len =
-			(RB_LEN_TIME_STAMP + (RB_ALIGNMENT-1))
-			>> RB_ALIGNMENT_SHIFT;
+		event->len = DIV_ROUND_UP(RB_LEN_TIME_STAMP, RB_ALIGNMENT);
 		break;
 
 	case RINGBUF_TYPE_DATA:
@@ -954,9 +949,7 @@ rb_update_event(struct ring_buffer_event
 			event->len = 0;
 			event->array[0] = length;
 		} else
-			event->len =
-				(length + (RB_ALIGNMENT-1))
-				>> RB_ALIGNMENT_SHIFT;
+			event->len = DIV_ROUND_UP(length, RB_ALIGNMENT);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
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

