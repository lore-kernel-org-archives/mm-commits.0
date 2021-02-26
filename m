Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDF1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C379B60202
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhBZAhH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhBZAhG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:37:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E055360202;
        Fri, 26 Feb 2021 00:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299786;
        bh=+ZKhhyHd7HngCjHVVuOX5pXEVbhxDFa5m6OG/1y2jt0=;
        h=Date:From:To:Subject:From;
        b=rKVyZpiaJuwMvm7yzoqjEaKCIsCijYso2A/AtYtZhgZNFg8ZYiHudVDwU5VdIueSz
         Fqg+SFp+dOO6HHblWqzf2+VqjyqCEcSUjI0cDXjDWoRPn/ICg5d/5LZ2yLga9ktYLf
         DEA2n6awyLG8a6xp6WynB8Op6Kp1+8uCstsHOgvg=
Date:   Thu, 25 Feb 2021 16:36:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 mm-filemap-add-helper-for-finding-pages-fix.patch removed from -mm tree
Message-ID: <20210226003625.8qQ9tEKcR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix mm-filemap-add-helper-for-finding-pages.patch
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-helper-for-finding-pages-fix.patch

This patch was dropped because it was folded into mm-filemap-add-helper-for-finding-pages.patch

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
@@ -1852,7 +1852,6 @@ retry:
 		put_page(page);
 		goto reset;
 	}
-	VM_BUG_ON_PAGE(!thp_contains(page, xas->xa_index), page);
 
 	return page;
 reset:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
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

