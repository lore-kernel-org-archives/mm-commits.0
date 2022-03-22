Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79583C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiCVVoa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiCVVo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5978B5F4F0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB4BB81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906AFC340EC;
        Tue, 22 Mar 2022 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985362;
        bh=nLd/e0wfjnqccZgkuzXkEmRaOX/nNoEF/3WrCYYj7oI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=FM55E8451rTYyUODUG37K9nGKHXIJtTlFGD9wxEk97PtcQjbBC3Rv+eqM4wmHdCta
         SXwjGvRq3G8btTfxIvmRxN9p554BOLMmbQ71J6ygxjqVG/ox3+jawbzYOylnhEU0wk
         82kVrKdW9aTprGaVHwpuE5sPYJV1YhSSYUDWsqZA=
Date:   Tue, 22 Mar 2022 14:42:41 -0700
To:     david@redhat.com, linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 082/227] mm/mremap:: use vma_lookup() instead of find_vma()
Message-Id: <20220322214242.906AFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mremap:: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the address is contained in the found vma. 
This results in easier to read code.

Link: https://lkml.kernel.org/r/20220312083118.48284-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vma_lookup-instead-of-find_vma
+++ a/mm/mremap.c
@@ -942,8 +942,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr) {
+	vma = vma_lookup(mm, addr);
+	if (!vma) {
 		ret = EFAULT;
 		goto out;
 	}
_
