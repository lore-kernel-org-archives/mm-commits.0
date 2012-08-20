From: akpm@linux-foundation.org
Subject: + thp-remove-unnecessary-set_recommended_min_free_kbytes.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:41 -0700
Message-ID: <20120820210842.461C11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64575 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2HTVIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:43 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4073792obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: remove unnecessary set_recommended_min_free_kbytes
has been added to the -mm tree.  Its filename is
     thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
