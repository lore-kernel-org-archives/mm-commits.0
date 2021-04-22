Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F232EC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2696142F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhDVEge (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVEgd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A3161435;
        Thu, 22 Apr 2021 04:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619066159;
        bh=QerITk1SMGczbcf8L3AWDWY6anuWZUY/dgZ/ZRB8VVo=;
        h=Date:From:To:Subject:From;
        b=mb4KYhcKV8n9whjXY5uGGVVFzdh6C7VDxYWwLal8SRuY0JHpORitgyM/Xj2OrX4fb
         QKR0D0G5j4/tTqltunR+EuN/mDqAxWVtk+4CB7gODJ4txM7+Ph7JBT2s0MRGrbpbBS
         iZYQZzAYT9E3M6zfvibIZ+4+gUwIFkrN5aDjgrlo=
Date:   Wed, 21 Apr 2021 21:35:58 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch added to -mm tree
Message-ID: <20210422043558.dlryBaV6a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix find_lock_entries hang on 32-bit THP
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/filemap: fix find_lock_entries hang on 32-bit THP

No problem on 64-bit, or without huge pages, but xfstests generic/308 hung
uninterruptibly on 32-bit huge tmpfs.  Since 4.13's 0cc3b0ec23ce ("Clarify
(and fix) MAX_LFS_FILESIZE macros"), MAX_LFS_FILESIZE is only a PAGE_SIZE
away from wrapping 32-bit xa_index to 0, so the new find_lock_entries()
has to be extra careful when handling a THP.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104211735430.3299@eggly.anvils
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp
+++ a/mm/filemap.c
@@ -1969,8 +1969,14 @@ unlock:
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page))
-			xas_set(&xas, page->index + thp_nr_pages(page));
+		if (!xa_is_value(page) && PageTransHuge(page)) {
+			unsigned int nr_pages = thp_nr_pages(page);
+
+			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
+			xas_set(&xas, page->index + nr_pages);
+			if (xas.xa_index < nr_pages)
+				break;
+		}
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch
mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch
mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

