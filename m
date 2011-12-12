From: akpm@linux-foundation.org
Subject: + slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch added to -mm tree
Date: Mon, 12 Dec 2011 14:59:23 -0800
Message-ID: <201112122259.pBCMxN3R014555@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:39491 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1LLW73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 17:59:29 -0500
Received: by ggnv2 with SMTP id v2so368705ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 14:59:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     Subject: slub: document setting min order with debug_guardpage_minorder > 0
has been added to the -mm tree.  Its filename is
     slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch

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
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: slub: document setting min order with debug_guardpage_minorder > 0

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-slab |    4 +++-
 Documentation/vm/slub.txt                   |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0 Documentation/ABI/testing/sysfs-kernel-slab
--- a/Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0
+++ a/Documentation/ABI/testing/sysfs-kernel-slab
@@ -345,7 +345,9 @@ Description:
 		allocated.  It is writable and can be changed to increase the
 		number of objects per slab.  If a slab cannot be allocated
 		because of fragmentation, SLUB will retry with the minimum order
-		possible depending on its characteristics.
+		possible depending on its characteristics. 
+		When debug_guardpage_minorder > 0 parameter is specified, the
+		minimum possible order is used and cannot be changed.
 
 What:		/sys/kernel/slab/cache/order_fallback
 Date:		April 2008
diff -puN Documentation/vm/slub.txt~slub-document-setting-min-order-with-debug_guardpage_minorder-0 Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~slub-document-setting-min-order-with-debug_guardpage_minorder-0
+++ a/Documentation/vm/slub.txt
@@ -131,7 +131,9 @@ slub_min_objects.
 slub_max_order specified the order at which slub_min_objects should no
 longer be checked. This is useful to avoid SLUB trying to generate
 super large order pages to fit slub_min_objects of a slab cache with
-large object sizes into one high order page.
+large object sizes into one high order page. Setting parameter
+debug_guardpage_minorder > 0 forces setting slub_max_order to 0, what
+cause minimum possible order of slabs allocation.
 
 SLUB Debug output
 -----------------
_
Subject: Subject: slub: document setting min order with debug_guardpage_minorder > 0

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch

