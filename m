From: akpm@linux-foundation.org
Subject: + kernel-trace-ring_bufferc-use-div_round_up.patch added to -mm tree
Date: Wed, 07 Jan 2009 21:29:22 -0800
Message-ID: <200901080529.n085TM7t015825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbZAHF3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 00:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     kernel/trace/ring_buffer.c: use DIV_ROUND_UP
has been added to the -mm tree.  Its filename is
     kernel-trace-ring_bufferc-use-div_round_up.patch

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
+			length = event->len / RB_ALIGNMENT;
 		else
 			length = event->array[0];
 		return length + RB_EVNT_HDR_SIZE;
@@ -931,15 +930,11 @@ rb_update_event(struct ring_buffer_event
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
@@ -948,9 +943,7 @@ rb_update_event(struct ring_buffer_event
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
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
w1-allow-master-io-commands.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

