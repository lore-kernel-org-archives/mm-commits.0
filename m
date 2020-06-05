From: akpm@linux-foundation.org
Subject: [merged] kcov-cleanup-debug-messages.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:16:11 -0700
Message-ID: <20200605201611.EX5f8-Mme%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgFEUQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, dvyukov@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: kcov: cleanup debug messages
has been removed from the -mm tree.  Its filename was
     kcov-cleanup-debug-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: cleanup debug messages

Patch series "kcov: collect coverage from usb soft interrupts", v4.

This patchset extends kcov to allow collecting coverage from soft
interrupts and then uses the new functionality to collect coverage from
USB code.

This has allowed to find at least one new HID bug [1], which was recently
fixed by Alan [2].

[1] https://syzkaller.appspot.com/bug?extid=09ef48aa58261464b621
[2] https://patchwork.kernel.org/patch/11283319/

Any subsystem that uses softirqs (e.g. timers) can make use of this in
the future. Looking at the recent syzbot reports, an obvious candidate
is the networking subsystem [3, 4, 5 and many more].

[3] https://syzkaller.appspot.com/bug?extid=522ab502c69badc66ab7
[4] https://syzkaller.appspot.com/bug?extid=57f89d05946c53dbbb31
[5] https://syzkaller.appspot.com/bug?extid=df358e65d9c1b9d3f5f4


This pach (of 7):

Previous commit left a lot of excessive debug messages, clean them up.

Link; http://lkml.kernel.org/r/cover.1585233617.git.andreyknvl@google.com
Link; http://lkml.kernel.org/r/ab5e2885ce674ba6e04368551e51eeb6a2c11baf.1585233617.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/4a497134b2cf7a9d306d28e3dd2746f5446d1605.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/kernel/kcov.c~kcov-cleanup-debug-messages
+++ a/kernel/kcov.c
@@ -98,6 +98,7 @@ static struct kcov_remote *kcov_remote_f
 	return NULL;
 }
 
+/* Must be called with kcov_remote_lock locked. */
 static struct kcov_remote *kcov_remote_add(struct kcov *kcov, u64 handle)
 {
 	struct kcov_remote *remote;
@@ -119,16 +120,13 @@ static struct kcov_remote_area *kcov_rem
 	struct kcov_remote_area *area;
 	struct list_head *pos;
 
-	kcov_debug("size = %u\n", size);
 	list_for_each(pos, &kcov_remote_areas) {
 		area = list_entry(pos, struct kcov_remote_area, list);
 		if (area->size == size) {
 			list_del(&area->list);
-			kcov_debug("rv = %px\n", area);
 			return area;
 		}
 	}
-	kcov_debug("rv = NULL\n");
 	return NULL;
 }
 
@@ -136,7 +134,6 @@ static struct kcov_remote_area *kcov_rem
 static void kcov_remote_area_put(struct kcov_remote_area *area,
 					unsigned int size)
 {
-	kcov_debug("area = %px, size = %u\n", area, size);
 	INIT_LIST_HEAD(&area->list);
 	area->size = size;
 	list_add(&area->list, &kcov_remote_areas);
@@ -366,7 +363,6 @@ static void kcov_remote_reset(struct kco
 	hash_for_each_safe(kcov_remote_map, bkt, tmp, remote, hnode) {
 		if (remote->kcov != kcov)
 			continue;
-		kcov_debug("removing handle %llx\n", remote->handle);
 		hash_del(&remote->hnode);
 		kfree(remote);
 	}
@@ -553,7 +549,6 @@ static int kcov_ioctl_locked(struct kcov
 
 	switch (cmd) {
 	case KCOV_INIT_TRACE:
-		kcov_debug("KCOV_INIT_TRACE\n");
 		/*
 		 * Enable kcov in trace mode and setup buffer size.
 		 * Must happen before anything else.
@@ -572,7 +567,6 @@ static int kcov_ioctl_locked(struct kcov
 		kcov->mode = KCOV_MODE_INIT;
 		return 0;
 	case KCOV_ENABLE:
-		kcov_debug("KCOV_ENABLE\n");
 		/*
 		 * Enable coverage for the current task.
 		 * At this point user must have been enabled trace mode,
@@ -598,7 +592,6 @@ static int kcov_ioctl_locked(struct kcov
 		kcov_get(kcov);
 		return 0;
 	case KCOV_DISABLE:
-		kcov_debug("KCOV_DISABLE\n");
 		/* Disable coverage for the current task. */
 		unused = arg;
 		if (unused != 0 || current->kcov != kcov)
@@ -610,7 +603,6 @@ static int kcov_ioctl_locked(struct kcov
 		kcov_put(kcov);
 		return 0;
 	case KCOV_REMOTE_ENABLE:
-		kcov_debug("KCOV_REMOTE_ENABLE\n");
 		if (kcov->mode != KCOV_MODE_INIT || !kcov->area)
 			return -EINVAL;
 		t = current;
@@ -629,7 +621,6 @@ static int kcov_ioctl_locked(struct kcov
 		kcov->remote_size = remote_arg->area_size;
 		spin_lock(&kcov_remote_lock);
 		for (i = 0; i < remote_arg->num_handles; i++) {
-			kcov_debug("handle %llx\n", remote_arg->handles[i]);
 			if (!kcov_check_handle(remote_arg->handles[i],
 						false, true, false)) {
 				spin_unlock(&kcov_remote_lock);
@@ -644,8 +635,6 @@ static int kcov_ioctl_locked(struct kcov
 			}
 		}
 		if (remote_arg->common_handle) {
-			kcov_debug("common handle %llx\n",
-					remote_arg->common_handle);
 			if (!kcov_check_handle(remote_arg->common_handle,
 						true, false, false)) {
 				spin_unlock(&kcov_remote_lock);
@@ -782,7 +771,6 @@ void kcov_remote_start(u64 handle)
 	spin_lock(&kcov_remote_lock);
 	remote = kcov_remote_find(handle);
 	if (!remote) {
-		kcov_debug("no remote found");
 		spin_unlock(&kcov_remote_lock);
 		return;
 	}
@@ -810,8 +798,6 @@ void kcov_remote_start(u64 handle)
 	/* Reset coverage size. */
 	*(u64 *)area = 0;
 
-	kcov_debug("area = %px, size = %u", area, size);
-
 	kcov_start(t, size, area, mode, sequence);
 
 }
@@ -881,10 +867,8 @@ void kcov_remote_stop(void)
 	unsigned int size = t->kcov_size;
 	int sequence = t->kcov_sequence;
 
-	if (!kcov) {
-		kcov_debug("no kcov found\n");
+	if (!kcov)
 		return;
-	}
 
 	kcov_stop(t);
 	t->kcov = NULL;
@@ -894,8 +878,6 @@ void kcov_remote_stop(void)
 	 * KCOV_DISABLE could have been called between kcov_remote_start()
 	 * and kcov_remote_stop(), hence the check.
 	 */
-	kcov_debug("move if: %d == %d && %d\n",
-		sequence, kcov->sequence, (int)kcov->remote);
 	if (sequence == kcov->sequence && kcov->remote)
 		kcov_move_area(kcov->mode, kcov->area, kcov->size, area);
 	spin_unlock(&kcov->lock);
_

Patches currently in -mm which might be from andreyknvl@google.com are
