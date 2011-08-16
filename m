From: akpm@linux-foundation.org
Subject: + slub-add-taint-flag-outputting-to-debug-paths.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:04 -0700
Message-ID: <201108161638.p7GGcBuM002997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1HPQiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, penberg@cs.helsinki.fi


The patch titled
     slub: add taint flag outputting to debug paths
has been added to the -mm tree.  Its filename is
     slub-add-taint-flag-outputting-to-debug-paths.patch

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
Subject: slub: add taint flag outputting to debug paths
From: Dave Jones <davej@redhat.com>

When we get corruption reports, it's useful to see if the kernel was
tainted, to rule out problems we can't do anything about.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-add-taint-flag-outputting-to-debug-paths mm/slub.c
--- a/mm/slub.c~slub-add-taint-flag-outputting-to-debug-paths
+++ a/mm/slub.c
@@ -596,7 +596,7 @@ static void slab_bug(struct kmem_cache *
 	va_end(args);
 	printk(KERN_ERR "========================================"
 			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
+	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
 }
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
slab-add-taint-flag-outputting-to-debug-paths.patch
slub-add-taint-flag-outputting-to-debug-paths.patch
mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch

