From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-?=
 =?US-ASCII?Q?enabled-v4-fix.patch?= removed from -mm tree
Date: Mon, 20 Apr 2020 18:08:44 -0700
Message-ID: <20200421010844.0W35tGi0O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgDUBIr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, duanxiongchun@bytedance.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, ktkhai@virtuozzo.com, Markus.Elfring@web.de, mm-commits@vger.kernel.org, songmuchun@bytedance.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch

This patch was dropped because it was folded into mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch

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

mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
