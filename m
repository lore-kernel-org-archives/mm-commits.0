Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04ACFC197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 15:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjKQPgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 10:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjKQPgj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 10:36:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6E8127;
        Fri, 17 Nov 2023 07:36:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285DAC433C8;
        Fri, 17 Nov 2023 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700235395;
        bh=wXakN8pMOWsk0ZXqndIFqKlC9dd0Fuq6EXWTvhojRfQ=;
        h=Date:To:From:Subject:From;
        b=ql6qVPMV2s+iFM7wRpQW0V2vPIekA0r08CqAn1O0ICPEo6KsruOyeYMN3kBax68xI
         OIWLvLmMbQlyS62xBTF0LofkF5ZRuCuA0ga23jFMffjof4v7TzAAkdGggy25Iv8tjP
         NkgRp7+bcROmS7U/bdIoB88md+cDHi0/DvoA+D6A=
Date:   Fri, 17 Nov 2023 07:36:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jose.pekkarinen@foxhound.fi, jannh@google.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-oops-when-filemap_map_pmd-without-prealloc_pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20231117153635.285DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix oops when filemap_map_pmd() without prealloc_pte
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-oops-when-filemap_map_pmd-without-prealloc_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-oops-when-filemap_map_pmd-without-prealloc_pte.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix oops when filemap_map_pmd() without prealloc_pte
Date: Fri, 17 Nov 2023 00:49:18 -0800 (PST)

syzbot reports oops in lockdep's __lock_acquire(), called from
__pte_offset_map_lock() called from filemap_map_pages(); or when I run the
repro, the oops comes in pmd_install(), called from filemap_map_pmd()
called from filemap_map_pages(), just before the __pte_offset_map_lock().

The problem is that filemap_map_pmd() has been assuming that when it finds
pmd_none(), a page table has already been prepared in prealloc_pte; and
indeed do_fault_around() has been careful to preallocate one there, when
it finds pmd_none(): but what if *pmd became none in between?

My 6.6 mods in mm/khugepaged.c, avoiding mmap_lock for write, have made it
easy for *pmd to be cleared while servicing a page fault; but even before
those, a huge *pmd might be zapped while a fault is serviced.

The difference in symptomatic stack traces comes from the "memory model"
in use: pmd_install() uses pmd_populate() uses page_to_pfn(): in some
models that is strict, and will oops on the NULL prealloc_pte; in other
models, it will construct a bogus value to be populated into *pmd, then
__pte_offset_map_lock() oops when trying to access split ptlock pointer
(or some other symptom in normal case of ptlock embedded not pointer).

Link: https://lore.kernel.org/linux-mm/20231115065506.19780-1-jose.pekkarinen@foxhound.fi/
Link: https://lkml.kernel.org/r/6ed0c50c-78ef-0719-b3c5-60c0c010431c@google.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-and-tested-by: syzbot+89edd67979b52675ddec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/0000000000005e44550608a0806c@google.com/
Cc: Jann Horn <jannh@google.com>,
Cc: José Pekkarinen <jose.pekkarinen@foxhound.fi>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>    [5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-fix-oops-when-filemap_map_pmd-without-prealloc_pte
+++ a/mm/filemap.c
@@ -3371,7 +3371,7 @@ static bool filemap_map_pmd(struct vm_fa
 		}
 	}
 
-	if (pmd_none(*vmf->pmd))
+	if (pmd_none(*vmf->pmd) && vmf->prealloc_pte)
 		pmd_install(mm, vmf->pmd, &vmf->prealloc_pte);
 
 	return false;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-oops-when-filemap_map_pmd-without-prealloc_pte.patch

