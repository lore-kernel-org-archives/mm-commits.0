Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076F1C76188
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 19:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjDETzC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 15:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjDETyw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 15:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5222121
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 12:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E90362924
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D5FC433D2;
        Wed,  5 Apr 2023 19:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680724490;
        bh=lI8d1IlXo6duQqa2iqRXeD+HV7ajQ9h3r0XRloaxTws=;
        h=Date:To:From:Subject:From;
        b=r1kFKawMRmi7UcgnowFJ/RN+pa1wSTN71X1mNA8xebJHjTLv9s7aSIa6O6W1pB/to
         xzCtFoAmImAfTeJMIqD8+ln6APoOOjBkkWdhTrEyGwBrO3BtKC8BKx0ryZtfEDg9SJ
         Z8ielxodhpa0Ot2Xso1X34Qy6Rn0l9e9bd18iZB0=
Date:   Wed, 05 Apr 2023 12:54:50 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        peterx@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch added to mm-unstable branch
Message-Id: <20230405195450.A6D5FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: don't consider uffd-wp bit of writable migration entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: don't consider uffd-wp bit of writable migration entries
Date: Wed, 5 Apr 2023 18:02:36 +0200

If we end up with a writable migration entry that has the uffd-wp bit set,
we already messed up: the source PTE/PMD was writable, which means we
could have modified the page without notifying uffd first.  Setting the
uffd-wp bit always implies converting migration entries to !writable
migration entries.

Commit 8f34f1eac382 ("mm/userfaultfd: fix uffd-wp special cases for
fork()") documents that "3.  Forget to carry over uffd-wp bit for a write
migration huge pmd entry", but it doesn't really say why that should be
relevant.

So let's remove that code to avoid hiding an eventual underlying issue (in
the future, we might want to warn when creating writable migration entries
that have the uffd-wp bit set -- or even better when turning a PTE
writable that still has the uffd-wp bit set).

This now matches the handling for hugetlb migration entries in
hugetlb_change_protection().

In copy_huge_pmd()/copy_nonpresent_pte()/copy_hugetlb_page_range(), we
still transfer the uffd-bit also for writable migration entries, but
simply because we have unified handling for "writable" and
"readable-exclusive" migration entries, and we care about transferring the
uffd-wp bit for the latter.

Link: https://lkml.kernel.org/r/20230405160236.587705-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 mm/mprotect.c    |    2 --
 2 files changed, 4 deletions(-)

--- a/mm/huge_memory.c~mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries
+++ a/mm/huge_memory.c
@@ -1845,8 +1845,6 @@ int change_huge_pmd(struct mmu_gather *t
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
-			if (pmd_swp_uffd_wp(*pmd))
-				newpmd = pmd_swp_mkuffd_wp(newpmd);
 		} else {
 			newpmd = *pmd;
 		}
--- a/mm/mprotect.c~mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries
+++ a/mm/mprotect.c
@@ -223,8 +223,6 @@ static long change_pte_range(struct mmu_
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
-				if (pte_swp_uffd_wp(oldpte))
-					newpte = pte_swp_mkuffd_wp(newpte);
 			} else if (is_writable_device_private_entry(entry)) {
 				/*
 				 * We do not preserve soft-dirtiness. See
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch
m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch
mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch

