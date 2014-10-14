From: akpm@linux-foundation.org
Subject: + vmalloc-replace-printk-with-pr_warn.patch added to -mm tree
Date: Tue, 14 Oct 2014 14:17:36 -0700
Message-ID: <543d92f0.UK63fc2cWKNcs1HM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaJNVRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: replace printk with pr_warn
has been added to the -mm tree.  Its filename is
     vmalloc-replace-printk-with-pr_warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-replace-printk-with-pr_warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-replace-printk-with-pr_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm/vmalloc.c: replace printk with pr_warn

This patch replaces printk(KERN_WARNING..) with pr_warn.
Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-replace-printk-with-pr_warn mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-replace-printk-with-pr_warn
+++ a/mm/vmalloc.c
@@ -463,8 +463,7 @@ overflow:
 		goto retry;
 	}
 	if (printk_ratelimit())
-		printk(KERN_WARNING
-			"vmap allocation for size %lu failed: "
+		pr_warn("vmap allocation for size %lu failed: "
 			"use vmalloc=<size> to increase size.\n", size);
 	kfree(va);
 	return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from pintu.k@samsung.com are

vmalloc-replace-printk-with-pr_warn.patch

