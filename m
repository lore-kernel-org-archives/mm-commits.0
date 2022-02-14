Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FA2C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 23:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiBNXY1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:24:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiBNXY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 18:24:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA85413C9DA
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 15:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D2D61537
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 23:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A295FC340E9;
        Mon, 14 Feb 2022 23:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644881057;
        bh=BnO48UIGq9kMvfIsIDwq3MZpGLZcQDwnpyDsreU4o2c=;
        h=Date:To:From:Subject:From;
        b=uFUhTEspxlAn5UrdRd9GBUUcjCF9OXR1GR00i8B6H4I6NwpMbpCMsZxrnBJQy3plI
         lwK258Xf5KCmIuT0SvcAhXoMRQLw4c/0iTKP0JTq3PJoe/cYXUkWZ/8/tqKVOzixjE
         +eRkUkxHP/AGn/2a/0X4O44oKORGvASszYHmqmt8=
Date:   Mon, 14 Feb 2022 15:24:17 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, mgorman@suse.de, linmiaohe@huawei.com,
        hannes@cmpxchg.org, riel@surriel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch added to -mm tree
Message-Id: <20220214232417.A295FC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: invalidate hwpoison page cache page in fault path
has been added to the -mm tree.  Its filename is
     mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: invalidate hwpoison page cache page in fault path

Sometimes the page offlining code can leave behind a hwpoisoned clean page
cache page.  This can lead to programs being killed over and over and over
again as they fault in the hwpoisoned page, get killed, and then get
re-spawned by whatever wanted to run them.

This is particularly embarrassing when the page was offlined due to having
too many corrected memory errors.  Now we are killing tasks due to them
trying to access memory that probably isn't even corrupted.

This problem can be avoided by invalidating the page from the page fault
handler, which already has a branch for dealing with these kinds of pages.
With this patch we simply pretend the page fault was successful if the
page was invalidated, return to userspace, incur another page fault, read
in the file from disk (to a new memory page), and then everything works
again.

Link: https://lkml.kernel.org/r/20220212213740.423efcea@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-clean-up-hwpoison-page-cache-page-in-fault-path
+++ a/mm/memory.c
@@ -3926,11 +3926,16 @@ static vm_fault_t __do_fault(struct vm_f
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
-		if (ret & VM_FAULT_LOCKED)
+		vm_fault_t poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf->page))
+				poisonret = 0;
 			unlock_page(vmf->page);
+		}
 		put_page(vmf->page);
 		vmf->page = NULL;
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
_

Patches currently in -mm which might be from riel@surriel.com are

mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch

