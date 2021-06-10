Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23708C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0960A613E7
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFJW1I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhFJW1H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB79613F1;
        Thu, 10 Jun 2021 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363898;
        bh=gmDj4XZXANSJKkBHr1+t/7FUzf3zW64CTDR3VOAf+po=;
        h=Date:From:To:Subject:From;
        b=kcGiGeNeNXxKuZ1v5XEUqe/KyvHgL7m/XoK9lHaaE7+q+ZbYB86/jDb93euYHopx2
         bnUcfGqc+Qzecz4JQdPbnH8IE30MQyHVz/DvcvNatAcOupPYa393j1R+Q+N3HqpWrt
         jK46mjprBEX92dvOdggCLCHEfgCVUaBNid04ivOM=
Date:   Thu, 10 Jun 2021 15:24:57 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-thp-fix-page_address_in_vma-on-file-thp-tails.patch
 added to -mm tree
Message-ID: <20210610222457._rrepM0-r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix page_address_in_vma() on file THP tails
has been added to the -mm tree.  Its filename is
     mm-thp-fix-page_address_in_vma-on-file-thp-tails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-page_address_in_vma-on-file-thp-tails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-page_address_in_vma-on-file-thp-tails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jue Wang <juew@google.com>
Subject: mm/thp: fix page_address_in_vma() on file THP tails

Anon THP tails were already supported, but memory-failure may need to use
page_address_in_vma() on file THP tails, which its page->mapping check did
not permit: fix it.

hughd adds: no current usage is known to hit the issue, but this does fix
a subtle trap in a general helper: best fixed in stable sooner than later.

Link: https://lkml.kernel.org/r/a0d9b53-bf5d-8bab-ac5-759dc61819c1@google.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-thp-fix-page_address_in_vma-on-file-thp-tails
+++ a/mm/rmap.c
@@ -716,11 +716,11 @@ unsigned long page_address_in_vma(struct
 		if (!vma->anon_vma || !page__anon_vma ||
 		    vma->anon_vma->root != page__anon_vma->root)
 			return -EFAULT;
-	} else if (page->mapping) {
-		if (!vma->vm_file || vma->vm_file->f_mapping != page->mapping)
-			return -EFAULT;
-	} else
+	} else if (!vma->vm_file) {
+		return -EFAULT;
+	} else if (vma->vm_file->f_mapping != compound_head(page)->mapping) {
 		return -EFAULT;
+	}
 
 	return vma_address(page, vma);
 }
_

Patches currently in -mm which might be from juew@google.com are

mm-thp-fix-page_address_in_vma-on-file-thp-tails.patch

