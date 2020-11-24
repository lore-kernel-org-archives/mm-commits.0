Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9BDC6379F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5480E2085B
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3PqwSV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKXEW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKXEW5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 23:22:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF96D20857;
        Tue, 24 Nov 2020 04:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606191777;
        bh=3NE9xB6ZI7XJpwK0Zam04BATqIEKZW9C1s0RXDNxzVw=;
        h=Date:From:To:Subject:From;
        b=j3PqwSV54xXoOs5+sh953xQqRKcc/psVB0z3YYcVP07ftIEYYguSI2je1euiO9X4Q
         YlsdgZiLxJCtTHHHd1Xnf0R9exVzJfFOeV/oW0UOwDAhKUjbAfcEEsZblNsQuaB2vs
         f7BtKIXIjPTF5Ivckrrwmdl3LOP9PjWcwUHEfsaQ=
Date:   Mon, 23 Nov 2020 20:22:56 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-filemap-add-helper-for-finding-pages-fix.patch added
 to -mm tree
Message-ID: <20201124042256.SBZm1nsSC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix mm-filemap-add-helper-for-finding-pages.patch
has been added to the -mm tree.  Its filename is
     mm-filemap-add-helper-for-finding-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-helper-for-finding-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-helper-for-finding-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fix mm-filemap-add-helper-for-finding-pages.patch

Link: https://lkml.kernel.org/r/20201124041507.28996-2-willy@infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-add-helper-for-finding-pages-fix
+++ a/mm/filemap.c
@@ -1858,7 +1858,6 @@ retry:
 		put_page(page);
 		goto reset;
 	}
-	VM_BUG_ON_PAGE(!thp_contains(page, xas->xa_index), page);
 
 	return page;
 reset:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

