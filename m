Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B35C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9702561029
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhEEBiG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94507610A1;
        Wed,  5 May 2021 01:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178630;
        bh=oA3IsigLUkFUxEgNKlUCMt301JlR4tr4UAaxIQTTqb8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CdQMXsNEMMMwATto74sZZA4MCmuge1l4OkRUvTPClkY3sZdUmL3b6I5LYfgZYUOHT
         pXeB+GWEc6YscdgAi9HZ4/f+sjZaTI/kZaTi2AUjQvOjABxO/bwJSVGxa+s1hmReqZ
         tqdSOmIBln23JqAbpIcuz231JiLnIcOJT+ikyB9k=
Date:   Tue, 04 May 2021 18:37:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, aquini@redhat.com,
        david@redhat.com, jglisse@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 082/143] mm/migrate.c: fix potential indeterminate
 pte entry in migrate_vma_insert_page()
Message-ID: <20210505013710.tBHbfbSFt%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()

If the zone device page does not belong to un-addressable device memory,
the variable entry will be uninitialized and lead to indeterminate pte
entry ultimately.  Fix this unexpected case and warn about it.

Link: https://lkml.kernel.org/r/20210325131524.48181-4-linmiaohe@huawei.com
Fixes: df6ad69838fc ("mm/device-public-memory: device memory cache coherent with CPU")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/migrate.c~mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page
+++ a/mm/migrate.c
@@ -2947,6 +2947,13 @@ static void migrate_vma_insert_page(stru
 
 			swp_entry = make_device_private_entry(page, vma->vm_flags & VM_WRITE);
 			entry = swp_entry_to_pte(swp_entry);
+		} else {
+			/*
+			 * For now we only support migrating to un-addressable
+			 * device memory.
+			 */
+			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
+			goto abort;
 		}
 	} else {
 		entry = mk_pte(page, vma->vm_page_prot);
_
