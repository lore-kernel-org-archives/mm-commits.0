From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-remove-unused-code-from-do_wp_page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:22 -0800
Message-ID: <20121214233023.1C1A5200063@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48130 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945936Ab2LNXaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:25 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so208489fae.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: remove unused code from do_wp_page()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-remove-unused-code-from-do_wp_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: mm/memory.c: remove unused code from do_wp_page()

page_mkwrite is initalized with zero and only set once, from that point
exists no way to get to the oom or oom_free_new labels.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page mm/memory.c
--- a/mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page
+++ a/mm/memory.c
@@ -2780,13 +2780,8 @@ unlock:
 oom_free_new:
 	page_cache_release(new_page);
 oom:
-	if (old_page) {
-		if (page_mkwrite) {
-			unlock_page(old_page);
-			page_cache_release(old_page);
-		}
+	if (old_page)
 		page_cache_release(old_page);
-	}
 	return VM_FAULT_OOM;
 
 unwritable_page:
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

origin.patch

