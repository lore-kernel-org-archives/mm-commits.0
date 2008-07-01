From: akpm@linux-foundation.org
Subject: + bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch added to -mm tree
Date: Mon, 30 Jun 2008 23:52:08 -0700
Message-ID: <200807010652.m616q8KB013566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbYGAGwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 02:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, hannes@saeurebad.de


The patch titled
     bootmem-clean-up-alloc_bootmem_core: Fix new alloc_bootmem_core
has been added to the -mm tree.  Its filename is
     bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem-clean-up-alloc_bootmem_core: Fix new alloc_bootmem_core
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Fix new alloc_bootmem_core() of bootmem-clean-up-alloc_bootmem_core.patch
in 2.6.26-rc5-mm3.

(min < goal) should be checked too.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core
+++ a/mm/bootmem.c
@@ -462,7 +462,7 @@ static void * __init alloc_bootmem_core(
 
 	step = max(align >> PAGE_SHIFT, 1UL);
 
-	if (goal && goal < max)
+	if (goal && min < goal && goal < max)
 		start = ALIGN(goal, step);
 	else
 		start = ALIGN(min, step);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-respect-goal-more-likely.patch
bootmem-revisit-alloc_bootmem_section.patch
mm-make-register_page_bootmem_info_section-static.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch

