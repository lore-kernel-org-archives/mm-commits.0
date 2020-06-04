From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 092/127] fs/seq_file.c: seq_read: Update
 pr_info_ratelimited
Date: Thu, 04 Jun 2020 16:51:02 -0700
Message-ID: <20200604235102.7IOqkSbsJ%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgFDXvD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:51:03 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vvs@virtuozzo.com

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
