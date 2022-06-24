Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B27C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 20:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiFXUbs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 16:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiFXUbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 16:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A256F791
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 13:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C58B262262
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 20:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28571C34114;
        Fri, 24 Jun 2022 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656102705;
        bh=joiEafCh/hfv6v3oHqB1FQrbuXSoQr9Uf+RiL4VJHDI=;
        h=Date:To:From:Subject:From;
        b=B4KIDTrAsNKOvI68/YdaxO697i7xR/D/7nahPAf+eQ8ME6OeUYEf0jEGo6OuagnIm
         SD4OTPKDVa1T3I8yvc7urckRPhqmFc6t3fApRRi7C7SJCk3izDybOm6D148CbsDf9z
         5gIJBOVtcNDFdBU14snWhXepmtZ4R4fusLMQbl1Q=
Date:   Fri, 24 Jun 2022 13:31:44 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hulkci@huawei.com, yangyingliang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix.patch added to mm-unstable branch
Message-Id: <20220624203145.28571C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix error return code in do_mas_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix.patch

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
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/mmap: fix error return code in do_mas_align_munmap()
Date: Thu, 23 Jun 2022 21:42:37 +0800

Return error code when munmap_sidetree() fails in do_mas_align_munmap().

Link: https://lkml.kernel.org/r/20220623134237.2127440-1-yangyingliang@huawei.com
Fixes: 81f5504dfb36 ("mm/mmap: change do_mas_align_munmap() to avoid preallocations for sidetree")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-remove-the-vma-linked-list-fix
+++ a/mm/mmap.c
@@ -2469,7 +2469,8 @@ do_mas_align_munmap(struct ma_state *mas
 
 			mas_set(mas, end);
 			split = mas_prev(mas, 0);
-			if (munmap_sidetree(split, &mas_detach))
+			error = munmap_sidetree(split, &mas_detach);
+			if (error)
 				goto munmap_sidetree_failed;
 
 			count++;
@@ -2477,7 +2478,8 @@ do_mas_align_munmap(struct ma_state *mas
 				vma = split;
 			break;
 		}
-		if (munmap_sidetree(next, &mas_detach))
+		error = munmap_sidetree(next, &mas_detach);
+		if (error)
 			goto munmap_sidetree_failed;
 
 		count++;
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-remove-the-vma-linked-list-fix.patch

