From: akpm@linux-foundation.org
Subject: - proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:39:44 -0700
Message-ID: <200810241939.m9OJdidZ000752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbYJXTjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     proc: use non-racy method for /proc/page_owner creation
has been removed from the -mm tree.  Its filename was
     proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

This patch was dropped because procfs changes broke it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: use non-racy method for /proc/page_owner creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_misc.c~proc-use-non-racy-method-for-proc-page_owner-creation-page_owner fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-use-non-racy-method-for-proc-page_owner-creation-page_owner
+++ a/fs/proc/proc_misc.c
@@ -1099,12 +1099,10 @@ void __init proc_misc_init(void)
 #ifdef CONFIG_PAGE_OWNER
 	{
 		struct proc_dir_entry *entry;
-		entry = create_proc_entry("page_owner",
-			S_IWUSR | S_IRUGO, NULL);
-		if (entry) {
-			entry->proc_fops = &proc_page_owner_operations;
+		entry = proc_create("page_owner",
+			S_IWUSR | S_IRUGO, NULL, &proc_page_owner_operations);
+		if (entry)
 			entry->size = 1024;
-		}
 	}
 #endif
 }
_

Patches currently in -mm which might be from den@openvz.org are

proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

