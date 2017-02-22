From: akpm@linux-foundation.org
Subject: [patch 048/142] userfaultfd: correct comment about
 UFFD_FEATURE_PAGEFAULT_FLAG_WP
Date: Wed, 22 Feb 2017 15:42:09 -0800
Message-ID: <58ae21d1.SJE1pbfST/YYUM5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934566AbdBVXmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: correct comment about UFFD_FEATURE_PAGEFAULT_FLAG_WP

Minor comment correction.

Link: http://lkml.kernel.org/r/20161216144821.5183-3-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp
+++ a/fs/userfaultfd.c
@@ -169,7 +169,7 @@ static inline struct uffd_msg userfault_
 	msg.arg.pagefault.address = address;
 	if (flags & FAULT_FLAG_WRITE)
 		/*
-		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WRITE was set in the
+		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WP was set in the
 		 * uffdio_api.features and UFFD_PAGEFAULT_FLAG_WRITE
 		 * was not set in a UFFD_EVENT_PAGEFAULT, it means it
 		 * was a read fault, otherwise if set it means it's
_
