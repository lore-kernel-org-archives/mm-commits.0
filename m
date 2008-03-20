From: akpm@linux-foundation.org
Subject: + likely_prof-changed-to-use-proc_create.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:59:49 -0700
Message-ID: <200803202159.m2KLxnKU026150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219AbYCTWAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 18:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, adobriyan@gmail.com


The patch titled
     likely_prof changed to use proc_create
has been added to the -mm tree.  Its filename is
     likely_prof-changed-to-use-proc_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

net-ehea-semaphore-to-mutex.patch
net-ehea-ehea_fw_handles-semaphore-to-mutex.patch
net-ehea-locking-order-correction.patch
net-ehea-bcmc_regs-semaphore-to-mutex.patch
net-ehea-port_lock-semaphore-to-mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
likely_prof-changed-to-use-proc_create.patch

