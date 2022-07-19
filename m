Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0504C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiGSTFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiGSTEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105E52FCB
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4630B617D0
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFFBC341C6;
        Tue, 19 Jul 2022 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658257483;
        bh=eRk1XKQ+AoD4pUizHvR8om7mugg5TCzX96tItWN9Ej4=;
        h=Date:To:From:Subject:From;
        b=z9G7Uu+m5mUe+QDyjVNkhizrNh4s7J96eULXr6V60tHtLv3ZhtahNAQdbdZ6N6CFX
         Z3YnXygJ9+I65Ns9CqcPFHxSsR6QL4ti2B4DGT5+BRktFlmmKj3cez5WL3phUv1YkJ
         rxr+4O8ppAxa1V2ykvjPeWiexsaRev9QKY23oIlg=
Date:   Tue, 19 Jul 2022 12:04:42 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hughd@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to mm-unstable branch
Message-Id: <20220719190443.5DFFBC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: remove unroll from __vma_adjust()
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: remove unroll from __vma_adjust()
Date: Tue, 19 Jul 2022 18:49:48 +0000

If __vma_adjust() fails, then there is no reason to undo the anon vma work
since it will be done in the caller or we have been OOMed.

Link: https://lkml.kernel.org/r/20220719184938.3359932-1-Liam.Howlett@oracle.com
Fixes: 83651ef5048d (mm: start tracking VMAs with maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/mmap.c
@@ -923,12 +923,8 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
-
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
-		if (exporter && exporter->anon_vma)
-			unlink_anon_vmas(importer);
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	if (file) {
 		mapping = file->f_mapping;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

