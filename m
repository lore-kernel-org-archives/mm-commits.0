From: akpm@linux-foundation.org
Subject: [merged] slub-add-taint-flag-outputting-to-debug-paths.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:22:00 -0800
Message-ID: <201111172022.pAHKM0S9005133@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:41741 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1KQUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:22:03 -0500
Received: by mail-bw0-f74.google.com with SMTP id t2so53126bka.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:22:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: add taint flag outputting to debug paths
has been removed from the -mm tree.  Its filename was
     slub-add-taint-flag-outputting-to-debug-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: slub: add taint flag outputting to debug paths

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
@@ -570,7 +570,7 @@ static void slab_bug(struct kmem_cache *
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

