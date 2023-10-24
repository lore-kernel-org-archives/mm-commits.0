Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D20C07545
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 15:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbjJXPtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbjJXPtL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 11:49:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE706DE
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 08:49:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659C2C433C7;
        Tue, 24 Oct 2023 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698162549;
        bh=jEAOAftj8t36TqshIBlIEfPTRe+fjTNqfeOrziqvkmQ=;
        h=Date:To:From:Subject:From;
        b=HxyMhpUV7w4dFo0C3a8G0n3kAkYf/mTXUvFprqPzMKJH8ao/HfN30Hil5GpbT8tYd
         Klf7xG3KbA9Phe4n+qucQi+xMnB/MgpO9G+Xf0QppBzkAiQUwt7I/77h8uymrrwjUp
         nl8NwADEHw7SGjnJt4n+ahZKVDUPtu2ien9iPOqY=
Date:   Tue, 24 Oct 2023 08:49:08 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        hannes@cmpxchg.org, ddstreet@ieee.org,
        hezhongkun.hzk@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch added to mm-unstable branch
Message-Id: <20231024154909.659C2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: fix the lack of page lru flag in zswap_writeback_entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: zswap: fix the lack of page lru flag in zswap_writeback_entry
Date: Tue, 24 Oct 2023 22:27:06 +0800

The zswap_writeback_entry() will add a page to the swap cache, decompress
the entry data into the page, and issue a bio write to write the page back
to the swap device.  Move the page to the tail of lru list through
SetPageReclaim(page) and folio_rotate_reclaimable().

Currently, about half of the pages will fail to move to the tail of lru
list because there is no LRU flag in page which is not in the LRU list but
the cpu_fbatches.  So fix it.

Link: https://lkml.kernel.org/r/20231024142706.195517-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry
+++ a/mm/zswap.c
@@ -1139,6 +1139,11 @@ static int zswap_writeback_entry(struct
 	/* move it to the tail of the inactive list after end_writeback */
 	SetPageReclaim(page);
 
+	if (!PageLRU(page)) {
+		/* drain lru cache to help folio_rotate_reclaimable() */
+		lru_add_drain();
+	}
+
 	/* start writeback */
 	__swap_writepage(page, &wbc);
 	put_page(page);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch

