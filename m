Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22242C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 17:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiLPRGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 12:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPRGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 12:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC99EBC;
        Fri, 16 Dec 2022 09:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F21B81DB7;
        Fri, 16 Dec 2022 17:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D9C433D2;
        Fri, 16 Dec 2022 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671210398;
        bh=+LdALMKk76gI2nPyPBU4rYVktT1G/vb7NADouovOTr0=;
        h=Date:To:From:Subject:From;
        b=tbjSaBorMWun5edbwhjnhvYQLmtAqcRYBUhximl13E550CDYaH3T3zgCidmfx9ObX
         UaI/SWcKC1tk+/0jy01RcRadEZL+S+hQdeNGRRltQKLObP7z3V1bUFs5Tmwflu2ulr
         qXL9cgorXlRVCLoHQ0lA3H9EJ1IEn7PgEgyiUeA8=
Date:   Fri, 16 Dec 2022 09:06:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, matenajakub@gmail.com,
        liam.howlett@oracle.com, kirill@shutemov.name,
        jirislaby@kernel.org, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20221216170638.153D9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mremap: fix mremap() expanding vma with addr inside vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mremap: fix mremap() expanding vma with addr inside vma
Date: Fri, 16 Dec 2022 17:32:27 +0100

Since 6.1 we have noticed random rpm install failures that were tracked to
mremap() returning -ENOMEM and to commit ca3d76b0aa80 ("mm: add merging
after mremap resize").

The problem occurs when mremap() expands a VMA in place, but using an
starting address that's not vma->vm_start, but somewhere in the middle. 
The extension_pgoff calculation introduced by the commit is wrong in that
case, so vma_merge() fails due to pgoffs not being compatible.  Fix the
calculation.

By the way it seems that the situations, where rpm now expands a vma from
the middle, were made possible also due to that commit, thanks to the
improved vma merging.  Yet it should work just fine, except for the buggy
calculation.

Link: https://lkml.kernel.org/r/20221216163227.24648-1-vbabka@suse.cz
Reported-by: Jiri Slaby <jirislaby@kernel.org>
  Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma
+++ a/mm/mremap.c
@@ -1016,7 +1016,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			long pages = (new_len - old_len) >> PAGE_SHIFT;
 			unsigned long extension_start = addr + old_len;
 			unsigned long extension_end = addr + new_len;
-			pgoff_t extension_pgoff = vma->vm_pgoff + (old_len >> PAGE_SHIFT);
+			pgoff_t extension_pgoff = vma->vm_pgoff +
+				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch

