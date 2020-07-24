Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1DCC433E4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC53D206F6
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595566612;
	bh=xd586bWd8pZru+min34gfFSAWUVudkSGYg+RUjq4rdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=q/llLEWRoh+b+6Urha2AruAoiFMpOz06F2FJrjcZakGkDcuyxaRbq1ZaULpiBbZTa
	 mrxNTId0Q70yZZmnoL/EtFMT7fQsfWMXQQvm/AIONM0NcudRBIfOcTyq2XRxvdMAD8
	 qwX0hkLYTgHmUbLi8mwLu1G4EcJCA8gVgI339EEI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgGXE4v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgGXE4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:56:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4A2206D8;
        Fri, 24 Jul 2020 04:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595566610;
        bh=xd586bWd8pZru+min34gfFSAWUVudkSGYg+RUjq4rdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ccxnKmzHO5cokXLktBXhxK/ZHDKzqTGmWvCmkvdEasP+rGcLN3EspZaMmaNj+/1zQ
         7tUOV9lnekwlJ4TrvD3dSyVbBGFH0x58PGY6S9oojfszE0r0HADd5pPSoI/klKM0QA
         09AGvtIJoXbUs4AyO4Bn7ftQLDUGivHinb51dM88=
Date:   Thu, 23 Jul 2020 21:56:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     catalin.marinas@arm.com, hannes@cmpxchg.org, hdanton@sina.com,
        hughd@google.com, josef@toxicpanda.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        will.deacon@arm.com, willy@infradead.org, xuyu@linux.alibaba.com
Subject: Re: [patch 01/15] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
Message-Id: <20200723215649.c7d960381117ff794c0a50f0@linux-foundation.org>
In-Reply-To: <30cf7356-bef1-c621-60cb-e12a8bd9111d@linux.alibaba.com>
References: <20200724041508.QlTbrHnfh%akpm@linux-foundation.org>
        <30cf7356-bef1-c621-60cb-e12a8bd9111d@linux.alibaba.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 23 Jul 2020 21:38:10 -0700 Yang Shi <yang.shi@linux.alibaba.com> wrote:

> > --- a/mm/memory.c~mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault
> > +++ a/mm/memory.c
> > @@ -4241,8 +4241,13 @@ static vm_fault_t handle_pte_fault(struc
> >   	if (vmf->flags & FAULT_FLAG_WRITE) {
> >   		if (!pte_write(entry))
> >   			return do_wp_page(vmf);
> > -		entry = pte_mkdirty(entry);
> >   	}
> > +
> > +	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vmf->flags & FAULT_FLAG_TRIED))
> > +		entry = pte_mkdirty(entry);
> > +	else if (vmf->flags & FAULT_FLAG_TRIED)
> > +		goto unlock;
> 
> Hi Andrew,
> 
> It looks you forgot fold v2 update?

Argh, yes, sorry.  It should have been this:


From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault

Recently we found regression when running will_it_scale/page_fault3 test
on ARM64.  Over 70% down for the multi processes cases and over 20% down
for the multi threads cases.  It turns out the regression is caused by
commit 89b15332af7c0312a41e50846819ca6613b58b4c ("mm: drop mmap_sem before
calling balance_dirty_pages() in write fault").

The test mmaps a memory size file then write to the mapping, this would
make all memory dirty and trigger dirty pages throttle, that upstream
commit would release mmap_sem then retry the page fault.  The retried page
fault would see correct PTEs installed by the first try then update dirty
bit and clear read-only bit and flush TLBs for ARM.  The regression is
caused by the excessive TLB flush.  It is fine on x86 since x86 doesn't
clear read-only bit so there is no need to flush TLB for this case.

The page fault would be retried due to:
1. Waiting for page readahead
2. Waiting for page swapped in
3. Waiting for dirty pages throttling

The first two cases don't have PTEs set up at all, so the retried page
fault would install the PTEs, so they don't reach there.  But the #3 case
usually has PTEs installed, the retried page fault would reach the dirty
bit and read-only bit update.  But it seems not necessary to modify those
bits again for #3 since they should be already set by the first page fault
try.

Of course the parallel page fault may set up PTEs, but we just need care
about write fault.  If the parallel page fault setup a writable and dirty
PTE then the retried fault doesn't need do anything extra.  If the
parallel page fault setup a clean read-only PTE, the retried fault should
just call do_wp_page() then return as the below code snippet shows:

if (vmf->flags & FAULT_FLAG_WRITE) {
        if (!pte_write(entry))
            return do_wp_page(vmf);
}

With this fix the test result get back to normal.

[yang.shi@linux.alibaba.com: incorporate comment from Will Deacon, update commit log per discussion]
  Link: http://lkml.kernel.org/r/1594848990-55657-1-git-send-email-yang.shi@linux.alibaba.com
Link: http://lkml.kernel.org/r/1594148072-91273-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Xu Yu <xuyu@linux.alibaba.com>
Debugged-by: Xu Yu <xuyu@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault
+++ a/mm/memory.c
@@ -4241,8 +4241,14 @@ static vm_fault_t handle_pte_fault(struc
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
 			return do_wp_page(vmf);
-		entry = pte_mkdirty(entry);
 	}
+
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		goto unlock;
+
+	if (vmf->flags & FAULT_FLAG_WRITE)
+		entry = pte_mkdirty(entry);
+
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
_

