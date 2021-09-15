Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A26C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4B261157
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhIOCNN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 22:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhIOCNM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 22:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE75C60FA0;
        Wed, 15 Sep 2021 02:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631671914;
        bh=9wet1D2ezRRt2HY07Um7U/UpFnoLjqtk+pPBmrSw0vU=;
        h=Date:From:To:Subject:From;
        b=aSsP06ikit0TRVie+Eb+qjjlViIAuhQHQhbFiQMsfeHITI/INxZTEv/VxKFsTPr7b
         sEqlN+v30cjqOAXKD8m8Nl6BM6CVPE0IkGJdy+KpOElzh4hAxbPzAP3vFk6O3VrSG0
         hp/Mq+trYs+5CW2sKw6hcHB3CDR8JncA9bQnH764=
Date:   Tue, 14 Sep 2021 19:11:54 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, iamjoonsoo.kim@lge.com, jhubbard@nvidia.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
 added to -mm tree
Message-ID: <20210915021154.qmte0CZC5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: guard against possible putback unisolated page
has been added to the -mm tree.  Its filename is
     mm-page_isolation-guard-against-possible-putback-unisolated-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-guard-against-possible-putback-unisolated-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_isolation: guard against possible putback unisolated page

Isolating a free page in an isolated pageblock is expected to always work
as watermarks don't apply here.  But if __isolate_free_page() failed, due
to condition changes, the page will be left on the free list.  And the
page will be put back to free list again via __putback_isolated_page(). 
This may trigger VM_BUG_ON_PAGE() on page->flags checking in
__free_one_page() if PageReported is set.  Or we will corrupt the free
list because list_add() will be called for pages already on another list. 
Add a VM_WARN_ON() to complain about this change.

Link: https://lkml.kernel.org/r/20210914114508.23725-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-guard-against-possible-putback-unisolated-page
+++ a/mm/page_isolation.c
@@ -94,8 +94,13 @@ static void unset_migratetype_isolate(st
 			buddy = page + (buddy_pfn - pfn);
 
 			if (!is_migrate_isolate_page(buddy)) {
-				__isolate_free_page(page, order);
-				isolated_page = true;
+				isolated_page = !!__isolate_free_page(page, order);
+				/*
+				 * Isolating a free page in an isolated pageblock
+				 * is expected to always work as watermarks don't
+				 * apply here.
+				 */
+				VM_WARN_ON(!isolated_page);
 			}
 		}
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

