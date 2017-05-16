From: akpm@linux-foundation.org
Subject: + userfaultfd-drop-dead-code.patch added to -mm tree
Date: Tue, 16 May 2017 12:55:12 -0700
Message-ID: <591b5920.mYLfdsIFNTQgkFuZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdEPTzN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 15:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/userfaultfd.c: drop dead code
has been added to the -mm tree.  Its filename is
     userfaultfd-drop-dead-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-drop-dead-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-drop-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1101,11 +1101,6 @@ static ssize_t userfaultfd_read(struct f
 static void __wake_userfault(struct userfaultfd_ctx *ctx,
 			     struct userfaultfd_wake_range *range)
 {
-	unsigned long start, end;
-
-	start = range->start;
-	end = range->start + range->len;
