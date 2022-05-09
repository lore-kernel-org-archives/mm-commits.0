Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD78C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 17:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbiEIRLJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiEIRK7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 13:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D858FEAD09
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 10:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 769326153F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D123C385AC;
        Mon,  9 May 2022 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652116024;
        bh=BUgBJ8/6iwaMzLQEG7CHIivwo8XWltJIo//+HIEqxwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hDEkWo/V8Y75KGOuCfSFTJ/VGGs3zal9cxNlJkp/eg+OogyThWMElaLczK1QwFCyA
         sWVOq551AWdWko1MQiyVVQYBQMFqQjLthX9J5cxbNdadQW9kkfXIBq8kBo2vuy1lS/
         3AHI4EFJ5Oc0ZsASpGxSbMzmFswNJcjotrnGeUw0=
Date:   Mon, 9 May 2022 10:07:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        luto@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, kunyu@nfschina.com
Subject: Re: + mm-functions-may-simplify-the-use-of-return-values.patch
 added to mm-unstable branch
Message-Id: <20220509100703.1ae1c1b6a9189fdec46ecd41@linux-foundation.org>
In-Reply-To: <20220509072035.GG76023@worktop.programming.kicks-ass.net>
References: <20220507175027.38900C385A6@smtp.kernel.org>
        <20220509072035.GG76023@worktop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 9 May 2022 09:20:35 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> 
> Please, no:
> 
> arch/x86/mm/pgtable.c: * p4d_clear_huge - clear kernel P4D mapping when it is set
> arch/x86/mm/pgtable.c:int p4d_clear_huge(p4d_t *p4d)
> arch/x86/mm/pgtable.c: * pud_clear_huge - clear kernel PUD mapping when it is set
> arch/x86/mm/pgtable.c:int pud_clear_huge(pud_t *pud)
> arch/x86/mm/pgtable.c: * pmd_clear_huge - clear kernel PMD mapping when it is set
> arch/x86/mm/pgtable.c:int pmd_clear_huge(pmd_t *pmd)
> 
> why would the p4d one need to be different from the rest?

Because the p4d one doesn't return anything, whereas the others do?

Any code which tests the p4d_clear_huge() return value is probably
buggy, so making p4d_clear_huge() return void permits us to detect such
a bug with the C type system.
