Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0928C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A79920791
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbhAQVnD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbhAQVnC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B2D720791;
        Sun, 17 Jan 2021 21:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919741;
        bh=xhndOXTZLi/5nNJ9ohb2JZemybUFty9w6bSOBZkaM94=;
        h=Date:From:To:Subject:From;
        b=YCLph/v7GFLf8QISsGpI8S2tj1OoQK5qxk5qo2+S58PVnOK0eU/jbEo0a9kx2ZvFT
         B1S53o4fU8RzUhXbcD/fJoJ/eGyN5cArw5ZP0Kg3duH6OhemHbKUV9sxQLYe38odQl
         rBZq0LSYGcmHftrefCdnHO/w9IEzlFUNtBfwgcdA=
Date:   Sun, 17 Jan 2021 13:42:20 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  + mm-debug-improve-memcg-debugging.patch added to -mm
 tree
Message-ID: <20210117214220.vAZRRG_0x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: improve memcg debugging
has been added to the -mm tree.  Its filename is
     mm-debug-improve-memcg-debugging.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug-improve-memcg-debugging.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-improve-memcg-debugging.patch

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
Subject: mm/debug: improve memcg debugging

The memcg_data is only valid on the head page, not the tail pages.  Change
the format and location of the printout within the dump to match the other
parts of struct page better.

Link: https://lkml.kernel.org/r/20210114190200.1894484-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/debug.c~mm-debug-improve-memcg-debugging
+++ a/mm/debug.c
@@ -110,6 +110,11 @@ void __dump_page(struct page *page, cons
 					head_compound_mapcount(head));
 		}
 	}
+
+#ifdef CONFIG_MEMCG
+	if (head->memcg_data)
+		pr_warn("memcg:%lx\n", head->memcg_data);
+#endif
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
@@ -180,11 +185,6 @@ hex_only:
 
 	if (reason)
 		pr_warn("page dumped because: %s\n", reason);
-
-#ifdef CONFIG_MEMCG
-	if (!page_poisoned && page->memcg_data)
-		pr_warn("pages's memcg:%lx\n", page->memcg_data);
-#endif
 }
 
 void dump_page(struct page *page, const char *reason)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-improve-memcg-debugging.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

