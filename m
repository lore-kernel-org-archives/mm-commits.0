From: akpm@linux-foundation.org
Subject: + mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
 added to -mm tree
Date: Thu, 17 Apr 2014 14:22:44 -0700
Message-ID: <53504624.tsX0lrfF9EC1Ii37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQVWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, duanj.fnst@cn.fujitsu.com

Subject: + mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch added to -mm tree
To: duanj.fnst@cn.fujitsu.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:22:44 -0700


The patch titled
     Subject: mm/mmap.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
has been added to the -mm tree.  Its filename is
     mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: mm/mmap.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fix a coccinelle error regarding usage of IS_ERR and PTR_ERR instead of
PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero
+++ a/mm/mmap.c
@@ -2968,9 +2968,7 @@ int install_special_mapping(struct mm_st
 	struct vm_area_struct *vma = _install_special_mapping(mm,
 			    addr, len, vm_flags, pages);
 
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
-	return 0;
+	return PTR_ERR_OR_ZERO(vma);
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
_

Patches currently in -mm which might be from duanj.fnst@cn.fujitsu.com are

origin.patch
mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
linux-next.patch

