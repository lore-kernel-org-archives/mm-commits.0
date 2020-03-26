From: akpm@linux-foundation.org
Subject: + kcov-collect-coverage-from-interrupts-v4.patch added to
 -mm tree
Date: Thu, 26 Mar 2020 12:37:29 -0700
Message-ID: <20200326193729.oXkwDMpkd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZTha (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 15:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: kcov-collect-coverage-from-interrupts-v4
has been added to the -mm tree.  Its filename is
     kcov-collect-coverage-from-interrupts-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-collect-coverage-from-interrupts-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-collect-coverage-from-interrupts-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov-collect-coverage-from-interrupts-v4

turn current->kcov_softirq into unsigned int to fix objtool warning

Link: http://lkml.kernel.org/r/841c778aa3849c5cb8c3761f56b87ce653a88671.1585233617.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/kcov.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/sched.h~kcov-collect-coverage-from-interrupts-v4
+++ a/include/linux/sched.h
@@ -1232,7 +1232,7 @@ struct task_struct {
 	int				kcov_sequence;
 
 	/* Collect coverage from softirq context: */
-	bool				kcov_softirq;
+	unsigned int			kcov_softirq;
 #endif
 
 #ifdef CONFIG_MEMCG
--- a/kernel/kcov.c~kcov-collect-coverage-from-interrupts-v4
+++ a/kernel/kcov.c
@@ -886,7 +886,7 @@ void kcov_remote_start(u64 handle)
 
 	if (in_serving_softirq()) {
 		kcov_remote_softirq_start(t);
-		t->kcov_softirq = true;
+		t->kcov_softirq = 1;
 	}
 	kcov_start(t, kcov, size, area, mode, sequence);
 
@@ -984,7 +984,7 @@ void kcov_remote_stop(void)
 
 	kcov_stop(t);
 	if (in_serving_softirq()) {
-		t->kcov_softirq = false;
+		t->kcov_softirq = 0;
 		kcov_remote_softirq_stop(t);
 	}
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-cleanup-debug-messages.patch
kcov-fix-potential-use-after-free-in-kcov_remote_start.patch
kcov-move-t-kcov-assignments-into-kcov_start-stop.patch
kcov-move-t-kcov_sequence-assignment.patch
kcov-use-t-kcov_mode-as-enabled-indicator.patch
kcov-collect-coverage-from-interrupts.patch
kcov-collect-coverage-from-interrupts-v4.patch
usb-core-kcov-collect-coverage-from-usb-complete-callback.patch
