Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D86E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjJDURq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbjJDURn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68C93
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ECDC433C8;
        Wed,  4 Oct 2023 20:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450659;
        bh=UWlxopo8uy1QhM6IcUkvpCwaqeqo5gulo8Paf0CzArE=;
        h=Date:To:From:Subject:From;
        b=cd0twwhE/nHdb2mV4c+VJnhSzhKo+DIleWfLWRTg7D124BJgOKP8Pj4TPYxESKuJS
         gF5QohV/Ugl7oT4i1P4Wt20OZz9sENbzUaC1R+DFou0iLLgDHlhsv5uMQUY3nyE1UJ
         ROAo0yJcKtgjljf/wgwI07WJG2aMujQrqkgb0xIU=
Date:   Wed, 04 Oct 2023 13:17:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, anthony.yznaga@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-unaccount-of-memory-on-vma_link-failure.patch removed from -mm tree
Message-Id: <20231004201739.01ECDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix unaccount of memory on vma_link() failure
has been removed from the -mm tree.  Its filename was
     mm-fix-unaccount-of-memory-on-vma_link-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix unaccount of memory on vma_link() failure
Date: Tue, 29 Aug 2023 17:43:24 -0700

Fix insert_vm_struct() so that only accounted memory is unaccounted if
vma_link() fails.

Link: https://lkml.kernel.org/r/20230830004324.16101-1-anthony.yznaga@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-unaccount-of-memory-on-vma_link-failure
+++ a/mm/mmap.c
@@ -3278,7 +3278,8 @@ int insert_vm_struct(struct mm_struct *m
 	}
 
 	if (vma_link(mm, vma)) {
-		vm_unacct_memory(charged);
+		if (vma->vm_flags & VM_ACCOUNT)
+			vm_unacct_memory(charged);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


