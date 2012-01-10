From: akpm@linux-foundation.org
Subject: - slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:44:15 -0800
Message-ID: <20120110234416.28D1510017A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53815 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2AJXoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:44:17 -0500
Received: by ghrr15 with SMTP id r15so18506ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:44:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: document setting min order with debug_guardpage_minorder > 0
has been removed from the -mm tree.  Its filename was
     slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch

This patch was dropped because Rafael wanted changes and I never received them

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: slub: document setting min order with debug_guardpage_minorder > 0

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-slab |    2 ++
 Documentation/vm/slub.txt                   |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0 Documentation/ABI/testing/sysfs-kernel-slab
--- a/Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0
+++ a/Documentation/ABI/testing/sysfs-kernel-slab
@@ -346,6 +346,8 @@ Description:
 		number of objects per slab.  If a slab cannot be allocated
 		because of fragmentation, SLUB will retry with the minimum order
 		possible depending on its characteristics.
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

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
mm-more-intensive-memory-corruption-debug.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
linux-next.patch

