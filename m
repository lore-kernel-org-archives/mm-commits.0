Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC88C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 189FF64F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhBXUNI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235507AbhBXUKv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB1164F20;
        Wed, 24 Feb 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197409;
        bh=juL+5lyI9b1Hdl5lDh7SDbMIrdL7R4f4tvjKK++GYio=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pMTliPgkYeGKgpA6nSmp1knXiP+BQ8OR5IV/teoWP8YuyJht43ncSfQbzVj7haVmb
         +e9F1kORNJbqFCz4d7SvanI+EkITQZGBEKC9C4ejKMBhOUFgrvfiENAiJkgCF/dVUJ
         NsuMuWnVHZ0JC8BwoMJlMafhZ8EX0D125sweFp5E=
Date:   Wed, 24 Feb 2021 12:10:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 167/173] hugetlbfs: correct obsolete function name
 in hugetlbfs_read_iter()
Message-ID: <20210224201008.DyxiBZKNy%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
