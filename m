Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71C0C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjDRXhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDRXfv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DB5C17C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE7762BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73017C433D2;
        Tue, 18 Apr 2023 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860902;
        bh=hcwSccTSXeXfXSRJDxa2pBzXJicbher1GwIxVbyx0Yg=;
        h=Date:To:From:Subject:From;
        b=QTKJfTcBOi7+ZL/Wn7Hqm/klaNQ0wiGVr7LSvrXzaQiEYePucC2uHInCCDOI/TdA9
         VC9C42n6eYSprdJNtqtOFJsm8JJ7RKqp6vvLpbb7pPSdyQTvSUkg7sVCHBGB7Cku83
         W0JGYNfqvjdpGc5QmdqEA33p8dJj5Cm7FXw49XN0=
Date:   Tue, 18 Apr 2023 16:35:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shuah@kernel.org,
        sam@ravnborg.org, peterx@redhat.com, hughd@google.com,
        davem@davemloft.net, anshuman.khandual@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch removed from -mm tree
Message-Id: <20230418233502.73017C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: revert "Partly revert "mm/thp: carry over dirty bit when thp splits on pmd""
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch
mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch

