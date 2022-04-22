Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E2DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiDVWN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiDVWM1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:12:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB0305A61
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC33761E06
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5D2C385A4;
        Fri, 22 Apr 2022 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650661150;
        bh=X8iPNU/TbF96nzWl99TXfCtk5HmpSUMDg1aRaLtqCjY=;
        h=Date:To:From:Subject:From;
        b=i6J7APY5N/sYAoF3tWoq1oYOPR98vynrxkLPgmi5qM7dhYo3jtTvvyM2KPbyvLDKQ
         5mye43UbLj68kIi0GIWkYtnfcyT3QVG9r97T0kA+I0AjVk+ruGBeuMxnN4TaziOj8m
         YIzxzcKF8hcHAP62M40KVehP+NSjpqqLFh9+SNZU=
Date:   Fri, 22 Apr 2022 13:59:09 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        nathanl@linux.ibm.com, mhocko@suse.com, gregkh@linuxfoundation.org,
        david@redhat.com, cheloha@linux.vnet.ibm.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch added to -mm tree
Message-Id: <20220422205910.2E5D2C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()
has been added to the -mm tree.  Its filename is
     drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()

__add_memory_block() calls both put_device() and device_unregister() when
storing the memory block into the xarray.  This is incorrect because
xarray doesn't take an additional reference and device_unregister()
already calls put_device().

Triggering the issue looks really unlikely and its only effect should be
to log a spurious warning about a ref counted issue.

Link: https://lkml.kernel.org/r/d44c63d78affe844f020dc02ad6af29abc448fc4.1650611702.git.christophe.jaillet@wanadoo.fr
Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Scott Cheloha <cheloha@linux.vnet.ibm.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block
+++ a/drivers/base/memory.c
@@ -636,10 +636,9 @@ static int __add_memory_block(struct mem
 	}
 	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
 			      GFP_KERNEL));
-	if (ret) {
-		put_device(&memory->dev);
+	if (ret)
 		device_unregister(&memory->dev);
-	}
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch

