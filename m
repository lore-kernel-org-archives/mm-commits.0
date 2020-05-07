From: akpm@linux-foundation.org
Subject: + percpu_ref-use-a-more-common-logging-style.patch added
 to -mm tree
Date: Thu, 07 May 2020 16:30:21 -0700
Message-ID: <20200507233021.PLOKVHNPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEGXaW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 19:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu-refcount.c: use a more common logging style
has been added to the -mm tree.  Its filename is
     percpu_ref-use-a-more-common-logging-style.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu_ref-use-a-more-common-logging-style.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu_ref-use-a-more-common-logging-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: lib/percpu-refcount.c: use a more common logging style

Remove the trailing newline from the used-once pr_fmt and add it to the
single use of pr_<level> in this code to use a more common logging style.

Miscellanea:

o Use %lu in the pr_debug format and remove the unnecessary cast

Link: http://lkml.kernel.org/r/47372467902a047c03b0fd29aab56e0c38d3f848.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/percpu-refcount.c~percpu_ref-use-a-more-common-logging-style
+++ a/lib/percpu-refcount.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+#define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -141,8 +141,8 @@ static void percpu_ref_switch_to_atomic_
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(percpu_count, cpu);
 
-	pr_debug("global %ld percpu %ld",
-		 atomic_long_read(&ref->count), (long)count);
+	pr_debug("global %lu percpu %lu\n",
+		 atomic_long_read(&ref->count), count);
 
 	/*
 	 * It's crucial that we sum the percpu counters _before_ adding the sum
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-email-addresses-from-yaml-files.patch
percpu_ref-use-a-more-common-logging-style.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
checkpatch-disallow-git-and-file-fix.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
