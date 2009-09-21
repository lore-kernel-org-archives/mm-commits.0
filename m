From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-pt1-pt1c-needs-vmalloch.patch added to -mm tree
Date: Mon, 21 Sep 2009 16:09:30 -0700
Message-ID: <200909212331.n8LNVr5b001343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbZIUXcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 19:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     drivers/media/dvb/pt1/pt1.c needs vmalloc.h
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-pt1-pt1c-needs-vmalloch.patch

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
Subject: drivers/media/dvb/pt1/pt1.c needs vmalloc.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/media/dvb/pt1/pt1.c: In function 'pt1_cleanup_tables':
drivers/media/dvb/pt1/pt1.c:422: error: implicit declaration of function 'vfree'
drivers/media/dvb/pt1/pt1.c: In function 'pt1_init_tables':
drivers/media/dvb/pt1/pt1.c:431: error: implicit declaration of function 'vmalloc'
drivers/media/dvb/pt1/pt1.c:431: warning: assignment makes pointer from integer without a cast

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/pt1/pt1.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/dvb/pt1/pt1.c~drivers-media-dvb-pt1-pt1c-needs-vmalloch drivers/media/dvb/pt1/pt1.c
--- a/drivers/media/dvb/pt1/pt1.c~drivers-media-dvb-pt1-pt1c-needs-vmalloch
+++ a/drivers/media/dvb/pt1/pt1.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
mm-make-swap-token-dummies-static-inlines.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
alpha-convert-to-use-arch_gettimeoffset.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
drivers-media-dvb-pt1-pt1c-needs-vmalloch.patch

