From: akpm@linux-foundation.org
Subject: - likely_prof-changed-to-use-proc_create.patch removed from -mm tree
Date: Mon, 27 Oct 2008 21:34:42 -0700
Message-ID: <200810280434.m9S4YgvV018441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYJ1EfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 00:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     likely_prof changed to use proc_create
has been removed from the -mm tree.  Its filename was
     likely_prof-changed-to-use-proc_create.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: likely_prof changed to use proc_create
From: Daniel Walker <dwalker@mvista.com>

Convert likely profiling to use proc_create instead of create_proc_entry.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/likely_prof.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/likely_prof.c~likely_prof-changed-to-use-proc_create lib/likely_prof.c
--- a/lib/likely_prof.c~likely_prof-changed-to-use-proc_create
+++ a/lib/likely_prof.c
@@ -136,10 +136,11 @@ static struct file_operations proc_likel
 
 static int __init init_likely(void)
 {
-	struct proc_dir_entry *entry;
-	entry = create_proc_entry("likely_prof", 0, &proc_root);
-	if (entry)
-		entry->proc_fops = &proc_likely_operations;
+	struct proc_dir_entry *entry =
+		proc_create("likely_prof", 0, &proc_root,
+				&proc_likely_operations);
+	if (!entry)
+		return 1;
 
 	return 0;
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

linux-next.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch
likely-profiling-disable-ftrace.patch

