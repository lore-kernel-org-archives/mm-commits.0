From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-use-t-kcov_mode-as-enabled-indicator.patch added
 to -mm tree
Date: Fri, 20 Mar 2020 17:27:11 -0700
Message-ID: <20200321002711.gp9RUpUZL%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCUA1N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:27:13 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: kcov: use t->kcov_mode as enabled indicator
has been added to the -mm tree.  Its filename is
     kcov-use-t-kcov_mode-as-enabled-indicator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-use-t-kcov_mode-as-enabled-indicator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-use-t-kcov_mode-as-enabled-indicator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kcov: use t->kcov_mode as enabled indicator

Currently kcov_remote_start() and kcov_remote_stop() check t->kcov to find
out whether the coverage is already being collected by the current task. 
Use t->kcov_mode for that instead.  This doesn't change the overall
behavior in any way, but serves as a preparation for the following softirq
coverage collection support patch.

Link: http://lkml.kernel.org/r/ee1a1dec43059da5d7664c85c1addc89c4cd58de.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/kernel/kcov.c~kcov-use-t-kcov_mode-as-enabled-indicator
+++ a/kernel/kcov.c
@@ -746,26 +746,33 @@ static const struct file_operations kcov
  * In turns kcov_remote_stop() clears those pointers from task_struct to stop
  * collecting coverage and copies all collected coverage into the kcov area.
  */
+
+static inline bool kcov_mode_enabled(unsigned int mode)
+{
+	return (mode & ~KCOV_IN_CTXSW) != KCOV_MODE_DISABLED;
+}
+
 void kcov_remote_start(u64 handle)
 {
+	struct task_struct *t = current;
 	struct kcov_remote *remote;
 	struct kcov *kcov;
+	unsigned int mode;
 	void *area;
-	struct task_struct *t;
 	unsigned int size;
-	enum kcov_mode mode;
 	int sequence;
 
 	if (WARN_ON(!kcov_check_handle(handle, true, true, true)))
 		return;
 	if (WARN_ON(!in_task()))
 		return;
-	t = current;
+
 	/*
 	 * Check that kcov_remote_start is not called twice
 	 * nor called by user tasks (with enabled kcov).
 	 */
-	if (WARN_ON(t->kcov))
+	mode = READ_ONCE(t->kcov_mode);
+	if (WARN_ON(kcov_mode_enabled(mode)))
 		return;
 
 	kcov_debug("handle = %llx\n", handle);
@@ -863,13 +870,20 @@ static void kcov_move_area(enum kcov_mod
 void kcov_remote_stop(void)
 {
 	struct task_struct *t = current;
-	struct kcov *kcov = t->kcov;
-	void *area = t->kcov_area;
-	unsigned int size = t->kcov_size;
-	int sequence = t->kcov_sequence;
+	struct kcov *kcov;
+	unsigned int mode;
+	void *area;
+	unsigned int size;
+	int sequence;
 
-	if (!kcov)
-		return;
+	mode = READ_ONCE(t->kcov_mode);
+	barrier();
+	if (!kcov_mode_enabled(mode))
+		return;
+	kcov = t->kcov;
+	area = t->kcov_area;
+	size = t->kcov_size;
+	sequence = t->kcov_sequence;
 
 	kcov_stop(t);
 
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kcov-fix-potential-use-after-free-in-kcov_remote_start.patch
kcov-move-t-kcov-assignments-into-kcov_start-stop.patch
kcov-move-t-kcov_sequence-assignment.patch
kcov-use-t-kcov_mode-as-enabled-indicator.patch
