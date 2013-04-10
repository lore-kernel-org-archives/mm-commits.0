From: akpm@linux-foundation.org
Subject: + fix-hugetlb-memory-check-in-vma_dump_size.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:55:40 -0700
Message-ID: <20130410215540.EE06231C107__13969.5605882027$1365630946$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:58859 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab3DJVzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:55:42 -0400
Received: by mail-oa0-f74.google.com with SMTP id k14so231958oag.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:55:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, d.hatayama@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()
has been added to the -mm tree.  Its filename is
     fix-hugetlb-memory-check-in-vma_dump_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: <stable@vger.kernel.org>	[2.6.34+]
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

hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch
fix-hugetlb-memory-check-in-vma_dump_size.patch
hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch

