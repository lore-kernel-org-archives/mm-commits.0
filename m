Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5DEC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Feb 2022 10:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiBBKTy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Feb 2022 05:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiBBKTy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2022 05:19:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28592C061714
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 02:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YbiM6kXW8GMWsP8gMnvpx8WRF1MgdnY/2SbYhXR6R5E=; b=RHmacczI641gK6+m+UC+xLVsz8
        nmjgiu1DVVY1vDtz/y2VP4AuCVJFwx1wm0Qccl7cN4rtEL+JmzcTxJopr5F711jOweiFTwFsHq9Tc
        aejjqF/DylsPHni1KEr2MKIpA1Ur0wtt4V9ZGws02ieM+foFN6uD7nEMcWw+1c+LH9xExx5oOj5CN
        eYNcc+E6gbzLTYaGeZz4e6uOga58UqtckWqLUpydRnphGMVkO/jvf8umOkM8bI1liP26zEJJlw8ZP
        ouof0geQ0gCVukDw0vBuCkTxU+qFA6QVeAS0oVrIZz3Z+TceSIW4omWESzVTN9sNCcZYlLl/KJ/JV
        HWCCDqcw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFCjX-00EN3V-Ou; Wed, 02 Feb 2022 10:19:28 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5DDB198327C; Wed,  2 Feb 2022 11:19:26 +0100 (CET)
Date:   Wed, 2 Feb 2022 11:19:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        osalvador@suse.de, mhocko@suse.com, mgorman@techsingularity.net,
        hasanalmaruf@fb.com, feng.tang@intel.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com
Subject: Re: +
 numa-balancing-optimize-page-placement-for-memory-tiering-system.patch added
 to -mm tree
Message-ID: <20220202101926.GY20638@worktop.programming.kicks-ass.net>
References: <20220201222010.E9F39C340EB@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201222010.E9F39C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Feb 01, 2022 at 02:20:10PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: NUMA balancing: optimize page placement for memory tiering system
> has been added to the -mm tree.  Its filename is
>      numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Huang Ying <ying.huang@intel.com>
> Subject: NUMA balancing: optimize page placement for memory tiering system

I'm thinking this is a bit soon, current stuff is all sorts of broken
in the presence of memory only nodes.

I *really* want to see all that fixed before we merge this stuff.
