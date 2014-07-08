From: akpm@linux-foundation.org
Subject: + mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch
 added to -mm tree
Date: Tue, 08 Jul 2014 13:20:50 -0700
Message-ID: <53bc52a2.v14uOxtEoA/d5eEj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:45275 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaGHUUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 16:20:51 -0400
Received: by mail-ie0-f201.google.com with SMTP id rl12so964255iec.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 13:20:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: don't forget to set softdirty on file mapped fault
has been added to the -mm tree.  Its filename is
     mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm/memory.c: don't forget to set softdirty on file mapped fault

Otherwise we may not notice that pte was softdirty because
pte_mksoft_dirty helper _returns_ new pte but not modifies argument.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-dont-forget-to-set-softdirty-on-file-mapped-fault mm/memory.c
--- a/mm/memory.c~mm-dont-forget-to-set-softdirty-on-file-mapped-fault
+++ a/mm/memory.c
@@ -2746,7 +2746,7 @@ void do_set_pte(struct vm_area_struct *v
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

mm-dont-forget-to-set-softdirty-on-file-mapped-fault.patch

