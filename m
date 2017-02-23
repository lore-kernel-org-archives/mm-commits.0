From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-convert-bug-to-warn_on_once.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:13:19 -0800
Message-ID: <58af506f.JRMyz3h4cLqF1nsk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdBWVV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: convert BUG() to WARN_ON_ONCE()
has been removed from the -mm tree.  Its filename was
     userfaultfd-convert-bug-to-warn_on_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: convert BUG() to WARN_ON_ONCE()

Avoid BUG_ON()s and only WARN instead. This is just a cleanup, it
can't make any runtime difference. This BUG_ON has never triggered and
cannot trigger.

Link: http://lkml.kernel.org/r/20161216144821.5183-4-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-convert-bug-to-warn_on_once fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-convert-bug-to-warn_on_once
+++ a/fs/userfaultfd.c
@@ -574,7 +574,8 @@ static unsigned int userfaultfd_poll(str
 			ret = POLLIN;
 		return ret;
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
+		return POLLERR;
 	}
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

