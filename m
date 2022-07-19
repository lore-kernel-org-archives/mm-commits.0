Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DBDC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiGSTEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiGSTEC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB64E52FD4
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F470617D0
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686FCC341C6;
        Tue, 19 Jul 2022 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658257440;
        bh=3m1t3Hi9dnOjBxJuoWJqmRANtm9EzJKz+Q8USdyOYkA=;
        h=Date:To:From:Subject:From;
        b=Aj4dKLAyKVreEzFdQzWXiX7MFGaSymFZzHR6nj/FrUelnuqUoodznmpqUGabkiZ6c
         JaGm+P+680Xv4IES2vQKVqpNQdKVurPP5nIPOKe8i1bqDDzRITEM6JzWy4lousgLbD
         ndQc85WKTbC87kSza+1QQI9YHhiDTXQaIk0qfNxg=
Date:   Tue, 19 Jul 2022 12:03:59 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hughd@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch added to mm-unstable branch
Message-Id: <20220719190400.686FCC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: remove unroll from vma_expand()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch

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
Subject: mmap: remove unroll from vma_expand()
Date: Tue, 19 Jul 2022 18:50:01 +0000

Undoing the anon vma work is no necessary since it will be handled by
the caller in the freeing of the VMA, or in the OOM that is happening.

Link: https://lkml.kernel.org/r/20220719184959.3360032-1-Liam.Howlett@oracle.com
Fixes: d8bb385648a5 (mm/mmap: use advanced maple tree API for mmap_region())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix
+++ a/mm/mmap.c
@@ -623,7 +623,6 @@ inline int vma_expand(struct ma_state *m
 	struct anon_vma *anon_vma = vma->anon_vma;
 	struct file *file = vma->vm_file;
 	bool remove_next = false;
-	bool anon_cloned = false;
 
 	if (next && (vma != next) && (end == next->vm_end)) {
 		remove_next = true;
@@ -635,7 +634,6 @@ inline int vma_expand(struct ma_state *m
 			error = anon_vma_clone(vma, next);
 			if (error)
 				return error;
-			anon_cloned = true;
 		}
 	}
 
@@ -718,8 +716,6 @@ inline int vma_expand(struct ma_state *m
 	return 0;
 
 nomem:
-	if (anon_cloned)
-		unlink_anon_vmas(vma);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

