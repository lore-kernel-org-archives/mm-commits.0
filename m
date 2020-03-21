From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-move-t-kcov_sequence-assignment.patch added to -mm
 tree
Date: Fri, 20 Mar 2020 17:27:09 -0700
Message-ID: <20200321002709._o_OdrBo0%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCUA1K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:27:10 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: kcov: move t->kcov_sequence assignment
has been added to the -mm tree.  Its filename is
     kcov-move-t-kcov_sequence-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-move-t-kcov_sequence-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-move-t-kcov_sequence-assignment.patch

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
Subject: kcov: move t->kcov_sequence assignment

Move t->kcov_sequence assignment before assigning t->kcov_mode for
consistency.

Link: http://lkml.kernel.org/r/f0283c676bab3335cb48bfe12d375a3da4719f59.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-move-t-kcov_sequence-assignment
+++ a/kernel/kcov.c
@@ -318,10 +318,10 @@ static void kcov_start(struct task_struc
 	/* Cache in task struct for performance. */
 	t->kcov_size = size;
 	t->kcov_area = area;
+	t->kcov_sequence = sequence;
 	/* See comment in check_kcov_mode(). */
 	barrier();
 	WRITE_ONCE(t->kcov_mode, mode);
-	t->kcov_sequence = sequence;
 }
 
 static void kcov_stop(struct task_struct *t)
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kcov-fix-potential-use-after-free-in-kcov_remote_start.patch
kcov-move-t-kcov-assignments-into-kcov_start-stop.patch
kcov-move-t-kcov_sequence-assignment.patch
kcov-use-t-kcov_mode-as-enabled-indicator.patch
