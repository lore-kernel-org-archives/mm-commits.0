From: akpm@linux-foundation.org
Subject: + kallsyms-cleanup-use-seq_release_private-where-appropriate.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:08:27 -0700
Message-ID: <200704110008.l3B08R7n023718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142AbXDKAId (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     kallsyms: cleanup: use seq_release_private() where appropriate
has been added to the -mm tree.  Its filename is
     kallsyms-cleanup-use-seq_release_private-where-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kallsyms: cleanup: use seq_release_private() where appropriate
From: Martin Peschke <mp3@de.ibm.com>

We can save some lines of code by using seq_release_private().

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    9 +--------
 1 files changed, 1 insertion(+), 8 deletions(-)

diff -puN kernel/kallsyms.c~kallsyms-cleanup-use-seq_release_private-where-appropriate kernel/kallsyms.c
--- a/kernel/kallsyms.c~kallsyms-cleanup-use-seq_release_private-where-appropriate
+++ a/kernel/kallsyms.c
@@ -470,18 +470,11 @@ static int kallsyms_open(struct inode *i
 	return ret;
 }
 
-static int kallsyms_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	kfree(m->private);
-	return seq_release(inode, file);
-}
-
 static const struct file_operations kallsyms_operations = {
 	.open = kallsyms_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = kallsyms_release,
+	.release = seq_release_private,
 };
 
 static int __init kallsyms_init(void)
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
md-cleanup-use-seq_release_private-where-appropriate.patch
kallsyms-cleanup-use-seq_release_private-where-appropriate.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
