From: akpm@linux-foundation.org
Subject: [merged] mmap-find_vma-remove-the-warn_on_oncemm-check.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:46 -0700
Message-ID: <20130430184746.7A8A25A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64202 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Srr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:47 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so84906vbf.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, k80ck80c@gmail.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check
has been removed from the -mm tree.  Its filename was
     mmap-find_vma-remove-the-warn_on_oncemm-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check

Remove the WARN_ON_ONCE(!mm) check as the comment suggested.  Kernel code
calls find_vma only when it is absolutely sure that the mm_struct arg to
it is non-NULL.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: k80c <k80ck80c@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mmap.c~mmap-find_vma-remove-the-warn_on_oncemm-check mm/mmap.c
--- a/mm/mmap.c~mmap-find_vma-remove-the-warn_on_oncemm-check
+++ a/mm/mmap.c
@@ -1935,9 +1935,6 @@ struct vm_area_struct *find_vma(struct m
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
-		return NULL;
