Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7847C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 829D022E01
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbhASTYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:24:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391547AbhASTUv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5BD2216FD;
        Tue, 19 Jan 2021 19:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611084011;
        bh=zTV7xOgtv6IzPoyFduuZ08uu7eXfkodeqIpx6r8IzUM=;
        h=Date:From:To:Subject:From;
        b=078E7uFS7GGlssfQqrcXtXpNT6pFhf4XYq64K2aPCnkf+KFtOKdJrS811GmZ9xRcX
         WDv+/sa4hy1JwMWuclslgtpT7kaPvHqpUXWasdXYA1tqWfStBzx82+vohsgRU1L80J
         fClQngMpwAjTw6J3mIKw8WuWY/qDSv5ywEm4xo/4=
Date:   Tue, 19 Jan 2021 11:20:09 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch added
 to -mm tree
Message-ID: <20210119192009.21hYnNSwC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: correct obsolete function name in hugetlbfs_read_iter()
has been added to the -mm tree.  Its filename is
     hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: correct obsolete function name in hugetlbfs_read_iter()

Since commit 36e789144267 ("kill do_generic_mapping_read"), the function
do_generic_mapping_read() is renamed to do_generic_file_read(). And then
commit 47c27bc46946 ("fs: pass iocb to do_generic_file_read") renamed it
to generic_file_buffered_read(). So replace do_generic_mapping_read() with
generic_file_buffered_read() to keep comment uptodate.

Link: https://lkml.kernel.org/r/20210118063210.47118-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter
+++ a/fs/hugetlbfs/inode.c
@@ -310,7 +310,7 @@ hugetlbfs_read_actor(struct page *page,
 
 /*
  * Support for read() - Find the page attached to f_mapping and copy out the
- * data. Its *very* similar to do_generic_mapping_read(), we can't use that
+ * data. Its *very* similar to generic_file_buffered_read(), we can't use that
  * since it has PAGE_SIZE assumptions.
  */
 static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

