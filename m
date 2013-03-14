From: akpm@linux-foundation.org
Subject: + mmap-find_vma-remove-the-warn_on_oncemm-check.patch added to -mm tree
Date: Thu, 14 Mar 2013 16:31:59 -0700
Message-ID: <20130314233159.6AAD05A4158@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35493 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3CNXcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 19:32:01 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so109023vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 16:31:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check
has been added to the -mm tree.  Its filename is
     mmap-find_vma-remove-the-warn_on_oncemm-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check

Remove the WARN_ON_ONCE(!mm) check as the comment suggested.  Kernel code
calls find_vma only when it is absolutely sure that the mm_struct arg to
it is non-NULL.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mmap.c~mmap-find_vma-remove-the-warn_on_oncemm-check mm/mmap.c
--- a/mm/mmap.c~mmap-find_vma-remove-the-warn_on_oncemm-check
+++ a/mm/mmap.c
@@ -1933,9 +1933,6 @@ struct vm_area_struct *find_vma(struct m
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
-		return NULL;
