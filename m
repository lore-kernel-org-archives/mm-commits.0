From: akpm@linux-foundation.org
Subject: - sunrpc-cleanup-use-seq_release_private-where-appropriate.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:53:50 -0700
Message-ID: <200704281053.l3SAroVD020097@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965695AbXD1KyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, davem@davemloft.net, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: cleanup: use seq_release_private() where appropriate
has been removed from the -mm tree.  Its filename was
     sunrpc-cleanup-use-seq_release_private-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunrpc: cleanup: use seq_release_private() where appropriate
From: Martin Peschke <mp3@de.ibm.com>

We can save some lines of code by using seq_release_private().

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Acked-by: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN net/sunrpc/cache.c~sunrpc-cleanup-use-seq_release_private-where-appropriate net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-cleanup-use-seq_release_private-where-appropriate
+++ a/net/sunrpc/cache.c
@@ -1237,20 +1237,12 @@ static int content_open(struct inode *in
 
 	return res;
 }
-static int content_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct handle *han = m->private;
-	kfree(han);
-	m->private = NULL;
-	return seq_release(inode, file);
-}
 
 static const struct file_operations content_file_operations = {
 	.open		= content_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= content_release,
+	.release	= seq_release_private,
 };
 
 static ssize_t read_flush(struct file *file, char __user *buf,
_

Patches currently in -mm which might be from mp3@de.ibm.com are

origin.patch
kallsyms-cleanup-use-seq_release_private-where-appropriate.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
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
