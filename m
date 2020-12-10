Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996BBC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D18723B51
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgLJACE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgLJACE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:02:04 -0500
Date:   Wed, 09 Dec 2020 16:01:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607558483;
        bh=1wCMy/N9fqkLAxhQ3HDdu/cbLMeOpmRMTSYhE08ttDM=;
        h=From:To:Subject:From;
        b=hEJnNUiIvXXPGyKTYdpVKKGJYJmKPfynyl7NnOezQz+OCmzNE1DnV8DYVuA6IC3HG
         TF7ci/1+fHWxRMze3K7sRfcG5qs/kUhpDIWxgS94jU5VLSdzH70gh/HNMOGjhcV2k8
         ShcJxZRD1zwDi6F4Pil+I5Dh8F4Go9oGLuFMFlnk=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        naoya.horiguchi@nec.com, david@redhat.com, osalvador@suse.de
Subject:  + mmhwpoison-return-ebusy-when-migration-fails.patch added
 to -mm tree
Message-ID: <20201210000122.OryER%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return -EBUSY when migration fails
has been added to the -mm tree.  Its filename is
     mmhwpoison-return-ebusy-when-migration-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-return-ebusy-when-migration-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-return-ebusy-when-migration-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: return -EBUSY when migration fails

Currently, we return -EIO when we fail to migrate the page.

Migrations' failures are rather transient as they can happen due to
several reasons, e.g: high page refcount bump, mapping->migrate_page
failing etc.  All meaning that at that time the page could not be
migrated, but that has nothing to do with an EIO error.

Let us return -EBUSY instead, as we do in case we failed to isolate the
page.

While are it, let us remove the "ret" print as its value does not change.

Link: https://lkml.kernel.org/r/20201209092818.30417-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-return-ebusy-when-migration-fails
+++ a/mm/memory-failure.c
@@ -1855,11 +1855,11 @@ static int __soft_offline_page(struct pa
 			pr_info("soft offline: %#lx: %s migration failed %d, type %lx (%pGp)\n",
 				pfn, msg_page[huge], ret, page->flags, &page->flags);
 			if (ret > 0)
-				ret = -EIO;
+				ret = -EBUSY;
 		}
 	} else {
-		pr_info("soft offline: %#lx: %s isolation failed: %d, page count %d, type %lx (%pGp)\n",
-			pfn, msg_page[huge], ret, page_count(page), page->flags, &page->flags);
+		pr_info("soft offline: %#lx: %s isolation failed, page count %d, type %lx (%pGp)\n",
+			pfn, msg_page[huge], page_count(page), page->flags, &page->flags);
 		ret = -EBUSY;
 	}
 	return ret;
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch
mmhwpoison-return-ebusy-when-migration-fails.patch
mmhugetlb-remove-unneded-initialization.patch

