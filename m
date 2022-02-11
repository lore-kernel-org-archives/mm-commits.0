Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F96C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiBKSxb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:53:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiBKSx3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:53:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9C8CED
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C06EBCE2B2C
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFE5C340F0;
        Fri, 11 Feb 2022 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644605603;
        bh=EEDi6QcfI/4Fzo+vkKFQeEjbeJOVejiec7/kpPxsLvc=;
        h=Date:To:From:Subject:From;
        b=BND2JQd3CnntjBuYdQlBAyZz/y+jg690sYTt5gR/VcfDzh3LLu9TvoRDpRvU97g94
         iOC9DlzM4/nmGcwymPovAXujTZz9upzBvFGJS9182WMyI0/6KtILS3/WmdmPoxkpK0
         JzJ8H+rqh3krWxXWZaDfR7gvQVJLJ/qqKwX65K4U=
Date:   Fri, 11 Feb 2022 10:53:22 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch added to -mm tree
Message-Id: <20220211185322.EEFE5C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
has been added to the -mm tree.  Its filename is
     mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch

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
Subject: mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()

userfaultfd calls shmem_mfill_atomic_pte() which does not do any cache
flushing for the target page.  Then the target page will be mapped to the
user space with a different address (user address), which might have an
alias issue with the kernel address used to copy the data from the user
to.  Insert flush_dcache_page() in non-zero-page case.  And replace
clear_highpage() with clear_user_highpage() which already considers the
cache maintenance.

Link: https://lkml.kernel.org/r/20220210123058.79206-6-songmuchun@bytedance.com
Fixes: 8d1039634206 ("userfaultfd: shmem: add shmem_mfill_zeropage_pte for userfaultfd support")
Fixes: 4c27fe4c4c84 ("userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte
+++ a/mm/shmem.c
@@ -2357,8 +2357,10 @@ int shmem_mfill_atomic_pte(struct mm_str
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
+
+			flush_dcache_page(page);
 		} else {		/* ZEROPAGE */
-			clear_highpage(page);
+			clear_user_highpage(page, dst_addr);
 		}
 	} else {
 		page = *pagep;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

