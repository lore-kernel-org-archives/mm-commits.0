From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-drop-dead-code.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:09:37 -0700
Message-ID: <20170707190937.h0TmqEYHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdGGTJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com


The patch titled
     Subject: fs/userfaultfd.c: drop dead code
has been removed from the -mm tree.  Its filename was
     userfaultfd-drop-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Mike Rapoport" <rppt@linux.vnet.ibm.com>
Subject: fs/userfaultfd.c: drop dead code

Calculation of start end end in __wake_userfault function are not used and
can be removed.

Link: http://lkml.kernel.org/r/1494930917-3134-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-drop-dead-code fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-drop-dead-code
+++ a/fs/userfaultfd.c
@@ -1114,11 +1114,6 @@ static ssize_t userfaultfd_read(struct f
 static void __wake_userfault(struct userfaultfd_ctx *ctx,
 			     struct userfaultfd_wake_range *range)
 {
-	unsigned long start, end;
-
-	start = range->start;
-	end = range->start + range->len;
