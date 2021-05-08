Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558D5C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389C0613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEHWuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 972806101D;
        Sat,  8 May 2021 22:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514154;
        bh=2TlAHCbydz5icjBuM5Z7/QWz5o+fkWSJnFcdUhl2WNM=;
        h=Date:From:To:Subject:From;
        b=e26yQjAPJ2idqyXH7rPXvy/XWTdLgbedDHn5XVI+czBiZiqJqOdvy5sBa3J81tNMo
         kzI1zZ6VwT8kvJ5cQdZTTmsg2OOXAopVS+sApM0K50Ecd6viJCHEUKOXS9GXaXXRy8
         Bx1DzAst0eAo3RPRTOFueybaQPobcld9za5VBfeM=
Date:   Sat, 08 May 2021 15:49:14 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-migratec-fix-potential-indeterminate-pte-entry-in-migra?=
 =?US-ASCII?Q?te=5Fvma=5Finsert=5Fpage.patch?= removed from -mm tree
Message-ID: <20210508224914.tSswA0_FF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
has been removed from the -mm tree.  Its filename was
     mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


