From: akpm@linux-foundation.org
Subject: + mm-make-vb_alloc-more-foolproof.patch added to -mm tree
Date: Tue, 05 Jun 2012 15:56:20 -0700
Message-ID: <20120605225621.3F84DA00E2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34429 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2FEW4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 18:56:23 -0400
Received: by lbbgp10 with SMTP id gp10so369663lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 15:56:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     Subject: mm: make vb_alloc() more foolproof
has been added to the -mm tree.  Its filename is
     mm-make-vb_alloc-more-foolproof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: make vb_alloc() more foolproof

If someone calls vb_alloc() (or vm_map_ram() for that matter) to allocate
0 bytes (0 pages), get_order() returns BITS_PER_LONG - PAGE_CACHE_SHIFT
and interesting stuff happens.  So make debugging such problems easier and
warn about 0-size allocation.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/vmalloc.c~mm-make-vb_alloc-more-foolproof mm/vmalloc.c
--- a/mm/vmalloc.c~mm-make-vb_alloc-more-foolproof
+++ a/mm/vmalloc.c
@@ -904,6 +904,15 @@ static void *vb_alloc(unsigned long size
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
+	if (size == 0) {
+		/*
+		 * Allocating 0 bytes isn't what caller wants since
+		 * get_order(0) returns funny result. Just warn and terminate
+		 * early.
+		 */
+		WARN_ON(1);
+		return NULL;
+	}
 	order = get_order(size);
 
 again:
_
Subject: Subject: mm: make vb_alloc() more foolproof

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
mm-make-vb_alloc-more-foolproof.patch
mm-make-vb_alloc-more-foolproof-fix.patch

