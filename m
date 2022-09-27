Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DDAC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiI0Cvv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0955AEA5AC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E135B81914
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D356C433C1;
        Tue, 27 Sep 2022 02:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246937;
        bh=VaM6+QnNoRGK2YJ8wH77RsArh1AvnCweYJRWdyfPSWc=;
        h=Date:To:From:Subject:From;
        b=KflMJUYLQfTUkYj7aDUCS10qofm2QnIpXX8BCRXVKbAL4nOf3T+2TWj1KZYinKmIo
         c+tDm/YyYNbnYAAhIhqeGKQai+TMHB6dEPDdzemX4ZmsV1UBSu8mjRva6I4WhcBCdn
         daLK+hiOC0fpoO1iLZqJQ2o84y7y6LQhZrAjwE/k=
Date:   Mon, 26 Sep 2022 19:48:56 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch removed from -mm tree
Message-Id: <20220927024857.1D356C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xen: use vma_lookup() in privcmd_ioctl_mmap()
has been removed from the -mm tree.  Its filename was
     xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: xen: use vma_lookup() in privcmd_ioctl_mmap()
Date: Tue, 6 Sep 2022 19:48:49 +0000

vma_lookup() walks the VMA tree for a specific value, find_vma() will
search the tree after walking to a specific value.  It is more efficient
to only walk to the requested value since privcmd_ioctl_mmap() will exit
the loop if vm_start != msg->va.

Link: https://lkml.kernel.org/r/20220906194824.2110408-20-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/privcmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/privcmd.c~xen-use-vma_lookup-in-privcmd_ioctl_mmap
+++ a/drivers/xen/privcmd.c
@@ -282,7 +282,7 @@ static long privcmd_ioctl_mmap(struct fi
 						     struct page, lru);
 		struct privcmd_mmap_entry *msg = page_address(page);
 
-		vma = find_vma(mm, msg->va);
+		vma = vma_lookup(mm, msg->va);
 		rc = -EINVAL;
 
 		if (!vma || (msg->va != vma->vm_start) || vma->vm_private_data)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


