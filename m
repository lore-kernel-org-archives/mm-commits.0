From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch added
 to -mm tree
Date: Thu, 23 Apr 2020 18:20:38 -0700
Message-ID: <20200424012038.5UKwgNu56%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbgDXBUk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 21:20:40 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haren@linux.ibm.com, hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc/vas: fix up for {un}use_mm() rename
has been added to the -mm tree.  Its filename is
     kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc/vas: fix up for {un}use_mm() rename

Link: http://lkml.kernel.org/r/20200422163935.5aa93ba5@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Haren Myneni <haren@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/vas-fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powernv/vas-fault.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix
+++ a/arch/powerpc/platforms/powernv/vas-fault.c
@@ -127,7 +127,7 @@ static void update_csb(struct vas_window
 		return;
 	}
 
-	use_mm(window->mm);
+	kthread_use_mm(window->mm);
 	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
 	/*
 	 * User space polls on csb.flags (first byte). So add barrier
@@ -139,7 +139,7 @@ static void update_csb(struct vas_window
 		smp_mb();
 		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
 	}
-	unuse_mm(window->mm);
+	kthread_unuse_mm(window->mm);
 	put_task_struct(tsk);
 
 	/* Success */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
