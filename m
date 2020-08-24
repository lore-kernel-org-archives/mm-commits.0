Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD16C433E3
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB02D207DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598307576;
	bh=T7bx9cqTT4ELO+4LAdVnWETsj8PnOfijsOv7TQwEdJg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1O5EuoBHu/QalwdxvLSTX2GqatFeEHYbi5J0YwJsCqoFnmyOjh+AEhRG+9M7586lC
	 LRQdXxt0w4nhBoGJdFOM+N3dbVSUW09URndvTIiJ70da0hd/u6z5tZn3i/a6tmeLfY
	 8SNzFCsX4wrrdTzAjPmcY2M56f8wGABNYXpkmk5w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXWTg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgHXWTe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 18:19:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47832078A;
        Mon, 24 Aug 2020 22:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598307572;
        bh=T7bx9cqTT4ELO+4LAdVnWETsj8PnOfijsOv7TQwEdJg=;
        h=Date:From:To:Subject:From;
        b=kzBQKr/R4EFbfrGkG8pyus9wty/zGIdy69O6f2hH2ETmH2kXkcy7yTQvgEGkv8Zt8
         4EfmHjkv8IlPW68Ss2+uq7wKx82kB1b+sK8awc8lJyVUNETRQ33+0s8fXf4NivqDpz
         u3PfCpx2fjx3F53HA8WdCJaelBwPvtkTUWNLDpsE=
Date:   Mon, 24 Aug 2020 15:19:31 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  + mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch
 added to -mm tree
Message-ID: <20200824221931.jL7nashMS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: remove the unnecessary non_swap_entry()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/hugetlb.c: remove the unnecessary non_swap_entry()

If a swap entry tests positive for either is_[migration|hwpoison]_entry(),
then its swap_type() is among SWP_MIGRATION_READ, SWP_MIGRATION_WRITE and
SWP_HWPOISON.  All these types >= MAX_SWAPFILES, exactly what is asserted
with non_swap_entry().

So the checking non_swap_entry() in is_hugetlb_entry_migration() and
is_hugetlb_entry_hwpoisoned() is redundant.

Let's remove it to optimize code.

Link: https://lkml.kernel.org/r/20200723032248.24772-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-remove-the-unnecessary-non_swap_entry
+++ a/mm/hugetlb.c
@@ -3774,7 +3774,7 @@ bool is_hugetlb_entry_migration(pte_t pt
 	if (huge_pte_none(pte) || pte_present(pte))
 		return false;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
+	if (is_migration_entry(swp))
 		return true;
 	else
 		return false;
@@ -3787,7 +3787,7 @@ static bool is_hugetlb_entry_hwpoisoned(
 	if (huge_pte_none(pte) || pte_present(pte))
 		return false;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
+	if (is_hwpoison_entry(swp))
 		return true;
 	else
 		return false;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch
mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch
doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch

