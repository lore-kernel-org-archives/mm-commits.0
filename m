Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A47C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiCVVo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiCVVo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8835F4D2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4958060A14
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11A7C340F3;
        Tue, 22 Mar 2022 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985359;
        bh=sgXnbpK3OL1x/YqQqwFQP1CQFUTj6EI9JU7bIqejWBM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=g+0ewIdnB1OvfZkdktYnBJQhcP3dAkyC4eZmZlQDr7kyLPR8M0/UF3BtWkbRnQVzi
         M4BQqI6uhGRgIupUFI6rlglvmy/fAExJ+A/uwxTN+wspNSFkdj+ZlhLlUnEEruPJ6F
         4UdatXb9IlcznJ3FSoP0yPTqv4k7xeVZWg1oKhw8=
Date:   Tue, 22 Mar 2022 14:42:39 -0700
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 081/227] mm/mmap: remove obsolete comment in ksys_mmap_pgoff
Message-Id: <20220322214239.A11A7C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap: remove obsolete comment in ksys_mmap_pgoff

RLIMIT_MEMLOCK is already reimplemented on top of ucounts now.  And since
commit 83c1fd763b32 ("mm,hugetlb: remove mlock ulimit for SHM_HUGETLB"),
mlock ulimit for SHM_HUGETLB is further removed.  So we should remove this
obsolete comment.

Link: https://lkml.kernel.org/r/20220309090623.13036-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1616,8 +1616,6 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
-		 * A dummy user value is used because we are not locking
-		 * memory so no accounting is necessary
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 				VM_NORESERVE,
_
