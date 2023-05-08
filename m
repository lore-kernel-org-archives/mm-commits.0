Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3308DC77B75
	for <mm-commits@archiver.kernel.org>; Mon,  8 May 2023 00:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjEHAb6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 7 May 2023 20:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjEHAb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 7 May 2023 20:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DFB86AC
        for <mm-commits@vger.kernel.org>; Sun,  7 May 2023 17:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB3D61086
        for <mm-commits@vger.kernel.org>; Mon,  8 May 2023 00:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B631C433D2;
        Mon,  8 May 2023 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683505916;
        bh=9fKONVdM2jLNu+umImc6SozanZlXlDYZ5M0SAkYZAuk=;
        h=Date:To:From:Subject:From;
        b=LWADrMZApLoAaQgELHJAwCK4w1qPkuSt5Cm0eWrEFO6grnzX4oWtjzoOnj9//wOmy
         lp+QS3VhhmHJVLddaNH82cRxW29SMt9e/QRZr8X+eMpsg3MC2Y6yFTI9PJdMNNhoNh
         Rp369NEJ/173X9CKMgc+QcpMb8+hVyT9W3eWthJI=
Date:   Sun, 07 May 2023 17:31:55 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch added to mm-unstable branch
Message-Id: <20230508003156.3B631C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add missing gup_must_unshare() check to gup_huge_pgd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: add missing gup_must_unshare() check to gup_huge_pgd()
Date: Sat, 6 May 2023 15:05:25 +0100

All other instances of gup_huge_pXd() perform the unshare check, so update
the PGD-specific function to do so as well.

While checking pgd_write() might seem unusual, this function already
performs such a check via pgd_access_permitted() so this is in line with
the existing implementation.

Link: https://lkml.kernel.org/r/cb971ac8dd315df97058ea69442ecc007b9a364a.1683381545.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/gup.c~mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd
+++ a/mm/gup.c
@@ -2898,6 +2898,11 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		return 0;
 	}
 
+	if (!pgd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	*nr += refs;
 	folio_set_referenced(folio);
 	return 1;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch

