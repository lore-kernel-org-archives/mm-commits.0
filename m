From: akpm@linux-foundation.org
Subject: + slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch added to -mm tree
Date: Wed, 11 Jan 2012 14:13:38 -0800
Message-ID: <20120111221339.10F7E5C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60460 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab2AKWNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:13:41 -0500
Received: by eekd41 with SMTP id d41so45523eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 14:13:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, penberg@cs.helsinki.fi, rientjes@google.com, rjw@sisk.pl


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

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: slub: document setting min order with debug_guardpage_minorder > 0

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch

