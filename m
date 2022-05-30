Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF11C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 30 May 2022 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiE3UaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 May 2022 16:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiE3UaV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 May 2022 16:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EA872E15
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 13:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D9CB80DB4
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 20:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15600C385B8;
        Mon, 30 May 2022 20:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653942618;
        bh=P7rc9w1EEtAxS/Qm+EnCkCfX7D3kxxCOD7QKJxMr0/g=;
        h=Date:To:From:Subject:From;
        b=LHIuZ7/unsGSD5YbGMwYtEQXFJlrBEFBtY3ThA0+gxdWeR14B7NKWDY833Te+ZHqe
         Q6acwTlAxc0N+gtZFG1bGaBQPYBeP8D4Fjnj3xTp6l54DTPxWDaBk8SNH/R+fsK2GW
         YolJIBYUgn1es5pDgFbO/zJflL793sTgFM3ZSvz4=
Date:   Mon, 30 May 2022 13:30:17 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch added to mm-unstable branch
Message-Id: <20220530203018.15600C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: remove unneeded lock page and PageMovable check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove unneeded lock page and PageMovable check
Date: Mon, 30 May 2022 19:30:14 +0800

When non-lru movable page was freed from under us, __ClearPageMovable must
have been done.  So we can remove unneeded lock page and PageMovable check
here.  Also free_pages_prepare() will clear PG_isolated for us, so we can
further remove ClearPageIsolated as suggested by David.

Link: https://lkml.kernel.org/r/20220530113016.16663-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-lock-page-and-pagemovable-check
+++ a/mm/migrate.c
@@ -1090,15 +1090,10 @@ static int unmap_and_move(new_page_t get
 		return -ENOSYS;
 
 	if (page_count(page) == 1) {
-		/* page was freed from under us. So we are done. */
+		/* Page was freed from under us. So we are done. */
 		ClearPageActive(page);
 		ClearPageUnevictable(page);
-		if (unlikely(__PageMovable(page))) {
-			lock_page(page);
-			if (!PageMovable(page))
-				ClearPageIsolated(page);
-			unlock_page(page);
-		}
+		/* free_pages_prepare() will clear PG_isolated. */
 		goto out;
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-maintainer-information-for-z3fold.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

