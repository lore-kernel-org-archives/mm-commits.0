From: akpm@linux-foundation.org
Subject: + mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:01 -0700
Message-ID: <201108161638.p7GGc98G002985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab1HPQil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     mm: output a list of loaded modules when we hit bad_page()
has been added to the -mm tree.  Its filename is
     mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: output a list of loaded modules when we hit bad_page()
From: Dave Jones <davej@redhat.com>

When we get a bad_page bug report, it's useful to see what modules the
user had loaded.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-output-a-list-of-loaded-modules-when-we-hit-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-output-a-list-of-loaded-modules-when-we-hit-bad_page
+++ a/mm/page_alloc.c
@@ -318,6 +318,7 @@ static void bad_page(struct page *page)
 		current->comm, page_to_pfn(page));
 	dump_page(page);
 
+	print_modules();
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
slab-add-taint-flag-outputting-to-debug-paths.patch
slub-add-taint-flag-outputting-to-debug-paths.patch
mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch

