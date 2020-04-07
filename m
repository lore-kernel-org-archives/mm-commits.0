From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 153/166] kcov: move t->kcov assignments into
 kcov_start/stop
Date: Mon, 06 Apr 2020 20:12:11 -0700
Message-ID: <20200407031211.a1jbNhWts%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDMO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:14 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@gmail.com, andreyknvl@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: move t->kcov assignments into kcov_start/stop

Every time kcov_start/stop() is called, t->kcov is also assigned, so move
the assignment into the functions.

Link: http://lkml.kernel.org/r/6644839d3567df61ade3c4b246a46cacbe4f9e11.1585233617.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/82625ef3ff878f0b585763cc31d09d9b08ca37d6.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/kernel/kcov.c~kcov-move-t-kcov-assignments-into-kcov_start-stop
+++ a/kernel/kcov.c
@@ -309,10 +309,12 @@ void notrace __sanitizer_cov_trace_switc
 EXPORT_SYMBOL(__sanitizer_cov_trace_switch);
 #endif /* ifdef CONFIG_KCOV_ENABLE_COMPARISONS */
 
-static void kcov_start(struct task_struct *t, unsigned int size,
-			void *area, enum kcov_mode mode, int sequence)
+static void kcov_start(struct task_struct *t, struct kcov *kcov,
+			unsigned int size, void *area, enum kcov_mode mode,
+			int sequence)
 {
 	kcov_debug("t = %px, size = %u, area = %px\n", t, size, area);
+	t->kcov = kcov;
 	/* Cache in task struct for performance. */
 	t->kcov_size = size;
 	t->kcov_area = area;
@@ -326,6 +328,7 @@ static void kcov_stop(struct task_struct
 {
 	WRITE_ONCE(t->kcov_mode, KCOV_MODE_DISABLED);
 	barrier();
+	t->kcov = NULL;
 	t->kcov_size = 0;
 	t->kcov_area = NULL;
 }
@@ -333,7 +336,6 @@ static void kcov_stop(struct task_struct
 static void kcov_task_reset(struct task_struct *t)
 {
 	kcov_stop(t);
-	t->kcov = NULL;
 	t->kcov_sequence = 0;
 	t->kcov_handle = 0;
 }
@@ -584,9 +586,8 @@ static int kcov_ioctl_locked(struct kcov
 			return mode;
 		kcov_fault_in_area(kcov);
 		kcov->mode = mode;
-		kcov_start(t, kcov->size, kcov->area, kcov->mode,
+		kcov_start(t, kcov, kcov->size, kcov->area, kcov->mode,
 				kcov->sequence);
-		t->kcov = kcov;
 		kcov->t = t;
 		/* Put either in kcov_task_exit() or in KCOV_DISABLE. */
 		kcov_get(kcov);
@@ -778,7 +779,6 @@ void kcov_remote_start(u64 handle)
 	kcov = remote->kcov;
 	/* Put in kcov_remote_stop(). */
 	kcov_get(kcov);
-	t->kcov = kcov;
 	/*
 	 * Read kcov fields before unlock to prevent races with
 	 * KCOV_DISABLE / kcov_remote_reset().
@@ -792,7 +792,6 @@ void kcov_remote_start(u64 handle)
 	if (!area) {
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
-			t->kcov = NULL;
 			kcov_put(kcov);
 			return;
 		}
@@ -800,7 +799,7 @@ void kcov_remote_start(u64 handle)
 	/* Reset coverage size. */
 	*(u64 *)area = 0;
 
-	kcov_start(t, size, area, mode, sequence);
+	kcov_start(t, kcov, size, area, mode, sequence);
 
 }
 EXPORT_SYMBOL(kcov_remote_start);
@@ -873,7 +872,6 @@ void kcov_remote_stop(void)
 		return;
 
 	kcov_stop(t);
-	t->kcov = NULL;
 
 	spin_lock(&kcov->lock);
 	/*
_
