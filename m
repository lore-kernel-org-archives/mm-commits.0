Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B4EC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbhLHAIy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:08:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbhLHAIy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:08:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D625B81EB0
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72724C341C5;
        Wed,  8 Dec 2021 00:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638921921;
        bh=cjgbXTCH1GSXWXk+Mo3jAB2j5qwuadsHe230CtHJ7A8=;
        h=Date:From:To:Subject:From;
        b=nijhjOmitdIJ6HwveXEb1biUUUA7bjY8g6cKGDgEJE8fKBid/31ObOR/JbJeZvveZ
         x/7VdPNvRk03wj4XamOgb1oHPdIQAl3rfDD0z5MP04IjwAbmptFZyHa7+2b/X9wGCh
         eK13OgoLzTyOesUpUEU//uV+lo4DgQaFHkphN5bU=
Date:   Tue, 07 Dec 2021 16:05:19 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, frederic@kernel.org,
        gthelen@google.com, hpa@zytor.com, jirislaby@kernel.org,
        keescook@chromium.org, masahiroy@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        peterz@infradead.org, pjt@google.com, rientjes@google.com,
        rppt@kernel.org, samitolvanen@google.com, songmuchun@bytedance.com,
        tglx@linutronix.de, weixugc@google.com, will@kernel.org
Subject:  +
 mm-change-page-type-prior-to-adding-page-table-entry.patch added to -mm
 tree
Message-ID: <20211208000519.kltdpU54S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change page type prior to adding page table entry
has been added to the -mm tree.  Its filename is
     mm-change-page-type-prior-to-adding-page-table-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-change-page-type-prior-to-adding-page-table-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-change-page-type-prior-to-adding-page-table-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: change page type prior to adding page table entry

Patch series "page table check", v2.

Ensure that some memory corruptions are prevented by checking at the time
of insertion of entries into user page tables that there is no illegal
sharing.

We have recently found a problem [1] that existed in kernel since 4.14. 
The problem was caused by broken page ref count and led to memory leaking
from one process into another.  The problem was accidentally detected by
studying a dump of one process and noticing that one page contains memory
that should not belong to this process.

There are some other page->_refcount related problems that were recently
fixed: [2], [3] which potentially could also lead to illegal sharing.

In addition to hardening refcount [4] itself, this work is an attempt to
prevent this class of memory corruption issues.

It uses a simple state machine that is independent from regular MM logic
to check for illegal sharing at time pages are inserted and removed from
page tables.

[1] https://lore.kernel.org/all/xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com
[2] https://lore.kernel.org/all/1582661774-30925-2-git-send-email-akaher@vmware.com
[3] https://lore.kernel.org/all/20210622021423.154662-3-mike.kravetz@oracle.com
[4] https://lore.kernel.org/all/20211026173822.502506-1-pasha.tatashin@soleen.com


This patch (of 4):

In do_swap_page() we first insert the entry into user page table, and
later change the struct page to indicate that this is anonymous page.

In all other places we first configure the page metadata and then insert
entries into the page table.

While odd, the behaviour is benign.  Page table check, however, will use
the information from struct page to verify the type of entry is inserted.

Change the order in do_swap_page() to first update struct page, and later
insert pte entry into the page table.

Link: https://lkml.kernel.org/r/20211204182314.1470076-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20211204182314.1470076-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-change-page-type-prior-to-adding-page-table-entry
+++ a/mm/memory.c
@@ -3639,9 +3639,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		pte = pte_mkuffd_wp(pte);
 		pte = pte_wrprotect(pte);
 	}
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
-	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
-	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
@@ -3651,6 +3648,10 @@ vm_fault_t do_swap_page(struct vm_fault
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 	}
 
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
+	vmf->orig_pte = pte;
+
 	swap_free(entry);
 	if (mem_cgroup_swap_full(page) ||
 	    (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-change-page-type-prior-to-adding-page-table-entry.patch
mm-ptep_clear-page-table-helper.patch
mm-page-table-check.patch
x86-mm-add-x86_64-support-for-page-table-check.patch

