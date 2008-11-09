From: akpm@linux-foundation.org
Subject: + fix-__pfn_to_pagepfn-for-config_discontigmem=y.patch added to -mm tree
Date: Sat, 08 Nov 2008 21:55:03 -0800
Message-ID: <200811090555.mA95t3c7016783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbYKIFze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 9 Nov 2008 00:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@suse.cz, stable@kernel.org


The patch titled
     Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
has been added to the -mm tree.  Its filename is
     fix-__pfn_to_pagepfn-for-config_discontigmem=y.patch

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
Subject: Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix macro __pfn_to_page(pfn) so that it doesn't evaluate its argument
twice in the CONFIG_DISCONTIGMEM=y case, because 'pfn' may be a result of
a funtion call having side effects.

For example, the hibernation code applies pfn_to_page(pfn) to the result
of a function returning the pfn corresponding to the next set bit in a
bitmap and the current bit position is modified on each call.  This leads
to "interesting" failures for CONFIG_DISCONTIGMEM=y due to the current
behavior of __pfn_to_page(pfn).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/memory_model.h~fix-__pfn_to_pagepfn-for-config_discontigmem=y include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~fix-__pfn_to_pagepfn-for-config_discontigmem=y
+++ a/include/asm-generic/memory_model.h
@@ -34,7 +34,7 @@
 
 #define __pfn_to_page(pfn)			\
 ({	unsigned long __pfn = (pfn);		\
-	unsigned long __nid = arch_pfn_to_nid(pfn);  \
+	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
 	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
 })
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-__pfn_to_pagepfn-for-config_discontigmem=y.patch
linux-next.patch
e1000e-use-device_set_wakeup_enable.patch
e1000-use-device_set_wakeup_enable.patch
igb-use-device_set_wakeup_enable.patch
shrink_slab-handle-bad-shrinkers.patch

