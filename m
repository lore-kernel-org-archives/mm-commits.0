Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BE0C636D3
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBGB3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjBGB3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D228D2ED54
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E0E2610A6
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE24CC433D2;
        Tue,  7 Feb 2023 01:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733372;
        bh=REez/GRAy8ccSGRuCL67WZUunQzPR6qYLNrPXBamfgw=;
        h=Date:To:From:Subject:From;
        b=ljSc0KusJNg893Qwr8kK3G3/UpTTFw1ZQ/BfzfTTVbe+O21d45ejLTIyrlUZj8Qdl
         huJ1rxhpoLxywi7CCWKPIKs428vXPohnpUC3VTptNc0xk8eebd1vtfz0fGCvjb9j0Z
         L3p8uP3FY0e/tVVtoEJuE28Vo33fBBp59LzYezZY=
Date:   Mon, 06 Feb 2023 17:29:32 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch added to mm-unstable branch
Message-Id: <20230207012932.BE24CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: don't call __gup_longterm_locked() if FOLL_LONGTERM cannot be set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: don't call __gup_longterm_locked() if FOLL_LONGTERM cannot be set
Date: Tue, 24 Jan 2023 16:34:24 -0400

get_user_pages_remote(), get_user_pages_unlocked() and get_user_pages()
are never called with FOLL_LONGTERM, so directly call
__get_user_pages_locked()

The next patch will add an assertion for this.

Link: https://lkml.kernel.org/r/3-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set
+++ a/mm/gup.c
@@ -2200,8 +2200,8 @@ long get_user_pages_remote(struct mm_str
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas, locked,
-				     gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas, locked,
+				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
@@ -2238,8 +2238,8 @@ long get_user_pages(unsigned long start,
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, NULL, gup_flags | FOLL_TOUCH);
+	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
+				       vmas, NULL, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
 
@@ -2263,8 +2263,8 @@ long get_user_pages_unlocked(unsigned lo
 {
 	int locked = 0;
 
-	return __gup_longterm_locked(current->mm, start, nr_pages, pages, NULL,
-				     &locked, gup_flags | FOLL_TOUCH);
+	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
+				       NULL, &locked, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-have-internal-functions-get-the-mmap_read_lock.patch
mm-gup-remove-obsolete-foll_longterm-comment.patch
mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch
mm-gup-move-try_grab_page-to-mm-internalh.patch
mm-gup-simplify-the-external-interface-functions-and-consolidate-invariants.patch
mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch
mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch
mm-gup-add-foll_unlockable.patch
mm-gup-make-locked-never-null-in-the-internal-gup-functions.patch
mm-gup-remove-pin_user_pages_fast_only.patch
mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch
mm-gup-move-gup_must_unshare-to-mm-internalh.patch
mm-gup-move-private-gup-foll_-flags-to-internalh.patch

