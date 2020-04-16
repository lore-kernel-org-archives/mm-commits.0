From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-?=
 =?US-ASCII?Q?enabled-v4-fix.patch?= added to -mm tree
Date: Wed, 15 Apr 2020 19:58:52 -0700
Message-ID: <20200416025852.iDX-Zkfwj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389318AbgDPC6y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 22:58:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, duanxiongchun@bytedance.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, ktkhai@virtuozzo.com, Markus.Elfring@web.de, mm-commits@vger.kernel.org, songmuchun@bytedance.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix
has been added to the -mm tree.  Its filename is
     mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix

add the conventional brakes, replace /** with /*

Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix
+++ a/mm/ksm.c
@@ -2112,15 +2112,16 @@ static void cmp_and_merge_page(struct pa
 
 		down_read(&mm->mmap_sem);
 		vma = find_mergeable_vma(mm, rmap_item->address);
-		if (vma)
+		if (vma) {
 			err = try_to_merge_one_page(vma, page,
 					ZERO_PAGE(rmap_item->address));
-		else
-			/**
+		} else {
+			/*
 			 * If the vma is out of date, we do not need to
 			 * continue.
 			 */
 			err = 0;
+		}
 		up_read(&mm->mmap_sem);
 		/*
 		 * In case of failure, the page was not really empty, so we
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
