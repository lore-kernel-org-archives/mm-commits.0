Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B0CC2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C34E224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgLODNp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgLODNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:25 -0500
Date:   Mon, 14 Dec 2020 19:11:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001912;
        bh=YsP+i/vgnF710jv3WpfvGibcJx6P0W3kfdPfNezJNrw=;
        h=From:To:Subject:In-Reply-To:From;
        b=CAhiIT2yhotsmkDlJl5rGwhGLeKXl9xt3gWvVgeePgv4+Dl/7B39Imxy3pa4uDcXv
         YDiZ7F+MS20aIfNB2IwHwmSLvQT1XZ6W3QnjZSGurhWhGCOEpcyZIBd+ao4rh5UJ7F
         OWzhS4QLNLTcidjdDZWboCWMueeTjNfhjbnaa9sw=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 145/200] mm,hwpoison: return -EBUSY when migration
 fails
Message-ID: <20201215031151._R7aOpU60%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
