Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9827EC7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 21:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjDKVDo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 17:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDKVDo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 17:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F2F3594
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 14:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 525E062135
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 21:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD47C433D2;
        Tue, 11 Apr 2023 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681247021;
        bh=7FVqKP3ilgrWi9IMcHTm9ut8ikcgKam61yg4MoN+WEU=;
        h=Date:To:From:Subject:From;
        b=whQ5wumkVW/9OlZbjv4HTPyZBtCHPp4KX2w454x5ZjOLnQJybgitVaCZUl0T4ssC+
         p9zU+W+++KowBP4PmcmqOrXeM9gz92nclUM6qrLGXRhzAD57JoMiHbe+KLlNhA7F/q
         yphdLYSTG+KktXryZ/Xj01/tn+il05QYgYEYtiIk=
Date:   Tue, 11 Apr 2023 14:03:41 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shuah@kernel.org,
        sam@ravnborg.org, peterx@redhat.com, hughd@google.com,
        davem@davemloft.net, anshuman.khandual@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch added to mm-unstable branch
Message-Id: <20230411210341.ACD47C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: revert "Partly revert "mm/thp: carry over dirty bit when thp splits on pmd""
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

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
Subject: mm/huge_memory: revert "Partly revert "mm/thp: carry over dirty bit when thp splits on pmd""
Date: Tue, 11 Apr 2023 16:25:11 +0200

This reverts commit 624a2c94f5b7 ("Partly revert "mm/thp: carry over dirty
bit when thp splits on pmd"") and the fixup in commit e833bc503405
("mm/thp: re-apply mkdirty for small pages after split").

Now that sparc64 mkdirty handling is fixed and no longer sets a PTE/PMD
writable that shouldn't be writable, let's revert the temporary fix and
remove the stale comment.

The mkdirty mm selftest still passes with this change on sparc64.

Note that loongarch handling was fixed in commit bf2f34a506e6 ("LoongArch:
Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()")

Link: https://lkml.kernel.org/r/20230411142512.438404-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd
+++ a/mm/huge_memory.c
@@ -2236,18 +2236,13 @@ static void __split_huge_pmd_locked(stru
 			entry = maybe_mkwrite(entry, vma);
 			if (anon_exclusive)
 				SetPageAnonExclusive(page + i);
+			if (!write)
+				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
 			/* NOTE: this may set soft-dirty too on some archs */
 			if (dirty)
 				entry = pte_mkdirty(entry);
-			/*
-			 * NOTE: this needs to happen after pte_mkdirty,
-			 * because some archs (sparc64, loongarch) could
-			 * set hw write bit when mkdirty.
-			 */
-			if (!write)
-				entry = pte_wrprotect(entry);
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch
m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch
mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch
selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch

