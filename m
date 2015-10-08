From: akpm@linux-foundation.org
Subject: + mm-change-highmem_zone-macro-definition.patch added to -mm tree
Date: Thu, 08 Oct 2015 15:11:15 -0700
Message-ID: <5616ea03.leufSYs6XcpnFzXP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934601AbbJHWLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change HIGHMEM_ZONE macro definition
has been added to the -mm tree.  Its filename is
     mm-change-highmem_zone-macro-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-highmem_zone-macro-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-highmem_zone-macro-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: mm: change HIGHMEM_ZONE macro definition

Change HIGHMEM_ZONE to be the same as the DMA_ZONE macro.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-change-highmem_zone-macro-definition include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-change-highmem_zone-macro-definition
+++ a/include/linux/vm_event_item.h
@@ -14,12 +14,12 @@
 #endif
 
 #ifdef CONFIG_HIGHMEM
-#define HIGHMEM_ZONE(xx) , xx##_HIGH
+#define HIGHMEM_ZONE(xx) xx##_HIGH,
 #else
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL, HIGHMEM_ZONE(xx) xx##_MOVABLE
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

mm-change-highmem_zone-macro-definition.patch

