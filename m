Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E74BC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjFIX1g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbjFIX1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7B63AA8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C55160FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3510C433D2;
        Fri,  9 Jun 2023 23:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353233;
        bh=6e6mPYJdIPcVWBCE3XtdCFe+lR31H1crVlbuYa/IF2c=;
        h=Date:To:From:Subject:From;
        b=vVSxE8OdcPpNkykvT9375vf2kmFWK4XueCblKr1PH6dRAtP10a3682HKH9xh3teEp
         FliyuC7ckRepu5ypjJ6p8mEfmZK/CD5x+GeS8q4iC39q+l17gox07L5gPu53YQq6yi
         e31HyxOsx7Qt6UozYnGZU5I7GhJST5uZDWZ3mCEM=
Date:   Fri, 09 Jun 2023 16:27:13 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch removed from -mm tree
Message-Id: <20230609232713.B3510C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: add missing gup_must_unshare() check to gup_huge_pgd()
has been removed from the -mm tree.  Its filename was
     mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: add missing gup_must_unshare() check to gup_huge_pgd()
Date: Sat, 6 May 2023 15:05:25 +0100

All other instances of gup_huge_pXd() perform the unshare check, so update
the PGD-specific function to do so as well.

While checking pgd_write() might seem unusual, this function already
performs such a check via pgd_access_permitted() so this is in line with
the existing implementation.

David said:

: This change makes unshare handling across all GUP-fast variants
: consistent, which is desirable as GUP-fast is complicated enough
: already even when consistent.
: 
: This function was the only one I seemed to have missed (or left out and
: forgot why -- maybe because it's really dead code for now).  The COW
: selftest would identify the problem, so far there was no report. 
: Either the selftest wasn't run on corresponding architectures with that
: hugetlb size, or that code is still dead code and unused by
: architectures.
: 
: the original commit(s) that added unsharing explain why we care about
: these checks:
: 
: a7f226604170acd6 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
: 84209e87c6963f92 ("mm/gup: reliable R/O long-term pinning in COW mappings")

Link: https://lkml.kernel.org/r/cb971ac8dd315df97058ea69442ecc007b9a364a.1683381545.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/gup.c~mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd
+++ a/mm/gup.c
@@ -2755,6 +2755,11 @@ static int gup_huge_pgd(pgd_t orig, pgd_
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

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

