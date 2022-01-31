Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907C2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiAaTvE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377447AbiAaTvB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:51:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A4CC06173B
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3111B82C34
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E04C340E8;
        Mon, 31 Jan 2022 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658658;
        bh=IkaU55Kirs6l/b9HiySt1xagM0EZD3Lg0PkYVokoYYA=;
        h=Date:From:To:Subject:From;
        b=mYMiB95ITESMuk8sov2IZ9SM8AIwOfbDCIiBEwEm++SQ3DyFdme4UN+MBUMC0EURq
         mabAqPPZ8UlWDQrufYeCyY3YemY7fln42bJU2mymiNX9HkUIdFB1GfWT2pY/BhrleM
         F3bB/vNFC/T93KfkTqzBb2yubsEiIotOmRl56jBU=
Date:   Mon, 31 Jan 2022 11:50:57 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, duanxiongchun@bytedance.com,
        kirill.shutemov@linux.intel.com, lars.persson@axis.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  +
 mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch added
 to -mm tree
Message-ID: <20220131195057.a-f78vn0T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch

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
Subject: mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

The userfaultfd calls copy_huge_page_from_user() which does not do any
cache flushing for the target page.  Then the target page will be mapped
to the user space with a different address (user address), which might
have an alias issue with the kernel address used to copy the data from the
user to.  Fix this issue by flushing dcache in copy_huge_page_from_user().

Link: https://lkml.kernel.org/r/20220131160254.43211-4-songmuchun@bytedance.com
Fixes: fa4d75c1de13 ("userfaultfd: hugetlbfs: add copy_huge_page_from_user for hugetlb userfaultfd support")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user
+++ a/mm/memory.c
@@ -5499,6 +5499,8 @@ long copy_huge_page_from_user(struct pag
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

