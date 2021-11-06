Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B8AC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 22:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F55610FD
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 22:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhKFWv6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 18:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhKFWv6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 18:51:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EDAC061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 15:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IqU1R3ik7BOcpROB1BbZqusi4ymhENZ5I6p76smXUHY=; b=SnrLECYEnTV1bbGo5b8isr5LMv
        uxutafHBDzlekq5TbDvaQbLw/QGmyvgRBVTAy22tEJ1AXMEcyg7Ew9rgcvvtkRtckMkANKm+Jdt8z
        Newi+UHuuES42RerDAV3GgdtB+9JOuqQbGreH530K0nbN/K/aKjmogu6nZJVZ0BTgRfjN8302b12W
        KyUwYvBNzVXMlFGpOPPbGud7uyxojN9s0JbWmxBSLPtgvelMGasVLg3YpLJUn2RtneiEZZ/rFSSJD
        Nr7KbPGptM+AnaKCoeL4MA4EQxtjPmzDzGV/qSEfjEI5z9HXSX3HCT1PoJHnOTvGBo1yWvuycEl5Y
        MEoIpOyg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjURK-007UCr-7G; Sat, 06 Nov 2021 22:45:57 +0000
Date:   Sat, 6 Nov 2021 22:45:34 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@surriel.com>,
        Theodore Ts'o <tytso@mit.edu>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some writeback
 completes if congested
Message-ID: <YYcFjgDQRc0H/X/z@casper.infradead.org>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org>
 <YYWb5jTLkNRUI6ea@casper.infradead.org>
 <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
 <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Nov 06, 2021 at 02:12:02PM -0700, Linus Torvalds wrote:
> On Sat, Nov 6, 2021 at 1:49 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This workflow can result in more conflicts for me than what Andrew
> > used to do ("send against current linus tip"), but it means that when
> > conflicts happen, they get all the merge resolution help that git
> > gives you, and hopefully what gets tested (over the months that it can
> > be in -mm) is closer to what gets sent to me.
> 
> .. and resolving the conflicts (none of which looked bad), I think
> that part of the resolution ends up doing very similar things to your
> fixup patch.

Reviewed what you did in the merge commit, looks good to me.  And I've
learned I need to run git log --cc instead of -p in order to see all
changes to a file.
