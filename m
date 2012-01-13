From: akpm@linux-foundation.org
Subject: [merged] slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:11 -0800
Message-ID: <20120113203211.A4BC010004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51298 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2AMUcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:12 -0500
Received: by ghrr18 with SMTP id r18so207082ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, penberg@cs.helsinki.fi, rientjes@google.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: document setting min order with debug_guardpage_minorder > 0
has been removed from the -mm tree.  Its filename was
     slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: slub: document setting min order with debug_guardpage_minorder > 0

Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-slab |    4 ++++
 Documentation/vm/slub.txt                   |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0 Documentation/ABI/testing/sysfs-kernel-slab
--- a/Documentation/ABI/testing/sysfs-kernel-slab~slub-document-setting-min-order-with-debug_guardpage_minorder-0
+++ a/Documentation/ABI/testing/sysfs-kernel-slab
@@ -346,6 +346,10 @@ Description:
 		number of objects per slab.  If a slab cannot be allocated
 		because of fragmentation, SLUB will retry with the minimum order
 		possible depending on its characteristics.
+		When debug_guardpage_minorder=N (N > 0) parameter is specified
+		(see Documentation/kernel-parameters.txt), the minimum possible
+		order is used and this sysfs entry can not be used to change
+		the order at run time.
 
 What:		/sys/kernel/slab/cache/order_fallback
 Date:		April 2008
diff -puN Documentation/vm/slub.txt~slub-document-setting-min-order-with-debug_guardpage_minorder-0 Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~slub-document-setting-min-order-with-debug_guardpage_minorder-0
+++ a/Documentation/vm/slub.txt
@@ -131,7 +131,10 @@ slub_min_objects.
 slub_max_order specified the order at which slub_min_objects should no
 longer be checked. This is useful to avoid SLUB trying to generate
 super large order pages to fit slub_min_objects of a slab cache with
-large object sizes into one high order page.
+large object sizes into one high order page. Setting command line
+parameter debug_guardpage_minorder=N (N > 0), forces setting
+slub_max_order to 0, what cause minimum possible order of slabs
+allocation.
 
 SLUB Debug output
 -----------------
_

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch

