Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488D1C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A6864FB9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhBECdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230245AbhBECdL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCBC764FB7;
        Fri,  5 Feb 2021 02:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492338;
        bh=D3win9cBiJAHKxX/4SIDR9bywl+666gt31YejXJeT6s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C6qtU7FdiqBuDIIbp8menZfGD5qO+XjkvQaoG4oFqTjwYVB5tfxP15fskXSeDvm0/
         fNm7jI3xq4EMYKSaVIqRnJVS0A4DCOFNveC9GNKmtIA0aopziVeRmEPp/nDIJ3ZgZ3
         8upn1ZjNAjkrHSf8zNyg+FEocZL5uPOuZ0hLfxq0=
Date:   Thu, 04 Feb 2021 18:32:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 05/18] mm: migrate: do not migrate HugeTLB page
 whose refcount is one
Message-ID: <20210205023217.P0pR8PLuH%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one

All pages isolated for the migration have an elevated reference count and
therefore seeing a reference count equal to 1 means that the last user of
the page has dropped the reference and the page has became unused and
there doesn't make much sense to migrate it anymore.  This has been done
for regular pages and this patch does the same for hugetlb pages. 
Although the likelihood of the race is rather small for hugetlb pages it
makes sense the two code paths in sync.

Link: https://lkml.kernel.org/r/20210115124942.46403-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/migrate.c~mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one
+++ a/mm/migrate.c
@@ -1280,6 +1280,12 @@ static int unmap_and_move_huge_page(new_
 		return -ENOSYS;
 	}
 
+	if (page_count(hpage) == 1) {
+		/* page was freed from under us. So we are done. */
+		putback_active_hugepage(hpage);
+		return MIGRATEPAGE_SUCCESS;
+	}
+
 	new_hpage = get_new_page(hpage, private);
 	if (!new_hpage)
 		return -ENOMEM;
_
