Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0449EC77B73
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 20:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjEBUUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 16:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjEBUUf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 16:20:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA52198C;
        Tue,  2 May 2023 13:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3BC61EC7;
        Tue,  2 May 2023 20:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB86C433EF;
        Tue,  2 May 2023 20:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683058833;
        bh=Er00lxemRAH2CJdQ9ZSEv7BEzN3I9d2HxtrMb/tD+jc=;
        h=Date:To:From:Subject:From;
        b=1/uv7E8H/UcPGT29gcy8gPO+d+qL55r7kFTNMcN7Kn4xaOTF333c/mNmYfKf+QA/c
         3THWc3c4CQK825yOU+JpMey4QZL1u25UWnx3FT6/C08ednygKI3cbE5U7Jwi073ZIN
         P1xl6aE9KdHc/5ojYNmoHZzW2Cn1WTMQIua4HhdU=
Date:   Tue, 02 May 2023 13:20:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, peterx@redhat.com, lstoakes@gmail.com,
        jhubbard@nvidia.com, hch@lst.de, david@redhat.com, jack@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-reclaim-private-data-from-pinned-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502202033.4FB86C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not reclaim private data from pinned page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-do-not-reclaim-private-data-from-pinned-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-reclaim-private-data-from-pinned-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jan Kara <jack@suse.cz>
Subject: mm: do not reclaim private data from pinned page
Date: Fri, 28 Apr 2023 14:41:40 +0200

If the page is pinned, there's no point in trying to reclaim it. 
Furthermore if the page is from the page cache we don't want to reclaim
fs-private data from the page because the pinning process may be writing
to the page at any time and reclaiming fs private info on a dirty page can
upset the filesystem (see link below).

Link: https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
Link: https://lkml.kernel.org/r/20230428124140.30166-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c~mm-do-not-reclaim-private-data-from-pinned-page
+++ a/mm/vmscan.c
@@ -1967,6 +1967,16 @@ retry:
 			}
 		}
 
+		/*
+		 * Folio is unmapped now so it cannot be newly pinned anymore.
+		 * No point in trying to reclaim folio if it is pinned.
+		 * Furthermore we don't want to reclaim underlying fs metadata
+		 * if the folio is pinned and thus potentially modified by the
+		 * pinning process as that may upset the filesystem.
+		 */
+		if (folio_maybe_dma_pinned(folio))
+			goto activate_locked;
+
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			/*
_

Patches currently in -mm which might be from jack@suse.cz are

mm-do-not-reclaim-private-data-from-pinned-page.patch

