From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:31 -0700
Message-ID: <5390c9cb.hKG+UagLOjBhBDkG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaFETtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, duanj.fnst@cn.fujitsu.com

Subject: [merged] mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch removed from -mm tree
To: duanj.fnst@cn.fujitsu.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:31 -0700


The patch titled
     Subject: mm/mmap.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
has been removed from the -mm tree.  Its filename was
     mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2965,9 +2965,7 @@ int install_special_mapping(struct mm_st
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
linux-next.patch

