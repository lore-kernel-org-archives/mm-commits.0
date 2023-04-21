Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F3DC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjDUVxI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbjDUVws (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7709E2711
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5849B618A6
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEEBC4339B;
        Fri, 21 Apr 2023 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113965;
        bh=TZ4mgBYQSr9IVzvi1lC8YBCGOk2qVKOvQhAHeI82450=;
        h=Date:To:From:Subject:From;
        b=P0OL5FGEArHmmXqz0dR+3/8M4EkzuzYQFLEHX/WoD9FQ6bn4TbTLhYsSeJcHhzYMK
         xOV/qb1mpwK4wdDFmbmUxFvD4waOnGgVmF4HS0dTCLQ/VbXDoZqiXcCNzDtM3hO2/z
         4YkdMZg33pWWQSPg795cCuoTROmjDvZQZZd59U7g=
Date:   Fri, 21 Apr 2023 14:52:45 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, mike.kravetz@oracle.com, david@redhat.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-use-helper-function-range_in_vma.patch removed from -mm tree
Message-Id: <20230421215245.AAEEBC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: use helper function range_in_vma()
has been removed from the -mm tree.  Its filename was
     userfaultfd-use-helper-function-range_in_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: use helper function range_in_vma()
Date: Mon, 17 Apr 2023 08:39:19 +0800

We can use range_in_vma() to check if dst_start, dst_start + len are
within the dst_vma range.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20230417003919.930515-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-use-helper-function-range_in_vma
+++ a/mm/userfaultfd.c
@@ -31,11 +31,7 @@ struct vm_area_struct *find_dst_vma(stru
 	struct vm_area_struct *dst_vma;
 
 	dst_vma = find_vma(dst_mm, dst_start);
-	if (!dst_vma)
-		return NULL;
-
-	if (dst_start < dst_vma->vm_start ||
-	    dst_start + len > dst_vma->vm_end)
+	if (!range_in_vma(dst_vma, dst_start, dst_start + len))
 		return NULL;
 
 	/*
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


