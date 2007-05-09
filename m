From: akpm@linux-foundation.org
Subject: - proc-cleanup-use-seq_release_private-where-appropriate.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:34 -0700
Message-ID: <200705090249.l492nYsa009237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969659AbXEICti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     proc: cleanup: use seq_release_private() where appropriate
has been removed from the -mm tree.  Its filename was
     proc-cleanup-use-seq_release_private-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: cleanup: use seq_release_private() where appropriate
From: Martin Peschke <mp3@de.ibm.com>

We can save some lines of code by using seq_release_private().

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/proc/proc_misc.c~proc-cleanup-use-seq_release_private-where-appropriate fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-cleanup-use-seq_release_private-where-appropriate
+++ a/fs/proc/proc_misc.c
@@ -428,18 +428,11 @@ static int slabstats_open(struct inode *
 	return ret;
 }
 
-static int slabstats_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = file->private_data;
-	kfree(m->private);
-	return seq_release(inode, file);
-}
-
 static const struct file_operations proc_slabstats_operations = {
 	.open		= slabstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= slabstats_release,
+	.release	= seq_release_private,
 };
 #endif
 #endif
_

Patches currently in -mm which might be from mp3@de.ibm.com are

origin.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
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
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch
statistics-infrastructure-statistics-fix-sorted-list.patch
statistics-infrastructure-exploitation-zfcp.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
