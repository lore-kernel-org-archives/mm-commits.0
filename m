From: akpm@linux-foundation.org
Subject: [merged] kernel-trace-ring_bufferc-reduce-inlining.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:19 -0800
Message-ID: <200901161918.n0GJIJYg026927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765386AbZAPTSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     kernel/trace/ring_buffer.c: reduce inlining
has been removed from the -mm tree.  Its filename was
     kernel-trace-ring_bufferc-reduce-inlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/trace/ring_buffer.c: reduce inlining
From: Andrew Morton <akpm@linux-foundation.org>

          text    data     bss     dec     hex filename
before:  11320     228       8   11556    2d24 kernel/trace/ring_buffer.o
after:   10592     228       8   10828    2a4c kernel/trace/ring_buffer.o

Also: free_page(0) is legal.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ring_buffer.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining
+++ a/kernel/trace/ring_buffer.c
@@ -133,7 +133,7 @@ enum {
 };
 
 /* inline for ring buffer fast paths */
-static inline unsigned
+static unsigned
 rb_event_length(struct ring_buffer_event *event)
 {
 	unsigned length;
@@ -179,7 +179,7 @@ unsigned ring_buffer_event_length(struct
 EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 
 /* inline for ring buffer fast paths */
-static inline void *
+static void *
 rb_event_data(struct ring_buffer_event *event)
 {
 	BUG_ON(event->type != RINGBUF_TYPE_DATA);
@@ -229,10 +229,9 @@ static void rb_init_page(struct buffer_d
  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
  * this issue out.
  */
-static inline void free_buffer_page(struct buffer_page *bpage)
+static void free_buffer_page(struct buffer_page *bpage)
 {
-	if (bpage->page)
-		free_page((unsigned long)bpage->page);
+	free_page((unsigned long)bpage->page);
 	kfree(bpage);
 }
 
@@ -811,7 +810,7 @@ rb_event_index(struct ring_buffer_event 
 	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
 }
 
-static inline int
+static int
 rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct ring_buffer_event *event)
 {
@@ -825,7 +824,7 @@ rb_is_commit(struct ring_buffer_per_cpu 
 		rb_commit_index(cpu_buffer) == index;
 }
 
-static inline void
+static void
 rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
 		    struct ring_buffer_event *event)
 {
@@ -850,7 +849,7 @@ rb_set_commit_event(struct ring_buffer_p
 	local_set(&cpu_buffer->commit_page->page->commit, index);
 }
 
-static inline void
+static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	/*
@@ -896,7 +895,7 @@ static void rb_reset_reader_page(struct 
 	cpu_buffer->reader_page->read = 0;
 }
 
-static inline void rb_inc_iter(struct ring_buffer_iter *iter)
+static void rb_inc_iter(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 
@@ -926,7 +925,7 @@ static inline void rb_inc_iter(struct ri
  * and with this, we can determine what to place into the
  * data field.
  */
-static inline void
+static void
 rb_update_event(struct ring_buffer_event *event,
 			 unsigned type, unsigned length)
 {
@@ -964,7 +963,7 @@ rb_update_event(struct ring_buffer_event
 	}
 }
 
-static inline unsigned rb_calculate_event_length(unsigned length)
+static unsigned rb_calculate_event_length(unsigned length)
 {
 	struct ring_buffer_event event; /* Used only for sizeof array */
 
@@ -1438,7 +1437,7 @@ int ring_buffer_write(struct ring_buffer
 }
 EXPORT_SYMBOL_GPL(ring_buffer_write);
 
-static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = cpu_buffer->reader_page;
 	struct buffer_page *head = cpu_buffer->head_page;
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

