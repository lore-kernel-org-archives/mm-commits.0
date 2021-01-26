Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F86C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 05:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E44820732
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 05:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAZFRj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730765AbhAZBpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 20:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDEC207B3;
        Tue, 26 Jan 2021 00:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611622497;
        bh=nHgrrxtie3TTtWXQnqR0/z6SGvUzT15i2+KMZfnCIUI=;
        h=Date:From:To:Subject:From;
        b=gPjJVR6dtuF0NGqSPFtk3zrcwfykW21IYG8E82xq/nmkNALj7kXgTxftjEZzj+TWn
         A03CqT6lNKW9cySQXM/YSchV3TLvVyPa6yYdAYu9mwwT2ZDTi2GD6xE39nf+MrMxZQ
         JaEesKLigJBpWl5mH0ltfm740YRU5VoRuiQwMj8Y=
Date:   Mon, 25 Jan 2021 16:54:56 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        song.bao.hua@hisilicon.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  + mm-zswap-fix-potential-memory-leak.patch added to -mm
 tree
Message-ID: <20210126005456.zj8snkPOL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix potential memory leak
has been added to the -mm tree.  Its filename is
     mm-zswap-fix-potential-memory-leak.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-fix-potential-memory-leak.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-fix-potential-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm/zswap: fix potential memory leak

If entry is NULL, the requested memory tmp should be freed, otherwise it
may cause a memory leak.

Link: https://lkml.kernel.org/r/1611538365-51811-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-fix-potential-memory-leak
+++ a/mm/zswap.c
@@ -961,6 +961,7 @@ static int zswap_writeback_entry(struct
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		zpool_unmap_handle(pool, handle);
+		kfree(tmp);
 		return 0;
 	}
 	spin_unlock(&tree->lock);
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch
mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch
mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch
mm-zswap-fix-potential-memory-leak.patch

