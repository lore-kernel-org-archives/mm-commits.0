From: akpm@linux-foundation.org
Subject: + mm-vmstat-standardize-file-operations-variable-names.patch
 added to -mm tree
Date: Fri, 12 May 2017 14:07:26 -0700
Message-ID: <5916240e.yAx05GzPriHOUqSi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758364AbdELVH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: standardize file operations variable names
has been added to the -mm tree.  Its filename is
     mm-vmstat-standardize-file-operations-variable-names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-standardize-file-operations-variable-names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-standardize-file-operations-variable-names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/vmstat.c: standardize file operations variable names

Standardize the file operation variable names related to all four memory
management /proc interface files.  Also change all the symbol permissions
(S_IRUGO) into octal permissions (0444) as it got complaints from
checkpatch.pl.  This does not create any functional change to the
interface.

Link: http://lkml.kernel.org/r/20170427030632.8588-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-standardize-file-operations-variable-names mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-standardize-file-operations-variable-names
+++ a/mm/vmstat.c
@@ -1322,7 +1322,7 @@ static int fragmentation_open(struct ino
 	return seq_open(file, &fragmentation_op);
 }
 
-static const struct file_operations fragmentation_file_operations = {
+static const struct file_operations buddyinfo_file_operations = {
 	.open		= fragmentation_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1341,7 +1341,7 @@ static int pagetypeinfo_open(struct inod
 	return seq_open(file, &pagetypeinfo_op);
 }
 
-static const struct file_operations pagetypeinfo_file_ops = {
+static const struct file_operations pagetypeinfo_file_operations = {
 	.open		= pagetypeinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1463,7 +1463,7 @@ static int zoneinfo_open(struct inode *i
 	return seq_open(file, &zoneinfo_op);
 }
 
-static const struct file_operations proc_zoneinfo_file_operations = {
+static const struct file_operations zoneinfo_file_operations = {
 	.open		= zoneinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1552,7 +1552,7 @@ static int vmstat_open(struct inode *ino
 	return seq_open(file, &vmstat_op);
 }
 
-static const struct file_operations proc_vmstat_file_operations = {
+static const struct file_operations vmstat_file_operations = {
 	.open		= vmstat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1785,10 +1785,10 @@ void __init init_mm_internals(void)
 	start_shepherd_timer();
 #endif
 #ifdef CONFIG_PROC_FS
-	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
-	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
-	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
-	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
+	proc_create("buddyinfo", 0444, NULL, &buddyinfo_file_operations);
+	proc_create("pagetypeinfo", 0444, NULL, &pagetypeinfo_file_operations);
+	proc_create("vmstat", 0444, NULL, &vmstat_file_operations);
+	proc_create("zoneinfo", 0444, NULL, &zoneinfo_file_operations);
 #endif
 }
 
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-vmstat-standardize-file-operations-variable-names.patch

