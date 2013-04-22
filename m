From: akpm@linux-foundation.org
Subject: [merged] fix-hugetlb-memory-check-in-vma_dump_size.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:46 -0700
Message-ID: <20130422200646.8AB525A4285@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39208 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab3DVUGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:47 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so624414ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, d.hatayama@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()
has been removed from the -mm tree.  Its filename was
     fix-hugetlb-memory-check-in-vma_dump_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()

Documentation/filesystems/proc.txt says about coredump_filter bitmask,

  Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
  effected by bit 5-6.

However current code can go into the subsequent flag checks of bit 0-4
for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
as written in the document.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/binfmt_elf.c~fix-hugetlb-memory-check-in-vma_dump_size fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-hugetlb-memory-check-in-vma_dump_size
+++ a/fs/binfmt_elf.c
@@ -1137,6 +1137,7 @@ static unsigned long vma_dump_size(struc
 			goto whole;
 		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
 			goto whole;
+		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-check-dirty-flag-to-match-against-clean-page.patch

