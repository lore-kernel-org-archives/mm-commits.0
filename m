Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D18E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjJFTUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjJFTUa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68783F9
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E20C433C7;
        Fri,  6 Oct 2023 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620026;
        bh=dANjNMUMD+ISN/jE35x7k0cTb/gXGbg2l29z/0b13Kg=;
        h=Date:To:From:Subject:From;
        b=yxVtW57IsT3/5D149zmoSJhRMc/2XJ/0pMameXCZhqDERKGOSGkplhWfIQwG1GzaU
         aDuaSyLxsQEimvovlDXuo1UejZ6h4wN6wAJfXMQZp6R79lt9AldHJZjcUMvwNiGNFJ
         IbivQ/2v0iNTdAYoBQviC0RgrdlCkCeR3o/X0a4s=
Date:   Fri, 06 Oct 2023 12:20:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ssengar@microsoft.com, shy828301@gmail.com, ryan.roberts@arm.com,
        david@redhat.com, zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-mm-thp-kill-__transhuge_page_enabled.patch added to mm-unstable branch
Message-Id: <20231006192025.B5E20C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-fix-mm-thp-kill-__transhuge_page_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-fix-mm-thp-kill-__transhuge_page_enabled.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"
Date: Mon, 25 Sep 2023 13:01:10 -0700

The 6.0 commits:

commit 9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
commit 7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")

merged "can we have THPs in this VMA?" logic that was previously done
separately by fault-path, khugepaged, and smaps "THPeligible" checks.

During the process, the semantics of the fault path check changed in two
ways:

1) A VM_NO_KHUGEPAGED check was introduced (also added to smaps path).
2) We no longer checked if non-anonymous memory had a vm_ops->huge_fault
   handler that could satisfy the fault.  Previously, this check had been
   done in create_huge_pud() and create_huge_pmd() routines, but after
   the changes, we never reach those routines.

During the review of the above commits, it was determined that in-tree
users weren't affected by the change; most notably, since the only
relevant user (in terms of THP) of VM_MIXEDMAP or ->huge_fault is DAX,
which is explicitly approved early in approval logic.  However, this was a
bad assumption to make as it assumes the only reason to support
->huge_fault was for DAX (which is not true in general).

Remove the VM_NO_KHUGEPAGED check when not in collapse path and give any
->huge_fault handler a chance to handle the fault.  Note that we don't
validate the file mode or mapping alignment, which is consistent with the
behavior before the aforementioned commits.

Link: https://lkml.kernel.org/r/20230925200110.1979606-1-zokeefe@google.com
Fixes: 7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
Reported-by: Saurabh Singh Sengar <ssengar@microsoft.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-mm-thp-kill-__transhuge_page_enabled
+++ a/mm/huge_memory.c
@@ -100,11 +100,11 @@ bool hugepage_vma_check(struct vm_area_s
 		return in_pf;
 
 	/*
-	 * Special VMA and hugetlb VMA.
+	 * khugepaged special VMA and hugetlb VMA.
 	 * Must be checked after dax since some dax mappings may have
 	 * VM_MIXEDMAP set.
 	 */
-	if (vm_flags & VM_NO_KHUGEPAGED)
+	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
 		return false;
 
 	/*
@@ -132,12 +132,18 @@ bool hugepage_vma_check(struct vm_area_s
 					   !hugepage_flags_always())))
 		return false;
 
-	/* Only regular file is valid */
-	if (!in_pf && file_thp_enabled(vma))
-		return true;
-
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(vma)) {
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
+			return true;
+		/* Only regular file is valid in collapse path */
+		if (((!in_pf || smaps)) && file_thp_enabled(vma))
+			return true;
 		return false;
+	}
 
 	if (vma_is_temporary_stack(vma))
 		return false;
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-thp-fix-mm-thp-kill-__transhuge_page_enabled.patch

