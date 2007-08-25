From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-fix-string-termination.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:47 -0700
Message-ID: <200708250518.l7P5Il6U031908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbXHYFSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure: fix string termination
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-fix-string-termination.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure: fix string termination
From: Martin Peschke <mp3@de.ibm.com>

Make sure strsep() in statistic_release_def() finds a terminanal '\0' and
doesn't attempt to access bytes outside the given buffer.

(Patch fixes
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch)

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/statistic.c~statistics-infrastructure-fix-string-termination lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-fix-string-termination
+++ a/lib/statistic.c
@@ -627,9 +627,10 @@ static ssize_t statistic_write_def(struc
 		return -EPIPE;
 	if (*offset + len > 16 * PAGE_SIZE)
 		return -ENOMEM;
-	larger = kmalloc(*offset + len, GFP_KERNEL);
+	larger = kmalloc(*offset + len + 1, GFP_KERNEL);
 	if (!larger)
 		return -ENOMEM;
+	larger[*offset + len] = '\0';
 	memcpy(larger, seq_priv->w_buf, *offset);
 	if (copy_from_user(larger + *offset, buf, len))
 		return -EFAULT;
_

Patches currently in -mm which might be from mp3@de.ibm.com are
