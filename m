From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-fix-string-termination.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:03:08 -0700
Message-ID: <200704110003.l3B038DK023619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161133AbXDKADh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     statistics infrastructure: fix string termination
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-fix-string-termination.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
add-for_each_substring-and-match_substring.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch
statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch
statistics-infrastructure-fix-string-termination.patch
statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch
statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch
statistics-infrastructure-exploitation-zfcp.patch
