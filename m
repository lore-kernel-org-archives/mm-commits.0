Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5A7C07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DCEB613BF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhGIXSZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhGIXSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A04613C2;
        Fri,  9 Jul 2021 23:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625872539;
        bh=nYr2TrGSD8zy+Tp34iXhjmI1qv+74PgP9GWGuSmHWgU=;
        h=Date:From:To:Subject:From;
        b=ZdL6n9h0XJpwOuObNYuZP8hDoWxmqTEoho/xKXv6B1bEEgpI6HUuTkMcPWP+PL3XI
         k7gmz4pXgFj2z1x+5ByGFJ0M6FVc/XPU1if8pC6WMrkBivFp2iXNklEebCrz8pSEjV
         tU0HlndiNXoL0u+jtZUYnWkv9dNiEMgdgvCsUD9Q=
Date:   Fri, 09 Jul 2021 16:15:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        shakeelb@google.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jgg@nvidia.com, hch@lst.de,
        apopple@nvidia.com, hughd@google.com
Subject:  +
 mm-rmap-try_to_migrate-skip-zone_device-device_private.patch added to -mm
 tree
Message-ID: <20210709231539.pW0jz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: try_to_migrate() skip zone_device !device_private
has been added to the -mm tree.  Its filename is
     mm-rmap-try_to_migrate-skip-zone_device-device_private.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-try_to_migrate-skip-zone_device-device_private.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-try_to_migrate-skip-zone_device-device_private.patch

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
Subject: mm/rmap: try_to_migrate() skip zone_device !device_private

I know nothing about zone_device pages and !device_private pages; but if
try_to_migrate_one() will do nothing for them, then it's better that
try_to_migrate() filter them first, than trawl through all their vmas.

Link: https://lkml.kernel.org/r/1241d356-8ec9-f47b-a5ec-9b2bf66d242@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-try_to_migrate-skip-zone_device-device_private
+++ a/mm/rmap.c
@@ -1702,9 +1702,6 @@ static bool try_to_migrate_one(struct pa
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
-	if (is_zone_device_page(page) && !is_device_private_page(page))
-		return true;
-
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
@@ -1943,6 +1940,9 @@ void try_to_migrate(struct page *page, e
 					TTU_SYNC)))
 		return;
 
+	if (is_zone_device_page(page) && !is_device_private_page(page))
+		return;
+
 	/*
 	 * During exec, a temporary VMA is setup and later moved.
 	 * The VMA is moved under the anon_vma lock but not the
_

Patches currently in -mm which might be from hughd@google.com are

mm-rmap-fix-comments-left-over-from-recent-changes.patch
mm-rmap-fix-old-bug-munlocking-thp-missed-other-mlocks.patch
mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch
mm-rmap-try_to_migrate-skip-zone_device-device_private.patch
fs-mm-fix-race-in-unlinking-swapfile.patch

