Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E08C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjDRXhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjDRXfv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F569C654
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EBE562CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8621FC433D2;
        Tue, 18 Apr 2023 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860903;
        bh=ncyXoicP7I827ZdXgb01KaR9EI9deQmjlNLhu5wVAM8=;
        h=Date:To:From:Subject:From;
        b=uvTdQJ/H2PYFiLScUWPdSwISX0TMsQ6ZaaJwGnpokyE0pQN5c6f/mzsrB5PAvzbAT
         /ig107SOfEZCgT5gQpcJsXmaok/kdLZB7sMzsKkoNTg90iYAzXsQRyjBKCjRtD5sTk
         PRxUqJM2Eq914KpNhvR5FidU2aNiveTuGWPbTyVw=
Date:   Tue, 18 Apr 2023 16:35:02 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shuah@kernel.org,
        sam@ravnborg.org, peterx@redhat.com, hughd@google.com,
        davem@davemloft.net, anshuman.khandual@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch removed from -mm tree
Message-Id: <20230418233503.8621FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: conditionally call maybe_mkwrite() and drop pte_wrprotect() in __split_huge_pmd_locked()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: conditionally call maybe_mkwrite() and drop pte_wrprotect() in __split_huge_pmd_locked()
Date: Tue, 11 Apr 2023 16:25:12 +0200

No need to call maybe_mkwrite() to then wrprotect if the source PMD was not
writable.

It's worth nothing that this now allows for PTEs to be writable even if
the source PMD was not writable: if vma->vm_page_prot includes write
permissions.

As documented in commit 931298e103c2 ("mm/userfaultfd: rely on
vma->vm_page_prot in uffd_wp_range()"), any mechanism that intends to
have pages wrprotected (COW, writenotify, mprotect, uffd-wp, softdirty,
...) has to properly adjust vma->vm_page_prot upfront, to not include
write permissions. If vma->vm_page_prot includes write permissions, the
PTE/PMD can be writable as default.

This now mimics the handling in mm/migrate.c:remove_migration_pte() and in
mm/huge_memory.c:remove_migration_pmd(), which has been in place for a
long time (except that 96a9c287e25d ("mm/migrate: fix wrongly apply write
bit after mkdirty on sparc64") temporarily changed it).

Link: https://lkml.kernel.org/r/20230411142512.438404-7-david@redhat.com
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

 mm/huge_memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2233,11 +2233,10 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_swp_mkuffd_wp(entry);
 		} else {
 			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
-			entry = maybe_mkwrite(entry, vma);
+			if (write)
+				entry = maybe_mkwrite(entry, vma);
 			if (anon_exclusive)
 				SetPageAnonExclusive(page + i);
-			if (!write)
-				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
 			/* NOTE: this may set soft-dirty too on some archs */
_

Patches currently in -mm which might be from david@redhat.com are

mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch

