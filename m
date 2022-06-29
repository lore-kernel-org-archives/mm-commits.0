Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CA7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 22:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiF2Wat (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiF2Wat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 18:30:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F74D117
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 15:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B86A7CE27F1
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 22:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CE1C34114;
        Wed, 29 Jun 2022 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656541844;
        bh=rN50v6T43XW9RhsX3XXNg4IUfwrwOa+r19S60jKqOpU=;
        h=Date:To:From:Subject:From;
        b=nkhkN7mjoefr2UasSUkQPP3UEl3Su+N8fGnZzFpXeXQp79GYIB+U/2GWRgH5WCVlK
         C6ONcv4WoR8LN0EPf2XWXCF8NzDF1QGXswzS41Eeq/32ygaAQ9dFthKpapUHBaK4h6
         AQlsIb19AsIlPv2M1JU0y/FBOD3eU1twtKpv3YnI=
Date:   Wed, 29 Jun 2022 15:30:44 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to mm-unstable branch
Message-Id: <20220629223044.C2CE1C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: reorder validate_mm_mt() checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-tracking-vmas-with-maple-tree-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: reorder validate_mm_mt() checks
Date: Tue, 28 Jun 2022 15:08:19 -0400

Allows for detecting broken trees before attempting to iterate over the tree.

Link: https://lkml.kernel.org/r/20220629153127.p2k2cqkc7qy7f3vw@revolver
Fixes: de4583ed958b (mm: start tracking VMAs with maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/mmap.c
@@ -392,6 +392,8 @@ static void validate_mm_mt(struct mm_str
 	struct vm_area_struct *vma_mt, *vma = mm->mmap;
 
 	MA_STATE(mas, mt, 0, 0);
+
+	mt_validate(&mm->mm_mt);
 	mas_for_each(&mas, vma_mt, ULONG_MAX) {
 		if (xa_is_zero(vma_mt))
 			continue;
@@ -440,7 +442,6 @@ static void validate_mm_mt(struct mm_str
 
 	}
 	VM_BUG_ON(vma);
-	mt_validate(&mm->mm_mt);
 }
 #else
 #define validate_mm_mt(root) do { } while (0)
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

android-binder-stop-saving-a-pointer-to-the-vma.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch

