Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6062CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbiD1VvM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiD1VvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:51:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67447BB0A4
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD00B83076
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C787EC385AD;
        Thu, 28 Apr 2022 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651182471;
        bh=QxV56vp26aBUfLrO3LaotEYYQ2LomfH9BeU8vgpACZk=;
        h=Date:To:From:Subject:From;
        b=HXzDRkR/SjOWutxmy8++XGzRcMDKdZPO3MUx969qpg/wfBKwwTiauFulDM7ZxF62b
         xi++ThRZGdiZ2y+rEKYUT3DQllnIliy5kk7tZSO9hVmsND2t5iZFpeA/eDhVmPIjWP
         tDyRBGZAZq7Vj5eFXMD6cVsufYg8Faomu0rcSs/w=
Date:   Thu, 28 Apr 2022 14:47:50 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-delete-dead-code-in-do_brk_flags.patch added to -mm tree
Message-Id: <20220428214751.C787EC385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: delete dead code in do_brk_flags()
has been added to the -mm tree.  Its filename is
     mm-mmap-delete-dead-code-in-do_brk_flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-delete-dead-code-in-do_brk_flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-delete-dead-code-in-do_brk_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/mmap: delete dead code in do_brk_flags()

This code can't be reached.  It's harmless but it leads to a Smatch
warning:

    mm/mmap.c:3040 do_brk_flags() warn: ignoring unreachable code.

Link: https://lkml.kernel.org/r/YmqHrpo/cBBq6lHf@kili
Fixes: d2bbe46ab3b9 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-delete-dead-code-in-do_brk_flags
+++ a/mm/mmap.c
@@ -3031,7 +3031,6 @@ out:
 	validate_mm(mm);
 	return 0;
 
-	vm_area_free(vma);
 vma_alloc_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-mmap-delete-dead-code-in-do_brk_flags.patch

