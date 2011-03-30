From: akpm@linux-foundation.org
Subject: + mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch added to -mm tree
Date: Wed, 30 Mar 2011 12:53:17 -0700
Message-ID: <201103301953.p2UJrHnS004168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680Ab1C3UCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 16:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm/page_alloc.c: silence build_all_zonelists() section mismatch
has been added to the -mm tree.  Its filename is
     mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch

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
Subject: mm/page_alloc.c: silence build_all_zonelists() section mismatch
From: Paul Mundt <lethal@linux-sh.org>

The memory hotplug case involves calling to build_all_zonelists() which in
turns calls in to setup_zone_pageset().  The latter is marked __meminit
while build_all_zonelists() itself has no particular annotation. 
build_all_zonelists() is only handed a non-NULL pointer in the case of
memory hotplug through an existing __meminit path, so the
setup_zone_pageset() reference is always safe.

The options as such are either to flag build_all_zonelists() as __ref (as
per __build_all_zonelists()), or to simply discard the __meminit
annotation from setup_zone_pageset().

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-silence-build_all_zonelists-section-mismatch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-silence-build_all_zonelists-section-mismatch
+++ a/mm/page_alloc.c
@@ -3170,7 +3170,7 @@ static __init_refok int __build_all_zone
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  */
-void build_all_zonelists(void *data)
+void __ref build_all_zonelists(void *data)
 {
 	set_zonelist_order();
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch

