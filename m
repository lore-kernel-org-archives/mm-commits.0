Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D473BC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 07:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiEIHpn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 03:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiEIHY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 03:24:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BAA1B7A5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 00:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pZMYYA0Jpqzjhy1jrjTcrtnHTOMhTQ3hu1C8xJIUIeI=; b=HXFdJ3eR80rO90++/kw7JE2kUk
        ohqxlyPB280VWJSeh0zc/hXaoZUCKFUFMTOIepAxTNy6Vr8S228m1jKouM25qvD4KI5SI1GLbxZeN
        kQdhSmfB9A5+gDVN5l9PdBFGpN4DjCis6mlvb2v3sVfEtYK44jbBA1Dh9l/Gzm/wvLie/ldF+5Mfs
        LRK1ai45w0V6awe1XVtoHxU14b+qZPKpviTSIoeicFsPLlHjKea/ARaGFzvwYvdB9+WcLDIlFzGxT
        GCScrmdX9F8yLgXtRvdYqKg+LxLYQXAmceLVfsKjEwBVpJgfheM8osgroPSZCkV+pI9HAlt0V2K7c
        w3W20scg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nnxh6-003E79-Ny; Mon, 09 May 2022 07:20:36 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D619C980E93; Mon,  9 May 2022 09:20:35 +0200 (CEST)
Date:   Mon, 9 May 2022 09:20:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        luto@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, kunyu@nfschina.com
Subject: Re: + mm-functions-may-simplify-the-use-of-return-values.patch added
 to mm-unstable branch
Message-ID: <20220509072035.GG76023@worktop.programming.kicks-ass.net>
References: <20220507175027.38900C385A6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507175027.38900C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, May 07, 2022 at 10:50:26AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: functions may simplify the use of return values
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-functions-may-simplify-the-use-of-return-values.patch
> 
> This patch should soon appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Li kunyu <kunyu@nfschina.com>
> Subject: mm: functions may simplify the use of return values
> 
> p4d_clear_huge may be optimized for void return type and function usage. 
> vunmap_p4d_range function saves a few steps here.
> 
> Link: https://lkml.kernel.org/r/20220507150630.90399-1-kunyu@nfschina.com
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Please, no:

arch/x86/mm/pgtable.c: * p4d_clear_huge - clear kernel P4D mapping when it is set
arch/x86/mm/pgtable.c:int p4d_clear_huge(p4d_t *p4d)
arch/x86/mm/pgtable.c: * pud_clear_huge - clear kernel PUD mapping when it is set
arch/x86/mm/pgtable.c:int pud_clear_huge(pud_t *pud)
arch/x86/mm/pgtable.c: * pmd_clear_huge - clear kernel PMD mapping when it is set
arch/x86/mm/pgtable.c:int pmd_clear_huge(pmd_t *pmd)

why would the p4d one need to be different from the rest?
