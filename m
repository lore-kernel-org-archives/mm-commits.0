From: akpm@linux-foundation.org
Subject: +
 mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 19:58:49 -0700
Message-ID: <20200416025849.NFTGgkq1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPC6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 22:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, duanxiongchun@bytedance.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, ktkhai@virtuozzo.com, Markus.Elfring@web.de, mm-commits@vger.kernel.org, songmuchun@bytedance.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4
has been added to the -mm tree.  Its filename is
     mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4

if the vma is out of date, just exit

Link: http://lkml.kernel.org/r/20200416025034.29780-1-songmuchun@bytedance.com
Fixes: e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Xiongchun Duan <duanxiongchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4
+++ a/mm/ksm.c
@@ -2116,7 +2116,11 @@ static void cmp_and_merge_page(struct pa
 			err = try_to_merge_one_page(vma, page,
 					ZERO_PAGE(rmap_item->address));
 		else
-			err = -EFAULT;
+			/**
+			 * If the vma is out of date, we do not need to
+			 * continue.
+			 */
+			err = 0;
 		up_read(&mm->mmap_sem);
 		/*
 		 * In case of failure, the page was not really empty, so we
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4.patch
