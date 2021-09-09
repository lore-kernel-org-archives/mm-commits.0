Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AF5C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25643611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348125AbhIIVEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347339AbhIIVDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ED74611C4;
        Thu,  9 Sep 2021 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221344;
        bh=0ZEgAEhSiAHBA9IZW0ReEq8fvTVtQ3XClcQ4TODxfIg=;
        h=Date:From:To:Subject:From;
        b=on0n1nSyJ210pXmXTgc5aETQXDfv1BLyfRoYS0dZK6MZS0GegIZQOQuPWK0jL0o2m
         rYeSlR5enylU+d0FRPlmyKoGOyG08dxSkHKa1W7K0QWbo+AHfYy8lOPKlLhhrHjdWD
         dbCnC/4kGLl7SKMuhff5yexdFpnOJlZwDNoOPpqk=
Date:   Thu, 09 Sep 2021 14:02:24 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, glider@google.com, joern@purestorage.com,
        mm-commits@vger.kernel.org, yzhong@purestorage.com
Subject:  [merged]
 kfence-show-cpu-and-timestamp-in-alloc-free-info.patch removed from -mm
 tree
Message-ID: <20210909210224.sFQkCYWGt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: show cpu and timestamp in alloc/free info
has been removed from the -mm tree.  Its filename was
     kfence-show-cpu-and-timestamp-in-alloc-free-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: show cpu and timestamp in alloc/free info

Record cpu and timestamp on allocations and frees, and show them in
reports.  Upon an error, this can help correlate earlier messages in the
kernel log via allocation and free timestamps.

Link: https://lkml.kernel.org/r/20210714175312.2947941-1-elver@google.com
Suggested-by: Joern Engel <joern@purestorage.com>
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Acked-by: Joern Engel <joern@purestorage.com>
Cc: Yuanyuan Zhong <yzhong@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   98 ++++++++++++++-------------
 mm/kfence/core.c                   |    3 
 mm/kfence/kfence.h                 |    2 
 mm/kfence/report.c                 |   19 +++--
 4 files changed, 71 insertions(+), 51 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-show-cpu-and-timestamp-in-alloc-free-info
+++ a/Documentation/dev-tools/kfence.rst
@@ -65,25 +65,27 @@ Error reports
 A typical out-of-bounds access looks like this::
 
     ==================================================================
-    BUG: KFENCE: out-of-bounds read in test_out_of_bounds_read+0xa3/0x22b
+    BUG: KFENCE: out-of-bounds read in test_out_of_bounds_read+0xa6/0x234
 
-    Out-of-bounds read at 0xffffffffb672efff (1B left of kfence-#17):
-     test_out_of_bounds_read+0xa3/0x22b
-     kunit_try_run_case+0x51/0x85
+    Out-of-bounds read at 0xffff8c3f2e291fff (1B left of kfence-#72):
+     test_out_of_bounds_read+0xa6/0x234
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    kfence-#17 [0xffffffffb672f000-0xffffffffb672f01f, size=32, cache=kmalloc-32] allocated by task 507:
-     test_alloc+0xf3/0x25b
-     test_out_of_bounds_read+0x98/0x22b
-     kunit_try_run_case+0x51/0x85
+    kfence-#72: 0xffff8c3f2e292000-0xffff8c3f2e29201f, size=32, cache=kmalloc-32
+
+    allocated by task 484 on cpu 0 at 32.919330s:
+     test_alloc+0xfe/0x738
+     test_out_of_bounds_read+0x9b/0x234
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    CPU: 4 PID: 107 Comm: kunit_try_catch Not tainted 5.8.0-rc6+ #7
-    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    CPU: 0 PID: 484 Comm: kunit_try_catch Not tainted 5.13.0-rc3+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
     ==================================================================
 
 The header of the report provides a short summary of the function involved in
@@ -96,30 +98,32 @@ Use-after-free accesses are reported as:
     ==================================================================
     BUG: KFENCE: use-after-free read in test_use_after_free_read+0xb3/0x143
 
-    Use-after-free read at 0xffffffffb673dfe0 (in kfence-#24):
+    Use-after-free read at 0xffff8c3f2e2a0000 (in kfence-#79):
      test_use_after_free_read+0xb3/0x143
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    kfence-#24 [0xffffffffb673dfe0-0xffffffffb673dfff, size=32, cache=kmalloc-32] allocated by task 507:
-     test_alloc+0xf3/0x25b
+    kfence-#79: 0xffff8c3f2e2a0000-0xffff8c3f2e2a001f, size=32, cache=kmalloc-32
+
+    allocated by task 488 on cpu 2 at 33.871326s:
+     test_alloc+0xfe/0x738
      test_use_after_free_read+0x76/0x143
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    freed by task 507:
+    freed by task 488 on cpu 2 at 33.871358s:
      test_use_after_free_read+0xa8/0x143
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    CPU: 4 PID: 109 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
-    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    CPU: 2 PID: 488 Comm: kunit_try_catch Tainted: G    B             5.13.0-rc3+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
     ==================================================================
 
 KFENCE also reports on invalid frees, such as double-frees::
@@ -127,30 +131,32 @@ KFENCE also reports on invalid frees, su
     ==================================================================
     BUG: KFENCE: invalid free in test_double_free+0xdc/0x171
 
-    Invalid free of 0xffffffffb6741000:
+    Invalid free of 0xffff8c3f2e2a4000 (in kfence-#81):
      test_double_free+0xdc/0x171
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    kfence-#26 [0xffffffffb6741000-0xffffffffb674101f, size=32, cache=kmalloc-32] allocated by task 507:
-     test_alloc+0xf3/0x25b
+    kfence-#81: 0xffff8c3f2e2a4000-0xffff8c3f2e2a401f, size=32, cache=kmalloc-32
+
+    allocated by task 490 on cpu 1 at 34.175321s:
+     test_alloc+0xfe/0x738
      test_double_free+0x76/0x171
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    freed by task 507:
+    freed by task 490 on cpu 1 at 34.175348s:
      test_double_free+0xa8/0x171
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    CPU: 4 PID: 111 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
-    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    CPU: 1 PID: 490 Comm: kunit_try_catch Tainted: G    B             5.13.0-rc3+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
     ==================================================================
 
 KFENCE also uses pattern-based redzones on the other side of an object's guard
@@ -160,23 +166,25 @@ These are reported on frees::
     ==================================================================
     BUG: KFENCE: memory corruption in test_kmalloc_aligned_oob_write+0xef/0x184
 
-    Corrupted memory at 0xffffffffb6797ff9 [ 0xac . . . . . . ] (in kfence-#69):
+    Corrupted memory at 0xffff8c3f2e33aff9 [ 0xac . . . . . . ] (in kfence-#156):
      test_kmalloc_aligned_oob_write+0xef/0x184
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    kfence-#69 [0xffffffffb6797fb0-0xffffffffb6797ff8, size=73, cache=kmalloc-96] allocated by task 507:
-     test_alloc+0xf3/0x25b
+    kfence-#156: 0xffff8c3f2e33afb0-0xffff8c3f2e33aff8, size=73, cache=kmalloc-96
+
+    allocated by task 502 on cpu 7 at 42.159302s:
+     test_alloc+0xfe/0x738
      test_kmalloc_aligned_oob_write+0x57/0x184
-     kunit_try_run_case+0x51/0x85
+     kunit_try_run_case+0x61/0xa0
      kunit_generic_run_threadfn_adapter+0x16/0x30
-     kthread+0x137/0x160
+     kthread+0x176/0x1b0
      ret_from_fork+0x22/0x30
 
-    CPU: 4 PID: 120 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
-    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    CPU: 7 PID: 502 Comm: kunit_try_catch Tainted: G    B             5.13.0-rc3+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
     ==================================================================
 
 For such errors, the address where the corruption occurred as well as the
--- a/mm/kfence/core.c~kfence-show-cpu-and-timestamp-in-alloc-free-info
+++ a/mm/kfence/core.c
@@ -20,6 +20,7 @@
 #include <linux/moduleparam.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/clock.h>
 #include <linux/sched/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -196,6 +197,8 @@ static noinline void metadata_update_sta
 	 */
 	track->num_stack_entries = stack_trace_save(track->stack_entries, KFENCE_STACK_DEPTH, 1);
 	track->pid = task_pid_nr(current);
+	track->cpu = raw_smp_processor_id();
+	track->ts_nsec = local_clock(); /* Same source as printk timestamps. */
 
 	/*
 	 * Pairs with READ_ONCE() in
--- a/mm/kfence/kfence.h~kfence-show-cpu-and-timestamp-in-alloc-free-info
+++ a/mm/kfence/kfence.h
@@ -36,6 +36,8 @@ enum kfence_object_state {
 /* Alloc/free tracking information. */
 struct kfence_track {
 	pid_t pid;
+	int cpu;
+	u64 ts_nsec;
 	int num_stack_entries;
 	unsigned long stack_entries[KFENCE_STACK_DEPTH];
 };
--- a/mm/kfence/report.c~kfence-show-cpu-and-timestamp-in-alloc-free-info
+++ a/mm/kfence/report.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
+#include <linux/math.h>
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
 #include <linux/seq_file.h>
@@ -100,6 +101,13 @@ static void kfence_print_stack(struct se
 			       bool show_alloc)
 {
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
+	u64 ts_sec = track->ts_nsec;
+	unsigned long rem_nsec = do_div(ts_sec, NSEC_PER_SEC);
+
+	/* Timestamp matches printk timestamp format. */
+	seq_con_printf(seq, "%s by task %d on cpu %d at %lu.%06lus:\n",
+		       show_alloc ? "allocated" : "freed", track->pid,
+		       track->cpu, (unsigned long)ts_sec, rem_nsec / 1000);
 
 	if (track->num_stack_entries) {
 		/* Skip allocation/free internals stack. */
@@ -126,15 +134,14 @@ void kfence_print_object(struct seq_file
 		return;
 	}
 
-	seq_con_printf(seq,
-		       "kfence-#%td [0x%p-0x%p"
-		       ", size=%d, cache=%s] allocated by task %d:\n",
-		       meta - kfence_metadata, (void *)start, (void *)(start + size - 1), size,
-		       (cache && cache->name) ? cache->name : "<destroyed>", meta->alloc_track.pid);
+	seq_con_printf(seq, "kfence-#%td: 0x%p-0x%p, size=%d, cache=%s\n\n",
+		       meta - kfence_metadata, (void *)start, (void *)(start + size - 1),
+		       size, (cache && cache->name) ? cache->name : "<destroyed>");
+
 	kfence_print_stack(seq, meta, true);
 
 	if (meta->state == KFENCE_OBJECT_FREED) {
-		seq_con_printf(seq, "\nfreed by task %d:\n", meta->free_track.pid);
+		seq_con_printf(seq, "\n");
 		kfence_print_stack(seq, meta, false);
 	}
 }
_

Patches currently in -mm which might be from elver@google.com are


