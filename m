Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0C9C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiEJESR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiEJERR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84019136F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A810E61746
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089FBC385C2;
        Tue, 10 May 2022 04:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155950;
        bh=5nXF+K+LMqtiSJeV1ZsFnOsvnw6Qu3X9yLY/jaalmJI=;
        h=Date:To:From:Subject:From;
        b=C6DHPuYeBrZhWon48vc/yKNPa63IIbQjBYb7VWvG2Y/64qNIEYELKoPJAm11B96Nj
         N0PS4yhcWP8QNqOhmJH5/rWSC3Ie3mE2T/eQUAJ5dAQOZbNLVu9vogmOeK6ZC6b4r+
         0aIHtrUMWrr4nKakldvjcdLRYsxJfPh+WCX5CtHc=
Date:   Mon, 09 May 2022 21:12:29 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        nathanl@linux.ibm.com, mhocko@suse.com, gregkh@linuxfoundation.org,
        david@redhat.com, cheloha@linux.vnet.ibm.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch removed from -mm tree
Message-Id: <20220510041230.089FBC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-an-unlikely-reference-counting-issue-in-__add_memory_block.patch

This patch was dropped because it was merged into mm-stable

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


