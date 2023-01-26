Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB03C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjAZBD2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbjAZBDJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:03:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7912F17
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28AA0B81C68
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF7C433D2;
        Thu, 26 Jan 2023 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674694983;
        bh=c2qzkT6htsNQ8MC1j1xZQjwKKZEbK/O7AQ8MF2l94pQ=;
        h=Date:To:From:Subject:From;
        b=mo1ZgP24b2MmDSSkgY48iTG+sGyJvwKYNZ5B18DyWedpXFDKoD2UVs+mBnYRy8F2m
         8jLMus9i444EO8dgS77qO+bB9Abm/xWwVzHWZihsxwwvXq/Z22pLkoypt1ow7g+VwY
         /Vv1xoTiltR7DsKtKfUMkj9PQUvVkonO6ukX11Wk=
Date:   Wed, 25 Jan 2023 17:03:03 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+1d9ec4d1a334ae9e1ca6@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-use-split_vma-instead-of-__split_vma-fix.patch added to mm-unstable branch
Message-Id: <20230126010303.B6BF7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: fix VMA_ITERATOR start position
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-use-split_vma-instead-of-__split_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-use-split_vma-instead-of-__split_vma-fix.patch

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
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: mm/madvise: fix VMA_ITERATOR start position
Date: Wed, 25 Jan 2023 08:58:09 -0500

The WARN_ON() in vma_iter_store() detected an invalid VMA iterator state. 
Inspecting the code stack from the report shows that the VMA iterator is
never set to the correct start position.

Setting the initialization of the VMA iterator to use the address 'start'
fixes this issue.

Link: https://lkml.kernel.org/r/20230125135809.85262-1-Liam.Howlett@oracle.com
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+1d9ec4d1a334ae9e1ca6@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/madvise.c~madvise-use-split_vma-instead-of-__split_vma-fix
+++ a/mm/madvise.c
@@ -142,7 +142,7 @@ static int madvise_update_vma(struct vm_
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
-	VMA_ITERATOR(vmi, mm, 0);
+	VMA_ITERATOR(vmi, mm, start);
 
 	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
madvise-use-split_vma-instead-of-__split_vma-fix.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch

