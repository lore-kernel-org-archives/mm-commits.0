From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:35 -0700
Message-ID: <53e3dc0f.bjG1uMrue/NSfTHW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:38566 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaHGUFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:36 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so611235qgd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: don't forget to set softdirty on file mapped fault
has been removed from the -mm tree.  Its filename was
     mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm/memory.c: don't forget to set softdirty on file mapped fault

Otherwise we may not notice that pte was softdirty because
pte_mksoft_dirty helper _returns_ new pte but doesn't modify the argument.

In case if page fault happend on dirty filemapping the newly created pte
may loose softdirty bit thus if a userspace program is tracking memory
changes with help of a memory tracker (CONFIG_MEM_SOFT_DIRTY) it might
miss modification of a memory page (which in worts case may lead to
data inconsistency).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-dont-forget-to-set-softdirty-on-file-mapped-fault mm/memory.c
--- a/mm/memory.c~mm-dont-forget-to-set-softdirty-on-file-mapped-fault
+++ a/mm/memory.c
@@ -2744,7 +2744,7 @@ void do_set_pte(struct vm_area_struct *v
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
-		pte_mksoft_dirty(entry);
+		entry = pte_mksoft_dirty(entry);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch

