Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF33C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2406127B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhIXWpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237268AbhIXWpG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0CC61019;
        Fri, 24 Sep 2021 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523412;
        bh=E114ElZcTSr+5tsI5+ea0qeRXF7axUHZkgjp/Ds95ac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kP8Dhy7t1QyS6l9UW27bXAnPTiAgdkQxJ0+QDqHd+E823LJpfEa7CjhUDAoihZSSU
         jQd2uOOJL00p2SxNW0mceGXpCzVrbGXeSuOUzoxKLjTsj41k2ssqUCxAi9V2QMcmX5
         vNHj3YYkdeXTPqFLTsMCHcVz56tuiSWHvz5w0d2A=
Date:   Fri, 24 Sep 2021 15:43:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        liuyuntao10@huawei.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wuxu.wu@huawei.com
Subject:  [patch 05/16] mm/shmem.c: fix judgment error in
 shmem_is_huge()
Message-ID: <20210924224332.489iilWzd%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu Yuntao <liuyuntao10@huawei.com>
Subject: mm/shmem.c: fix judgment error in shmem_is_huge()

In the case of SHMEM_HUGE_WITHIN_SIZE, the page index is not rounded up
correctly.  When the page index points to the first page in a huge page,
round_up() cannot bring it to the end of the huge page, but to the end of
the previous one.

An example:

HPAGE_PMD_NR on my machine is 512(2 MB huge page size).  After allcoating
a 3000 KB buffer, I access it at location 2050 KB.  In shmem_is_huge(),
the corresponding index happens to be 512.  After rounded up by
HPAGE_PMD_NR, it will still be 512 which is smaller than i_size, and
shmem_is_huge() will return true.  As a result, my buffer takes an
additional huge page, and that shouldn't happen when shmem_enabled is set
to within_size.

Link: https://lkml.kernel.org/r/20210909032007.18353-1-liuyuntao10@huawei.com
Fixes: f3f0e1d2150b2b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: wuxu.wu <wuxu.wu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~fix-judgment-error-in-shmem_is_huge
+++ a/mm/shmem.c
@@ -490,9 +490,9 @@ bool shmem_is_huge(struct vm_area_struct
 	case SHMEM_HUGE_ALWAYS:
 		return true;
 	case SHMEM_HUGE_WITHIN_SIZE:
-		index = round_up(index, HPAGE_PMD_NR);
+		index = round_up(index + 1, HPAGE_PMD_NR);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >= HPAGE_PMD_SIZE && (i_size >> PAGE_SHIFT) >= index)
+		if (i_size >> PAGE_SHIFT >= index)
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
_
