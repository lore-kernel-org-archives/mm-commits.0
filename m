From: akpm@osdl.org
Subject: - always-print-out-the-header-line-in-proc-swaps.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:07 -0800
Message-ID: <200612072257.kB7Mv7mJ029259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50592 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163584AbWLGW50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssouhlal@FreeBSD.org, hugh@veritas.com, suleiman@google.com, mm-commits@vger.kernel.org


The patch titled
     Always print out the header line in /proc/swaps
has been removed from the -mm tree.  Its filename was
     always-print-out-the-header-line-in-proc-swaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Always print out the header line in /proc/swaps
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>

It would be possible for /proc/swaps to not always print out the header:

swapon /dev/hdc2
swapon /dev/hde2
swapoff /dev/hdc2

At this point /proc/swaps would not have a header.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swapfile.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~always-print-out-the-header-line-in-proc-swaps mm/swapfile.c
--- a/mm/swapfile.c~always-print-out-the-header-line-in-proc-swaps
+++ a/mm/swapfile.c
@@ -1274,10 +1274,13 @@ static void *swap_start(struct seq_file 
 
 	mutex_lock(&swapon_mutex);
 
+	if (!l)
+		return SEQ_START_TOKEN;
+
 	for (i = 0; i < nr_swapfiles; i++, ptr++) {
 		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
 			continue;
-		if (!l--)
+		if (!--l)
 			return ptr;
 	}
 
@@ -1286,10 +1289,17 @@ static void *swap_start(struct seq_file 
 
 static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 {
-	struct swap_info_struct *ptr = v;
+	struct swap_info_struct *ptr;
 	struct swap_info_struct *endptr = swap_info + nr_swapfiles;
 
-	for (++ptr; ptr < endptr; ptr++) {
+	if (v == SEQ_START_TOKEN)
+		ptr = swap_info;
+	else {
+		ptr = v;
+		ptr++;
+	}
+
+	for (; ptr < endptr; ptr++) {
 		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
 			continue;
 		++*pos;
@@ -1310,8 +1320,10 @@ static int swap_show(struct seq_file *sw
 	struct file *file;
 	int len;
 
-	if (v == swap_info)
-		seq_puts(swap, "Filename\t\t\t\tType\t\tSize\tUsed\tPriority\n");
+	if (ptr == SEQ_START_TOKEN) {
+		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\tUsed\tPriority\n");
+		return 0;
+	}
 
 	file = ptr->swap_file;
 	len = seq_path(swap, file->f_vfsmnt, file->f_dentry, " \t\n\\");
_

Patches currently in -mm which might be from ssouhlal@FreeBSD.org are

origin.patch

