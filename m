From: akpm@linux-foundation.org
Subject: + mm-dmapool-fixed-a-brace-coding-style-issue.patch added to -mm
 tree
Date: Wed, 01 Oct 2014 13:55:58 -0700
Message-ID: <542c6a5e.dpPQjt6p1ZjqgaN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaJAUz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: fixed a brace coding style issue
has been added to the -mm tree.  Its filename is
     mm-dmapool-fixed-a-brace-coding-style-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapool-fixed-a-brace-coding-style-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapool-fixed-a-brace-coding-style-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: mm/dmapool.c: fixed a brace coding style issue

Remove 3 brace coding style for any arm of this statement

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/dmapool.c~mm-dmapool-fixed-a-brace-coding-style-issue mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapool-fixed-a-brace-coding-style-issue
+++ a/mm/dmapool.c
@@ -135,28 +135,25 @@ struct dma_pool *dma_pool_create(const c
 	size_t allocation;
 	bool empty = false;
 
-	if (align == 0) {
+	if (align == 0)
 		align = 1;
-	} else if (align & (align - 1)) {
+	else if (align & (align - 1))
 		return NULL;
-	}
 
-	if (size == 0) {
+	if (size == 0)
 		return NULL;
-	} else if (size < 4) {
+	else if (size < 4)
 		size = 4;
-	}
 
 	if ((size % align) != 0)
 		size = ALIGN(size, align);
 
 	allocation = max_t(size_t, size, PAGE_SIZE);
 
-	if (!boundary) {
+	if (!boundary)
 		boundary = allocation;
-	} else if ((boundary < size) || (boundary & (boundary - 1))) {
+	else if ((boundary < size) || (boundary & (boundary - 1)))
 		return NULL;
-	}
 
 	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
 	if (!retval)
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

mm-mremap-use-linux-headers.patch
mm-filemap-remove-trailing-whitespace.patch
mm-bootmem-added-headers.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-dmapool-fixed-a-brace-coding-style-issue.patch

