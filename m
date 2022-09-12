Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AE1ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiILDdW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILDbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C04413F6B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 975A7B8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2859AC433C1;
        Mon, 12 Sep 2022 03:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953383;
        bh=KewPYDwbBcRC/mKXfVbbipFxerL786QKDIF21+bZXpw=;
        h=Date:To:From:Subject:From;
        b=KmaSi440rFCmSRr8TxywloNgrKlE+NomqdWYXiKwcO/Wh84IMNzXlg4ax9/iXE88a
         Qlk0Ppm6A6HKIkVhklnEKBIMvnH9a6t8doAdBRUxwKDzV1WzLk92DR21kKmt2fLeAU
         JHY2qYiXTDW8gk9u7QYiOdIenm+VNG9wOTmq4u0c=
Date:   Sun, 11 Sep 2022 20:29:42 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch removed from -mm tree
Message-Id: <20220912032943.2859AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: add api documentation for walk_page_range_novma()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: pagewalk: add api documentation for walk_page_range_novma()
Date: Mon, 22 Aug 2022 15:02:36 +0200

Link: https://lkml.kernel.org/r/8991525.CDJkKcVGEf@devpool047
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-add-api-documentation-for-walk_page_range_novma
+++ a/mm/pagewalk.c
@@ -479,7 +479,15 @@ int walk_page_range(struct mm_struct *mm
 	return err;
 }
 
-/*
+/**
+ * walk_page_range_novma - walk a range of pagetables not backed by a vma
+ * @mm:		mm_struct representing the target process of page table walk
+ * @start:	start address of the virtual address range
+ * @end:	end address of the virtual address range
+ * @ops:	operation to call during the walk
+ * @pgd:	pgd to walk if different from mm->pgd
+ * @private:	private data for callbacks' usage
+ *
  * Similar to walk_page_range() but can walk any page tables even if they are
  * not backed by VMAs. Because 'unusual' entries may be walked this function
  * will also not lock the PTEs for the pte_entry() callback. This is useful for
_

Patches currently in -mm which might be from eb@emlix.com are


