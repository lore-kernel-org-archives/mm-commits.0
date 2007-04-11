From: akpm@linux-foundation.org
Subject: + md-cleanup-use-seq_release_private-where-appropriate.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:08:25 -0700
Message-ID: <200704110008.l3B08PqF023715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbXDKAIf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com, neilb@suse.de


The patch titled
     md: cleanup: use seq_release_private() where appropriate
has been added to the -mm tree.  Its filename is
     md-cleanup-use-seq_release_private-where-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: cleanup: use seq_release_private() where appropriate
From: Martin Peschke <mp3@de.ibm.com>

We can save some lines of code by using seq_release_private().

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   11 +----------
 1 files changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/md/md.c~md-cleanup-use-seq_release_private-where-appropriate drivers/md/md.c
--- a/drivers/md/md.c~md-cleanup-use-seq_release_private-where-appropriate
+++ a/drivers/md/md.c
@@ -4943,15 +4943,6 @@ static int md_seq_open(struct inode *ino
 	return error;
 }
 
-static int md_seq_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = file->private_data;
-	struct mdstat_info *mi = m->private;
-	m->private = NULL;
-	kfree(mi);
-	return seq_release(inode, file);
-}
-
 static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
 {
 	struct seq_file *m = filp->private_data;
@@ -4973,7 +4964,7 @@ static const struct file_operations md_s
 	.open           = md_seq_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
-	.release	= md_seq_release,
+	.release	= seq_release_private,
 	.poll		= mdstat_poll,
 };
 
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
