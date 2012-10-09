From: akpm@linux-foundation.org
Subject: [merged] thp-remove-unnecessary-set_recommended_min_free_kbytes.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:10 -0700
Message-ID: <20121009180811.1E8075C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57539 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:13 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362219bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unnecessary set_recommended_min_free_kbytes
has been removed from the -mm tree.  Its filename was
     thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: remove unnecessary set_recommended_min_free_kbytes

Since it is called in start_khugepaged

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-unnecessary-set_recommended_min_free_kbytes mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unnecessary-set_recommended_min_free_kbytes
+++ a/mm/huge_memory.c
@@ -225,9 +225,6 @@ static ssize_t enabled_store(struct kobj
 			ret = err;
 	}
 
-	if (ret > 0 && khugepaged_enabled())
-		set_recommended_min_free_kbytes();
-
 	return ret;
 }
 static struct kobj_attribute enabled_attr =
@@ -562,8 +559,6 @@ static int __init hugepage_init(void)
 
 	start_khugepaged();
 
-	set_recommended_min_free_kbytes();
