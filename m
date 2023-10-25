Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CF1C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbjJYXus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbjJYXtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACB210FE
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADDCC433C8;
        Wed, 25 Oct 2023 23:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277753;
        bh=xsdDU7jzKxwG7GyKWx3cyESX7m/93D4x8jthMKAmnsU=;
        h=Date:To:From:Subject:From;
        b=SmcEyKyzjy2qUNJM+9cx5GvFTIJUyfKeJcZNXcSwdCYUiNiY7j8y5gjIsnTcOPIau
         710g0iKrcQ7DuurlnbkGLzcHlqdAN8SqnZdSJx5/tnC5x5/QabTkjm3kcdf5MCLWwT
         Yow2NTNlR+g6o6l7hLZdWrp6NBSX21bjjyKGbl5g=
Date:   Wed, 25 Oct 2023 16:49:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, shr@devkernel.io,
        lstoakes@gmail.com, fengwei.yin@intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-avoid-folio_within_range-on-ksm-pages.patch removed from -mm tree
Message-Id: <20231025234912.EADDCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mlock: avoid folio_within_range() on KSM pages
has been removed from the -mm tree.  Its filename was
     mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: mlock: avoid folio_within_range() on KSM pages
Date: Mon, 23 Oct 2023 23:38:41 -0700 (PDT)

Since commit dc68badcede4 ("mm: mlock: update mlock_pte_range to handle
large folio") I've just occasionally seen VM_WARN_ON_FOLIO(folio_test_ksm)
warnings from folio_within_range(), in a splurge after testing with KSM
hyperactive.

folio_referenced_one()'s use of folio_within_vma() is safe because it
checks folio_test_large() first; but allow_mlock_munlock() needs to do the
same to avoid those warnings (or check !folio_test_ksm() itself?  Or move
either check into folio_within_range()?  Hard to tell without more
examples of its use).

Link: https://lkml.kernel.org/r/23852f6a-5bfa-1ffd-30db-30c5560ad426@google.com
Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mlock.c~mm-mlock-avoid-folio_within_range-on-ksm-pages
+++ a/mm/mlock.c
@@ -346,6 +346,10 @@ static inline bool allow_mlock_munlock(s
 	if (!(vma->vm_flags & VM_LOCKED))
 		return true;
 
+	/* folio_within_range() cannot take KSM, but any small folio is OK */
+	if (!folio_test_large(folio))
+		return true;
+
 	/* folio not in range [start, end), skip mlock */
 	if (!folio_within_range(folio, vma, start, end))
 		return false;
_

Patches currently in -mm which might be from hughd@google.com are


