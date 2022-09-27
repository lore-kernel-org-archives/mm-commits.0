Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A1DC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiI0Czb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiI0CyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C5140EC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89197B8190D
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457FAC433C1;
        Tue, 27 Sep 2022 02:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246991;
        bh=UQIXV5n1u96RrS4pH/I0avmOQ70NiQps9B8JKl2eFe0=;
        h=Date:To:From:Subject:From;
        b=XrdJJYEioEPBvDpNmaxqN4sezonsrymBKcwnOltpTHTPQD5KMJNoZkdiEvmOfYJEK
         7R9G32kFhRj1AUs6SAOa5mzNQ8CTzv3smzYxc0lr+zf8Pdi1orVMpok+iigMfRTr00
         wh1jDVyXchOXKJQIUC2mpfSZHZi2UXrDJrrSSRNg=
Date:   Mon, 26 Sep 2022 19:49:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-msync-use-vma_find-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024951.457FAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/msync: use vma_find() instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-msync-use-vma_find-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/msync: use vma_find() instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:03 +0000

Remove a single use of the vma linked list in preparation for the
removal of the linked list.  Uses find_vma() to get the next element.

Link: https://lkml.kernel.org/r/20220906194824.2110408-61-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/msync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/msync.c~mm-msync-use-vma_find-instead-of-vma-linked-list
+++ a/mm/msync.c
@@ -104,7 +104,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 				error = 0;
 				goto out_unlock;
 			}
-			vma = vma->vm_next;
+			vma = find_vma(mm, vma->vm_end);
 		}
 	}
 out_unlock:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


