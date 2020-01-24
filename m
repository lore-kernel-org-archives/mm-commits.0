From: akpm@linux-foundation.org
Subject: +
 mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch added to -mm
 tree
Date: Thu, 23 Jan 2020 19:11:56 -0800
Message-ID: <20200124031156.JnlWjp46K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbgAXDL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 22:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, cai@lca.pw, dan.j.williams@intel.com, david@redhat.com, k-hagio@ab.jp.nec.com, kernelfans@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de


The patch titled
     Subject: mm/sparse.c: reset section's mem_map when fully deactivated
has been added to the -mm tree.  Its filename is
     mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: mm/sparse.c: reset section's mem_map when fully deactivated

After commit ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug"),
when a mem section is fully deactivated, section_mem_map still records the
section's start pfn, which is not used any more and will be reassigned
during re-addition.

In analogy with alloc/free pattern, it is better to clear all fields of
section_mem_map.

Beside this, it breaks the user space tool "makedumpfile" [1], which makes
assumption that a hot-removed section has mem_map as NULL, instead of
checking directly against SECTION_MARKED_PRESENT bit.  (makedumpfile will
be better to change the assumption, and need a patch)

The bug can be reproduced on IBM POWERVM by "drmgr -c mem -r -q 5" ,
trigger a crash, and save vmcore by makedumpfile

[1]: makedumpfile, commit e73016540293 ("[v1.6.7] Update version")

Link: http://lkml.kernel.org/r/1579487594-28889-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Kazuhito Hagio <k-hagio@ab.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-reset-sections-mem_map-when-fully-deactivated
+++ a/mm/sparse.c
@@ -789,7 +789,7 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = sparse_encode_mem_map(NULL, section_nr);
+		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)
_

Patches currently in -mm which might be from kernelfans@gmail.com are

mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch
