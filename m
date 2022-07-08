Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B83C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiGHAUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:20:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1286EE97
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92EC3B824A7
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3942C3411E;
        Fri,  8 Jul 2022 00:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657239605;
        bh=FOQ8QNTMqnvxjmJje/VDU12Y07ifurvylkq46uM/Ork=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=syl2ahs18E7niwHRMoeUZe+tPcDKp6KW2a6+cVkQ7ANyAIYyWT6vHIEyIelEKdZIA
         IUnFCJdZmQgNa6h3+h1TDVgsJpE73KWgAtLHlDoEJ4ywQZH2fiVJXcTAk/xJT3uybH
         QJHbvtrP5Om3HFTAF24t9zS9aU4kEJc7PRro21vI=
Date:   Thu, 7 Jul 2022 17:20:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Yu Zhao <yuzhao@google.com>, mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>, dan.carpenter@oracle.com
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
 added to mm-unstable branch
Message-Id: <20220707172004.34e552dfd1d2284e6e2d211d@linux-foundation.org>
In-Reply-To: <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
References: <20220707200919.90C41C3411E@smtp.kernel.org>
        <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
        <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
        <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 8 Jul 2022 00:21:45 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> >> > add missing local_unlock_irqrestore() on contention path
> >>
> >> Doh, that's true and something to fix, although patch 7 did remove the bug
> >> later in the same series so that wouldn't explain the lkp report for patch
> >> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
> >> as I just replied there.
> > 
> > Sorry I didn't bother to reply until now: it did test v5, at this
> > commit, not the whole series.
> 
> I meant this report that appears to be for v4 (full series including patch 7):
> https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/
> That reported a bug due to missing unpin that was previously reported for v4
> and fixed in v5.
> 
> I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
> the (similar but not identical) bug fixed by this -fix would indeed be
> possible in v5 if patch 7 was not applied.

Patch 7 ("mm/page_alloc: replace local_lock with normal spinlock") has
been dropped for now due to ongoing issues, most recently
"BUG:sleeping_function_called_from_invalid_context_at_mm/gup.c".  This
droppage exposed the issue which this patch
(mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch) addresses.

