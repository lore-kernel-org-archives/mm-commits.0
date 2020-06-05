From: akpm@linux-foundation.org
Subject: [merged] kcov-move-t-kcov_sequence-assignment.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:16:21 -0700
Message-ID: <20200605201621.-GUCc43_N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUQW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, dvyukov@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: kcov: move t->kcov_sequence assignment
has been removed from the -mm tree.  Its filename was
     kcov-move-t-kcov_sequence-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: move t->kcov_sequence assignment

Move t->kcov_sequence assignment before assigning t->kcov_mode for
consistency.

Link: http://lkml.kernel.org/r/5889efe35e0b300e69dba97216b1288d9c2428a8.1585233617.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/f0283c676bab3335cb48bfe12d375a3da4719f59.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

Patches currently in -mm which might be from andreyknvl@google.com are
