From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:07 -0700
Message-ID: <200708250519.l7P5J7NT031944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbXHYFaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure: small cleanup in debugfs write function
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure: small cleanup in debugfs write function
From: Martin Peschke <mp3@de.ibm.com>

Code looks more sane with this little cleanup, although both memcpy() and
kfree() are supposed to cope with NULL pointer or zero length respectively.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/statistic.c~statistics-infrastructure-small-cleanup-in-debugfs-write-function lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-small-cleanup-in-debugfs-write-function
+++ a/lib/statistic.c
@@ -631,11 +631,13 @@ static ssize_t statistic_write_def(struc
 	if (!larger)
 		return -ENOMEM;
 	larger[*offset + len] = '\0';
-	memcpy(larger, seq_priv->w_buf, *offset);
+	if (seq_priv->w_buf) {
+		memcpy(larger, seq_priv->w_buf, *offset);
+		kfree(seq_priv->w_buf);
+	}
 	if (copy_from_user(larger + *offset, buf, len))
 		return -EFAULT;
 	*offset += len;
-	kfree(seq_priv->w_buf);
 	seq_priv->w_buf = larger;
 	seq_priv->w_offset = *offset;
 	return len;
_

Patches currently in -mm which might be from mp3@de.ibm.com are
