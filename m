From: akpm@linux-foundation.org
Subject: + fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 21:03:45 -0700
Message-ID: <20200416040345.CVE0zTI2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgDPEDr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 00:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, vvs@virtuozzo.com


The patch titled
     Subject: fs/seq_file.c: seq_read: Update pr_info_ratelimited
has been added to the -mm tree.  Its filename is
     fs-seq_filec-seq_read-update-pr_info_ratelimited.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_filec-seq_read-update-pr_info_ratelimited.patch

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
Subject: fs/seq_file.c: seq_read: Update pr_info_ratelimited

Use a more common logging style.

Add and use pr_fmt, coalesce the format string, align arguments,
use better grammar.

Link: http://lkml.kernel.org/r/96ff603230ca1bd60034c36519be3930c3a3a226.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/seq_file.c~fs-seq_filec-seq_read-update-pr_info_ratelimited
+++ a/fs/seq_file.c
@@ -6,6 +6,8 @@
  * initial implementation -- AV, Oct 2001.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cache.h>
 #include <linux/fs.h>
 #include <linux/export.h>
@@ -233,9 +235,8 @@ Fill:
 
 		p = m->op->next(m, p, &m->index);
 		if (pos == m->index) {
-			pr_info_ratelimited("buggy seq_file .next function %ps "
-				"did not updated position index\n",
-				m->op->next);
+			pr_info_ratelimited("buggy .next function %ps did not update position index\n",
+					    m->op->next);
 			m->index++;
 		}
 		if (!p || IS_ERR(p)) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
